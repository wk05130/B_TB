#!/usr/bin/perl
use threads;
use threads::shared;

my $run_thread_num_p = $ARGV[0];
my $reg_list = $ARGV[1];

my @reg_run_opt_lst;
my $reg_time;
my $make_cmd; 
my $run_thread_num_all;
my $cmp_thread_num;
my $case_thread_num;


#MAIN
$reg_time = readpipe("date \"+%Y-%m-%d-%H-%M-%S\"");
chomp $reg_time;
$make_cmd = "make -f $ENV{SIM_ROOT}/sim/prj_make.mk";
open(reg_f, $reg_list) or die "can not op regression list file $reg_list \n";

while (<reg_f>) {
    chomp $_;
    if ($_ =~ /^\s*#/) {}  #filter line start with # for comment
    elsif ($_ =~ /^\s*$/) {} #filter blank line
    else  { #filter line start with # for comment
        push @reg_run_opt_lst,"REG_TIME=$reg_time REGRESS=on ".$_;
    }
}
close(reg_f);
$run_thread_num_all = @reg_run_opt_lst;

$cmp_thread_num = &tb_cmp($reg_time);
$case_thread_num = &run_case($run_thread_num_all, $run_thread_num_p);
system("rm -rf $ENV{SIM_WORK}/regress/$reg_time/soc_sim_cmp");
&gen_reg_rpt($run_thread_num_all, $reg_time);
printf "%d  threads finished, total need %d\n",   $case_thread_num + $cmp_thread_num,  $run_thread_num_all + $cmp_thread_num;

#test bench compile sub function, 3 thereads need
sub tb_cmp {
    my $cmp_tbench_thread0;
    my $date_time = $_[0];
    print "compiling test bench.....\n";
    $cmp_tbench_thread0 = threads->create (\&thread_mk, "cmp   REG_TIME=$date_time REGRESS=on FSDB_DUMP=off VPD_DUMP=off CPU_SEL=NONE COV=on");
    $cmp_tbench_thread0 -> join();
    print "compileing test bench finished!\n";
    return 1;
}

#case simulation threads num equals parameter, 
sub run_case {
    my $total_threads_num = $_[0];
    my $paralell_threads_num = $_[1];
    my @thread_a;
    my $thread_index;
    my $thread_finished = 0;
    my $reg_index;

    print "runing test cases......\n";
    $reg_index = 0;
    if ($total_threads_num <= $paralell_threads_num) {
         for ($thread_index = 0; $thread_index < $total_threads_num; $thread_index++ ) {
            $thread_a[$thread_index] = threads->create (\&thread_run, $reg_run_opt_lst[$reg_index++]);
         }
    }
    else {
        for ($thread_index = 0; $thread_index < $paralell_threads_num; $thread_index++ ) {
            $thread_a[$thread_index] = threads->create (\&thread_run, $reg_run_opt_lst[$reg_index++]);
        }
    }
    
    if ($total_threads_num <= $paralell_threads_num) {
        while ($thread_finished < $total_threads_num) {
           for ($thread_index = 0; $thread_index < $total_threads_num; $thread_index++) {
               if ($thread_a[$thread_index]-> is_joinable()) {
                    $thread_a[$thread_index] -> join();
                    $thread_finished++;
               }
           }
           sleep 5;
        }
    }
    else {
        while ($thread_finished < $total_threads_num) {
           for ($thread_index = 0; $thread_index < $paralell_threads_num; $thread_index++) {
               if ($thread_a[$thread_index]-> is_joinable()) {
                    $thread_a[$thread_index] -> join();
                    $thread_finished++;
                    if ($thread_finished + $paralell_threads_num   <= $total_threads_num ) {  # after thread create total $thread_finished + $paralell_threads_num will finihshed
                        $thread_a[$thread_index] = threads->create (\&thread_run, $reg_run_opt_lst[$reg_index++]);
                    }
               }
           }
           sleep 5;
        }
    }
    print "runing test cases finished!\n";
    return $thread_finished;
}

#generate regress report, regress report also return as array
sub gen_reg_rpt{
    my @reg_sim_dir;
    my $local_str;
    my @regress_result;
    my $pass_case_num = 0;
    my $fail_case_num = 0;
    my $timeout_case_num = 0;
    my $not_start_case_num = 0;
    my $no_result_case_num = 0;

    my $sv_case_name;
    my $user_s;
    my $total_cases_num = $_[0];
    my $date_time = $_[1];
    my $index = 0;
    my $sim_seed;

    opendir(sim_dir, "$ENV{SIM_WORK}/regress/$date_time") or die "can not op regression dir \n";
    @reg_sim_dir = readdir(sim_dir);
    close (sim_dir);
    foreach (@reg_sim_dir){
        if ($_ =~ /^soc_sim_run\.(\w+)\.*([\w\-\.]*)/) {
            $sv_case_name = $1;
            if ($2 ne "") { #no user specified run dir
                $user_s = $2;
            }
            else {
                $user_s = "NA";
            }
            if (open(sim_log_f, "<$ENV{SIM_WORK}/regress/$date_time/$_/vcs_run.log") ) {
                while (<sim_log_f>) {
                    if ($_ =~ /\+ntb_random_seed=([\d]+)/) {
                        $sim_seed = $1;
                    }
                    if ($_ =~ /CASE_SIMULATION_PASS/) {
                        $local_str = sprintf "%-15d %-35s %-20s %-20s %-20s", ++$index, $sv_case_name, "PASS", $user_s, $sim_seed;
                        push @regress_result, $local_str; 
                        $pass_case_num++;
                        last;
                    }
                    elsif ($_ =~ /CASE_SIMULATION_FAIL/) {
                        $local_str = sprintf "%-15d %-35s %-20s %-20s %-20s", ++$index, $sv_case_name, "FAIL", $user_s, $sim_seed;
                        push @regress_result, $local_str; 
                        $fail_case_num++;
                        last;
                    }
                    else {
                        if (eof(sim_log_f)) {
                            $local_str = sprintf "%-15d %-35s %-20s %-20s", ++$index, $sv_case_name, "TIMEOUT", $user_s;
                            push @regress_result, $local_str; 
                            $timeout_case_num++;
                        }
                    }
                }
                close (sim_log_f);
            }
            else {
                $local_str = sprintf "%-15d %-35s %-20s",++$index, $sv_case_name, "NOT_STARTED", $user_s;
                push @regress_result, $local_str; 
                $not_start_case_num++;
            }
        }
    }
    if ($total_cases_num > $pass_case_num + $fail_case_num + $timeout_case_num + $not_start_case_num) {
        $no_result_case_num = $total_cases_num - ($pass_case_num + $fail_case_num + $timeout_case_num + $not_start_case_num);
    }
    close (sim_dir);

    open(reg_rpt_f,  ">$ENV{SIM_WORK}/regress/$date_time/regress.rpt") or die "cat not create regress report file";
    #add report header
    printf reg_rpt_f  "%20s", "                regression @ time $date_time report:\
        total $total_cases_num cases, $pass_case_num passed, $fail_case_num failed, $timeout_case_num timeout, $not_start_case_num not started, $no_result_case_num have no result\n";
    print  reg_rpt_f  "=============================================================================================================================================\n";
    printf reg_rpt_f  "%-15s %-35s %-20s %-20s %-20s\n","CASE_INDEX", "SV_CASE_NAME", "RESULT", "COMMENT", "SEED";
    print  reg_rpt_f  "=============================================================================================================================================\n";

    foreach (@regress_result) {
        print reg_rpt_f  $_."\n";
    }
    print  reg_rpt_f  "=============================================================================================================================================\n";
    close (reg_rpt_f);
    system ("cat $ENV{SIM_WORK}/regress/$date_time/regress.rpt");
    return @regress_result;
}

sub thread_mk {
    my $target_and_opt = $_[0];
    my $tid = threads->self()->tid();
    #my $sleep_time = int(rand(10) + 1);
    #print  "theread $tid will sleep $sleep_time second \n";
    #sleep $sleep_time;
    #print  "theread $tid end \n";
    print "cmp theread $tid compile c_model\n";
    system("$make_cmd c_eep");
    print "cmp theread $tid compile tb with target_and_opt $target_and_opt\n";
    system("$make_cmd ".$target_and_opt." > /dev/null 2>&1");
    print "cmp theread $tid finished !\n";
}
sub thread_run {
    my $run_opt = $_[0];
    my $date_time ;
    my $tid = threads->self()->tid();
    my $cm4_cfg;
    #my $sleep_time = int(rand(10) + 1);
    #print  "theread $tid will sleep $sleep_time second \n";
    #sleep $sleep_time;
    #print  "theread $tid end \n";
    if ($run_opt =~ /REG_TIME=([0-9\-]+)/) {
        $date_time = $1;
        $cm4_cfg = $2;
        $cmp_dir_name = "soc_sim_cmp";
        print "run theread $tid will run case with opt $run_opt\n";
        system("cp -r $ENV{SIM_WORK}/regress/$date_time/$cmp_dir_name  $ENV{SIM_WORK}/regress/$date_time/sim_cmp.$tid");
        system("$make_cmd run ".$run_opt."  CMP_DIR=$ENV{SIM_WORK}/regress/$date_time/sim_cmp.$tid > /dev/null 2>&1"); #use copied dir  
        sleep 1;
        system("rm -rf $ENV{SIM_WORK}/regress/$date_time/sim_cmp.$tid");
        print "run theread $tid finished !\n";
    }
    else {
        print "command option not correct, threads not do anything!\n";
    }
}
