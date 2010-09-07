From: Reinier Haasjes <reinier@news-service.com>
Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
Date: Tue, 07 Sep 2010 17:27:04 +0200
Message-ID: <4C8659C8.50905@news-service.com>
References: <4C690D09.70908@news-service.com> <4B6A08C587958942AA3002690DD4F8C3DBE62B40@cosmail02.lsi.com> <4C6A52AA.9040303@news-service.com> <4C710F55.3020302@news-service.com> <4B6A08C587958942AA3002690DD4F8C3DBEF4AD0@cosmail02.lsi.com> <4C85EF47.70006@news-service.com> <4B6A08C587958942AA3002690DD4F8C3DC054965@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020409020608080801030505"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dione.haasjes.com ([194.145.200.161]:44148 "EHLO
	dione.haasjes.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab0IGP0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 11:26:37 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3DC054965@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MegaRAID Linux <megaraidlinux@lsi.com>

This is a multi-part message in MIME format.
--------------020409020608080801030505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bo,

I used the standard 2.6.33.2 kernel source from kernels.org and
overwrote these with the driver sources I got from you (attached again).
I also attached the config file I used.

Best Regards,
Reinier

On 09/07/2010 03:19 PM, Yang, Bo wrote:
> Reinier,
> 
> Can you send me the src you used in this server?
> 
> Thanks,
> 
> Bo Yang
> 
> -----Original Message-----
> From: Reinier Haasjes [mailto:reinier@news-service.com]
> Sent: Tuesday, September 07, 2010 3:53 AM
> To: Yang, Bo
> Cc: linux-scsi@vger.kernel.org; DL-MegaRAID Linux
> Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
> 
> Hi,
> 
> I installed the driver on a production server and after 13 days we got an OOPS:
> 
> Sep  6 21:19:00 sd43 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> Sep  6 21:19:00 sd43 kernel: IP: [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
> Sep  6 21:19:00 sd43 kernel: PGD 0
> Sep  6 21:19:00 sd43 kernel: Oops: 0000 [#1] SMP
> Sep  6 21:19:00 sd43 kernel: last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> Sep  6 21:19:00 sd43 kernel: CPU 0
> Sep  6 21:19:00 sd43 kernel: Pid: 19, comm: events/0 Not tainted 2.6.33.2-mr431 #7 086HF8/PowerEdge R610
> Sep  6 21:19:00 sd43 kernel: RIP: 0010:[<ffffffff811bb1d1>]  [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
> Sep  6 21:19:00 sd43 kernel: RSP: 0000:ffff880c7ccbfd80  EFLAGS: 00010282
> Sep  6 21:19:00 sd43 kernel: RAX: 00000000ffffffff RBX: 0000000000000000 RCX: ffff88067cd1be68
> Sep  6 21:19:00 sd43 kernel: RDX: ffff88007f29f800 RSI: 0000000000000282 RDI: ffff880c7cdd8400
> Sep  6 21:19:00 sd43 kernel: RBP: ffff88067cd1be40 R08: ffff880c7ccbe000 R09: 00000000ffffffff
> Sep  6 21:19:00 sd43 kernel: R10: 0000040100000000 R11: ffffffff811e9a98 R12: ffff880c7cdd8400
> Sep  6 21:19:00 sd43 kernel: R13: 00000000fe00ffff R14: 0000000000000001 R15: ffff880c7ccb1aa8
> Sep  6 21:19:00 sd43 kernel: FS:  0000000000000000(0000) GS:ffff880695400000(0000) knlGS:0000000000000000
> Sep  6 21:19:00 sd43 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Sep  6 21:19:00 sd43 kernel: CR2: 0000000000000020 CR3: 000000000134a000 CR4: 00000000000006f0
> Sep  6 21:19:00 sd43 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Sep  6 21:19:00 sd43 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Sep  6 21:19:00 sd43 kernel: Process events/0 (pid: 19, threadinfo ffff880c7ccbe000, task ffff880c7ccb1780)
> Sep  6 21:19:00 sd43 kernel: Stack:
> Sep  6 21:19:00 sd43 kernel: ffff880c7ccbe000 ffff88007f28b000 00000000fe00ffff 0000000000000000
> Sep  6 21:19:00 sd43 kernel: <0> 0000000000000001 ffff88067cd1a900 ffffffffffffffae ffff880c7cdd89a8
> Sep  6 21:19:00 sd43 kernel: <0> ffff880c7cdd8400 ffff880c7ccb1780 00000000fe00ffff ffffffff811bb44c
> Sep  6 21:19:00 sd43 kernel: Call Trace:
> Sep  6 21:19:00 sd43 kernel: [<ffffffff811bb44c>] ? megasas_register_aen+0x7c/0x19c
> Sep  6 21:19:00 sd43 kernel: [<ffffffff811bd320>] ? megasas_aen_polling+0x3ab/0x3ff
> Sep  6 21:19:00 sd43 kernel: [<ffffffff811bcf75>] ? megasas_aen_polling+0x0/0x3ff
> Sep  6 21:19:00 sd43 kernel: [<ffffffff81039fa2>] ? worker_thread+0xf5/0x179
> Sep  6 21:19:00 sd43 kernel: [<ffffffff8103ce42>] ? autoremove_wake_function+0x0/0x2e
> Sep  6 21:19:00 sd43 kernel: [<ffffffff81039ead>] ? worker_thread+0x0/0x179
> Sep  6 21:19:00 sd43 kernel: [<ffffffff8103ca71>] ? kthread+0x79/0x81
> Sep  6 21:19:00 sd43 kernel: [<ffffffff81002c14>] ? kernel_thread_helper+0x4/0x10
> Sep  6 21:19:00 sd43 kernel: [<ffffffff8103c9f8>] ? kthread+0x0/0x81
> Sep  6 21:19:00 sd43 kernel: [<ffffffff81002c10>] ? kernel_thread_helper+0x0/0x10
> Sep  6 21:19:00 sd43 kernel: Code: 83 ec 38 e8 21 fb ff ff 48 89 c5 83 c8 ff 48 85 ed 0f 84 fd 00 00 00 48 8b 55 00 4c 89 e7 c6 02 06 c6 42 02 ff 66 c7 42 10 00 00 <8b> 43 20 89 42 18 48 8b 43 08 c7 42 24 00 00 00 00 89 42 20 c6
> Sep  6 21:19:00 sd43 kernel: RIP  [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
> Sep  6 21:19:00 sd43 kernel: RSP <ffff880c7ccbfd80>
> Sep  6 21:19:00 sd43 kernel: CR2: 0000000000000020
> Sep  6 21:19:00 sd43 kernel: ---[ end trace 3a7c9ab197c0c797 ]---
> 
> We only got one so far, if I get more I will post these too.
> 
> Nothing changed on this server so all the info in the first post is the same.
> If you need some additional info please let me know.
> 
> I hope we can find a solution for this problem.
> 
> Thanks,
> 
> Reinier
> 
> On 23-08-10 15:26, Yang, Bo wrote:
>> Attached is the src.  Can you compile the driver test it again?
>>
>> Thanks,
>>
>> Bo Yang
>>
>> -----Original Message-----
>> From: Reinier Haasjes [mailto:reinier@news-service.com]
>> Sent: Sunday, August 22, 2010 7:52 AM
>> To: linux-scsi@vger.kernel.org
>> Cc: Yang, Bo; DL-MegaRAID Linux
>> Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>
>> Hi,
>>
>> Anybody knows where I can find the 4.31 megaraid_sas driver?
>>
>> Thanks,
>>
>> Reinier
>>
>> On 08/17/2010 11:13 AM, Reinier Haasjes wrote:
>>> Bo,
>>>
>>> I'm currently using the version from kernel 2.6.33.2:
>>>   megasas: 00.00.04.12-rc1 Thu Sep. 17 11:41:51 PST 2009
>>>
>>> I already tried kernel 2.6.34 with contains version 4.17.1-rc1, same
>>> problem.
>>>
>>> Where can I find the 4.31 version? If I look at the mainline-kernel it
>>> still is version 4.17.1-rc1:
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=blob_plain;f=drivers/scsi/megaraid/megaraid_sas.c;hb=HEAD
>>>
>>> Thanks,
>>>
>>> Reinier
>>>
>>>
>>> On 16-08-10 15:53, Yang, Bo wrote:
>>>> Reinier,
>>>>
>>>> What is the driver version you are using?  Is there possible you can apply 4.31 driver (we already submitted the patches)?
>>>>
>>>> Thanks,
>>>>
>>>> Bo Yang
>>>>
>>>> -----Original Message-----
>>>> From: Reinier Haasjes [mailto:reinier@news-service.com]
>>>> Sent: Monday, August 16, 2010 6:04 AM
>>>> To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
>>>> Subject: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>>
>>>> [1.] One line summary of the problem:
>>>> Kernel OOPS 'megasas_issue_blocked_abort_cmd' after a few thousand "scanning ..." lines
>>>>
>>>> [2.] Full description of the problem/report:
>>>> If something on the scsi bus happens (or the kernel things that something happens) we get a few thousand "scanning ..." lines. After some time (between 30 min. and 5 hours) the 'scanning ...' stops with an kernel OOPS
>>>>
>>>> [3.] Keywords (i.e., modules, networking, kernel):
>>>> megaraid, megasas, scanning, kernel, scsi
>>>>
>>>> [4.] Kernel version (from /proc/version):
>>>> Linux version 2.6.33.2 (root@sd53) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #3 SMP Fri Apr 9 20:28:13 CEST 2010
>>>>
>>>> [5.] Output of Oops.. message (if applicable) with symbolic information
>>>>      resolved (see Documentation/oops-tracing.txt)
>>>> Aug 14 04:54:27 sd53 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>>>> Aug 14 04:54:27 sd53 kernel: IP: [<ffffffff811baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>> Aug 14 04:54:27 sd53 kernel: PGD 67ba88067 PUD 67ba89067 PMD 0
>>>> Aug 14 04:54:27 sd53 kernel: Oops: 0000 [#1] SMP
>>>> Aug 14 04:54:27 sd53 kernel: last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
>>>> Aug 14 04:54:27 sd53 kernel: CPU 7
>>>> Aug 14 04:54:27 sd53 kernel: Pid: 26, comm: events/7 Not tainted 2.6.33.2 #3 086HF8/PowerEdge R610
>>>> Aug 14 04:54:27 sd53 kernel: RIP: 0010:[<ffffffff811baffe>]  [<ffffffff811baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>> Aug 14 04:54:27 sd53 kernel: RSP: 0000:ffff880c7cccdd90  EFLAGS: 00010282
>>>> Aug 14 04:54:27 sd53 kernel: RAX: 00000000ffffffff RBX: 0000000000000000 RCX: ffff880c7bd74b08
>>>> Aug 14 04:54:27 sd53 kernel: RDX: ffff88007f28c800 RSI: 0000000000000286 RDI: ffff880c7cda8400
>>>> Aug 14 04:54:27 sd53 kernel: RBP: ffff880c7bd74ae0 R08: 0000000000000002 R09: 0000000000000001
>>>> Aug 14 04:54:27 sd53 kernel: R10: 0000000000000002 R11: ffffffffa000579f R12: ffff880c7cda8400
>>>> Aug 14 04:54:27 sd53 kernel: R13: 00000000fe00ffff R14: 0000000000000001 R15: 0000000000000080
>>>> Aug 14 04:54:27 sd53 kernel: FS:  0000000000000000(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
>>>> Aug 14 04:54:27 sd53 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> Aug 14 04:54:27 sd53 kernel: CR2: 0000000000000020 CR3: 000000067ce55000 CR4: 00000000000006e0
>>>> Aug 14 04:54:27 sd53 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> Aug 14 04:54:27 sd53 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> Aug 14 04:54:27 sd53 kernel: Process events/7 (pid: 26, threadinfo ffff880c7cccc000, task ffff880c7ccb40a0)
>>>> Aug 14 04:54:27 sd53 kernel: Stack:
>>>> Aug 14 04:54:27 sd53 kernel: 0000000000000002 ffff88007f1f3400 00000000fe00ffff 00000000fe00ffff
>>>> Aug 14 04:54:27 sd53 kernel: <0> 0000000000000001 ffff880c7bd6aa80 ffff880c7cda88a8 ffff880c7cda8400
>>>> Aug 14 04:54:27 sd53 kernel: <0> 0000000000000001 00000000fe00ffff 0000000000000001 ffffffff811bb272
>>>> Aug 14 04:54:27 sd53 kernel: Call Trace:
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bb272>] ? megasas_register_aen+0x7e/0x18e
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bc51f>] ? megasas_aen_polling+0x121/0x171
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bc3fe>] ? megasas_aen_polling+0x0/0x171
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81039fa2>] ? worker_thread+0xf5/0x179
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103ce42>] ? autoremove_wake_function+0x0/0x2e
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81039ead>] ? worker_thread+0x0/0x179
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103ca71>] ? kthread+0x79/0x81
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81002c14>] ? kernel_thread_helper+0x4/0x10
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103c9f8>] ? kthread+0x0/0x81
>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81002c10>] ? kernel_thread_helper+0x0/0x10
>>>> Aug 14 04:54:27 sd53 kernel: Code: 83 ec 30 e8 fa fc ff ff 48 89 c5 83 c8 ff 48 85 ed 0f 84 07 01 00 00 48 8b 55 00 4c 89 e7 c6 02 06 c6 42 02 ff 66 c7 42 10 00 00 <8b> 43 20 89 42 18 48 8b 43 08 c7 42 24 00 00 00 00 89 42 20 c6
>>>> Aug 14 04:54:27 sd53 kernel: RIP  [<ffffffff811baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>> Aug 14 04:54:27 sd53 kernel: RSP <ffff880c7cccdd90>
>>>> Aug 14 04:54:27 sd53 kernel: CR2: 0000000000000020
>>>> Aug 14 04:54:27 sd53 kernel: ---[ end trace 2472a972a600883c ]---
>>>>
>>>> [6.] A small shell script or example program which triggers the
>>>>      problem (if possible)
>>>> If you hot-swap a disk (eject of insert) the scanning loop starts, no software trigger found.
>>>>
>>>> [7.] Environment
>>>> [7.1.] Software (add the output of the ver_linux script here)
>>>> Linux sd53 2.6.33.2 #3 SMP Fri Apr 9 20:28:13 CEST 2010 x86_64 GNU/Linux
>>>>
>>>> Gnu C                  4.3.2
>>>> Gnu make               3.81
>>>> binutils               2.18.0.20080103
>>>> util-linux             2.13.1.1
>>>> mount                  2.13.1.1
>>>> module-init-tools      3.4
>>>> e2fsprogs              1.41.3
>>>> xfsprogs               3.1.2
>>>> Linux C Library        2.7
>>>> Dynamic linker (ldd)   2.7
>>>> Procps                 3.2.7
>>>> Net-tools              1.60
>>>> Console-tools          0.2.3
>>>> Sh-utils               6.10
>>>> udev                   125
>>>> Modules Loaded         acpi_cpufreq cpufreq_ondemand ipmi_si ipmi_devintf ipmi_msghandler dcdbas processor bnx2 thermal fan thermal_sys
>>>>
>>>> [7.2.] Processor information (from /proc/cpuinfo):
>>>> processor       : 0
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 1
>>>> siblings        : 4
>>>> core id         : 0
>>>> cpu cores       : 4
>>>> apicid          : 16
>>>> initial apicid  : 16
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.16
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 1
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 0
>>>> siblings        : 4
>>>> core id         : 0
>>>> cpu cores       : 4
>>>> apicid          : 0
>>>> initial apicid  : 0
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.83
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 2
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 1
>>>> siblings        : 4
>>>> core id         : 1
>>>> cpu cores       : 4
>>>> apicid          : 18
>>>> initial apicid  : 18
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.83
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 3
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 0
>>>> siblings        : 4
>>>> core id         : 1
>>>> cpu cores       : 4
>>>> apicid          : 2
>>>> initial apicid  : 2
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.84
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 4
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 1
>>>> siblings        : 4
>>>> core id         : 2
>>>> cpu cores       : 4
>>>> apicid          : 20
>>>> initial apicid  : 20
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.84
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 5
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 0
>>>> siblings        : 4
>>>> core id         : 2
>>>> cpu cores       : 4
>>>> apicid          : 4
>>>> initial apicid  : 4
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.86
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 6
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 1
>>>> siblings        : 4
>>>> core id         : 3
>>>> cpu cores       : 4
>>>> apicid          : 22
>>>> initial apicid  : 22
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.84
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> processor       : 7
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 26
>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>> stepping        : 5
>>>> cpu MHz         : 1596.000
>>>> cache size      : 8192 KB
>>>> physical id     : 0
>>>> siblings        : 4
>>>> core id         : 3
>>>> cpu cores       : 4
>>>> apicid          : 6
>>>> initial apicid  : 6
>>>> fpu             : yes
>>>> fpu_exception   : yes
>>>> cpuid level     : 11
>>>> wp              : yes
>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>> bogomips        : 4521.87
>>>> clflush size    : 64
>>>> cache_alignment : 64
>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>> power management:
>>>>
>>>> [7.3.] Module information (from /proc/modules):
>>>> acpi_cpufreq 5107 1 - Live 0xffffffffa0014000
>>>> cpufreq_ondemand 7021 8 - Live 0xffffffffa0005000
>>>> ipmi_si 32442 2 - Live 0xffffffffa0053000
>>>> ipmi_devintf 6371 4 - Live 0xffffffffa004c000
>>>> ipmi_msghandler 25956 2 ipmi_si,ipmi_devintf, Live 0xffffffffa003e000
>>>> dcdbas 4832 0 - Live 0xffffffffa0036000
>>>> processor 22897 9 acpi_cpufreq, Live 0xffffffffa002e000
>>>> bnx2 60164 0 - Live 0xffffffffa0018000
>>>> thermal 11634 0 - Live 0xffffffffa000f000
>>>> fan 2314 0 - Live 0xffffffffa0009000
>>>> thermal_sys 10549 3 processor,thermal,fan, Live 0xffffffffa0000000
>>>>
>>>> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
>>>> /proc/ioports
>>>> 0000-001f : dma1
>>>> 0020-0021 : pic1
>>>> 0040-0043 : timer0
>>>> 0050-0053 : timer1
>>>> 0060-0060 : keyboard
>>>> 0064-0064 : keyboard
>>>> 0070-0077 : rtc
>>>> 0080-008f : dma page reg
>>>> 00a0-00a1 : pic2
>>>> 00c0-00df : dma2
>>>> 00f0-00ff : fpu
>>>> 02f8-02ff : serial
>>>> 03c0-03df : vga+
>>>> 03f8-03ff : serial
>>>> 0800-087f : 0000:00:1f.0
>>>>   0800-087f : pnp 00:07
>>>>     0800-0803 : ACPI PM1a_EVT_BLK
>>>>     0804-0805 : ACPI PM1a_CNT_BLK
>>>>     0808-080b : ACPI PM_TMR
>>>>     0810-0815 : ACPI CPU throttle
>>>>     0820-082f : ACPI GPE0_BLK
>>>>     0850-0850 : ACPI PM2_CNT_BLK
>>>> 0880-08bf : 0000:00:1f.0
>>>> 0900-091f : pnp 00:07
>>>> 0920-0923 : pnp 00:07
>>>> 0924-0924 : pnp 00:07
>>>> 0c00-0c7f : pnp 00:07
>>>> 0ca0-0ca7 : pnp 00:07
>>>> 0ca8-0ca8 : pnp 00:08
>>>>   0ca8-0ca8 : ipmi_si
>>>> 0ca9-0cab : pnp 00:07
>>>> 0cac-0cac : pnp 00:08
>>>>   0cac-0cac : ipmi_si
>>>> 0cad-0caf : pnp 00:07
>>>> 0cf8-0cff : PCI conf1
>>>> dc40-dc5f : 0000:00:1a.0
>>>>   dc40-dc5f : uhci_hcd
>>>> dc60-dc7f : 0000:00:1a.1
>>>>   dc60-dc7f : uhci_hcd
>>>> dc80-dc9f : 0000:00:1d.0
>>>>   dc80-dc9f : uhci_hcd
>>>> dca0-dcbf : 0000:00:1d.1
>>>>   dca0-dcbf : uhci_hcd
>>>> e000-efff : PCI Bus 0000:04
>>>>   ec00-ecff : 0000:04:00.0
>>>> f000-ffff : PCI Bus 0000:03
>>>>   fc00-fcff : 0000:03:00.0
>>>>
>>>> /proc/iomem
>>>> 00000000-0009ffff : System RAM
>>>> 00100000-7f678fff : System RAM
>>>>   01000000-0125ac0f : Kernel code
>>>>   0125ac10-0137aa97 : Kernel data
>>>>   0140d000-01440d27 : Kernel bss
>>>> 7f679000-7f68efff : reserved
>>>> 7f68f000-7f6cdfff : ACPI Tables
>>>> 7f6ce000-7fffffff : reserved
>>>> d9800000-d9ffffff : PCI Bus 0000:06
>>>>   d9800000-d9ffffff : 0000:06:03.0
>>>> da000000-ddffffff : PCI Bus 0000:01
>>>>   da000000-dbffffff : 0000:01:00.0
>>>>     da000000-dbffffff : bnx2
>>>>   dc000000-ddffffff : 0000:01:00.1
>>>>     dc000000-ddffffff : bnx2
>>>> de000000-deffffff : PCI Bus 0000:06
>>>>   de000000-de00ffff : 0000:06:03.0
>>>>   de7fc000-de7fffff : 0000:06:03.0
>>>>   de800000-deffffff : 0000:06:03.0
>>>> df0ff800-df0ffbff : 0000:00:1a.7
>>>>   df0ff800-df0ffbff : ehci_hcd
>>>> df0ffc00-df0fffff : 0000:00:1d.7
>>>>   df0ffc00-df0fffff : ehci_hcd
>>>> df100000-df1fffff : PCI Bus 0000:04
>>>>   df100000-df107fff : 0000:04:00.0
>>>>   df180000-df1bffff : 0000:04:00.0
>>>>     df180000-df1bffff : megasas: LSI
>>>>   df1c0000-df1fffff : 0000:04:00.0
>>>>     df1c0000-df1fffff : megasas: LSI
>>>> df200000-df2fffff : PCI Bus 0000:03
>>>>   df200000-df23ffff : 0000:03:00.0
>>>>   df2bc000-df2bffff : 0000:03:00.0
>>>>     df2bc000-df2bffff : megasas: LSI
>>>>   df2c0000-df2fffff : 0000:03:00.0
>>>>     df2c0000-df2fffff : megasas: LSI
>>>> e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>>>>   e0000000-efffffff : reserved
>>>>     e0000000-efffffff : pnp 00:0a
>>>> fe000000-ffffffff : reserved
>>>>   fec00000-fec003ff : IOAPIC 0
>>>>   fec80000-fec803ff : IOAPIC 1
>>>>   fed00000-fed003ff : HPET 0
>>>>   fed90000-fed91fff : pnp 00:0c
>>>>   fee00000-fee00fff : Local APIC
>>>> 100000000-c7fffffff : System RAM
>>>> sd53:~#
>>>>
>>>> [7.5.] PCI information ('lspci -vvv' as root)
>>>> 00:00.0 Host bridge: Intel Corporation QuickPath Architecture I/O Hub to ESI Port (rev 13)
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Interrupt: pin A routed to IRQ 15
>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable-
>>>>                 Address: 00000000  Data: 0000
>>>>                 Masking: 00000000  Pending: 00000000
>>>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag+ RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna- CRSVisible-
>>>>                 RootCap: CRSVisible-
>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>         Capabilities: [e0] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Access Controls <?>
>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>
>>>> 00:01.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>>>         I/O behind bridge: 0000f000-00000fff
>>>>         Memory behind bridge: da000000-ddffffff
>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>                 Address: feeff00c  Data: 4159
>>>>                 Masking: 00000003  Pending: 00000000
>>>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag+ RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #1, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>                 RootCap: CRSVisible-
>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>         Capabilities: [e0] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Access Controls <?>
>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>         Kernel driver in use: pcieport
>>>>
>>>> 00:03.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>>>         I/O behind bridge: 0000f000-00000fff
>>>>         Memory behind bridge: fff00000-000fffff
>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>                 Address: feeff00c  Data: 4161
>>>>                 Masking: 00000003  Pending: 00000000
>>>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag+ RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #3, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>                 RootCap: CRSVisible-
>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>         Capabilities: [e0] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Access Controls <?>
>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>         Kernel driver in use: pcieport
>>>>
>>>> 00:07.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>>>>         I/O behind bridge: 0000e000-0000efff
>>>>         Memory behind bridge: df100000-df1fffff
>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>                 Address: feeff00c  Data: 4169
>>>>                 Masking: 00000003  Pending: 00000000
>>>>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag+ RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #7, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
>>>>                         Slot #  1, PowerLimit 25.000000; Interlock- NoCompl-
>>>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>>>                         Control: AttnInd Off, PwrInd Off, Power- Interlock-
>>>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>>>                         Changed: MRL- PresDet+ LinkState+
>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>                 RootCap: CRSVisible-
>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>         Capabilities: [e0] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Access Controls <?>
>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>         Kernel driver in use: pcieport
>>>>
>>>> 00:09.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 9 (rev 13) (prog-if 00 [Normal decode])
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>>>>         I/O behind bridge: 0000f000-00000fff
>>>>         Memory behind bridge: fff00000-000fffff
>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>                 Address: feeff00c  Data: 4171
>>>>                 Masking: 00000003  Pending: 00000000
>>>>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag+ RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #9, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
>>>>                         Slot #  2, PowerLimit 25.000000; Interlock- NoCompl-
>>>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>>>                         Control: AttnInd Off, PwrInd Off, Power- Interlock-
>>>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>>>>                         Changed: MRL- PresDet+ LinkState-
>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>                 RootCap: CRSVisible-
>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>         Capabilities: [e0] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Access Controls <?>
>>>>         Kernel driver in use: pcieport
>>>>
>>>> 00:14.0 PIC: Intel Corporation QuickPath Architecture I/O Hub System Management Registers (rev 13) (prog-if 00 [8259])
>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag- RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>
>>>> 00:14.1 PIC: Intel Corporation QuickPath Architecture I/O Hub GPIO and Scratch Pad Registers (rev 13) (prog-if 00 [8259])
>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag- RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>
>>>> 00:14.2 PIC: Intel Corporation QuickPath Architecture I/O Hub Control Status and RAS Registers (rev 13) (prog-if 00 [8259])
>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag- RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>
>>>> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Interrupt: pin A routed to IRQ 17
>>>>         Region 4: I/O ports at dc40 [size=32]
>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>         Kernel driver in use: uhci_hcd
>>>>
>>>> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02) (prog-if 00 [UHCI])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Interrupt: pin B routed to IRQ 18
>>>>         Region 4: I/O ports at dc60 [size=32]
>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>         Kernel driver in use: uhci_hcd
>>>>
>>>> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20 [EHCI])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Interrupt: pin C routed to IRQ 19
>>>>         Region 0: Memory at df0ff800 (32-bit, non-prefetchable) [size=1K]
>>>>         Capabilities: [50] Power Management version 2
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>>>         Capabilities: [98] PCIe advanced features <?>
>>>>         Kernel driver in use: ehci_hcd
>>>>
>>>> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>>>>         I/O behind bridge: 0000f000-0000ffff
>>>>         Memory behind bridge: df200000-df2fffff
>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>         Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag- RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>>>                 LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <256ns, L1 <4us
>>>>                         ClockPM- Suprise- LLActRep+ BwNot-
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna- CRSVisible-
>>>>                 RootCap: CRSVisible-
>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
>>>>                 Address: feeff00c  Data: 4179
>>>>         Capabilities: [90] Subsystem: Dell Device 0236
>>>>         Capabilities: [a0] Power Management version 2
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [100] Virtual Channel <?>
>>>>         Capabilities: [180] Root Complex Link <?>
>>>>         Kernel driver in use: pcieport
>>>>
>>>> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Interrupt: pin A routed to IRQ 21
>>>>         Region 4: I/O ports at dc80 [size=32]
>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>         Kernel driver in use: uhci_hcd
>>>>
>>>> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Interrupt: pin B routed to IRQ 20
>>>>         Region 4: I/O ports at dca0 [size=32]
>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>         Kernel driver in use: uhci_hcd
>>>>
>>>> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20 [EHCI])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Interrupt: pin A routed to IRQ 21
>>>>         Region 0: Memory at df0ffc00 (32-bit, non-prefetchable) [size=1K]
>>>>         Capabilities: [50] Power Management version 2
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>>>         Capabilities: [98] PCIe advanced features <?>
>>>>         Kernel driver in use: ehci_hcd
>>>>
>>>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01 [Subtractive decode])
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
>>>>         I/O behind bridge: 0000f000-00000fff
>>>>         Memory behind bridge: de000000-deffffff
>>>>         Prefetchable memory behind bridge: 00000000d9800000-00000000d9ffffff
>>>>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>>>         BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>         Capabilities: [50] Subsystem: Dell Device 0236
>>>>
>>>> 00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface Controller (rev 02)
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0
>>>>         Capabilities: [e0] Vendor Specific Information <?>
>>>>
>>>> 01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Interrupt: pin A routed to IRQ 36
>>>>         Region 0: Memory at da000000 (64-bit, non-prefetchable) [size=32M]
>>>>         Capabilities: [48] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>>>         Capabilities: [50] Vital Product Data <?>
>>>>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable-
>>>>                 Address: 0000000000000000  Data: 0000
>>>>         Capabilities: [a0] MSI-X: Enable+ Mask- TabSize=9
>>>>                 Vector table: BAR=0 offset=0000c000
>>>>                 PBA: BAR=0 offset=0000e000
>>>>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
>>>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>>>>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>>>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <2us
>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>         Capabilities: [100] Device Serial Number e1-66-6a-fe-ff-19-22-00
>>>>         Capabilities: [110] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Power Budgeting <?>
>>>>         Capabilities: [160] Virtual Channel <?>
>>>>         Kernel driver in use: bnx2
>>>>         Kernel modules: bnx2
>>>>
>>>> 01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Interrupt: pin B routed to IRQ 48
>>>>         Region 0: Memory at dc000000 (64-bit, non-prefetchable) [size=32M]
>>>>         Capabilities: [48] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>>>         Capabilities: [50] Vital Product Data <?>
>>>>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable-
>>>>                 Address: 0000000000000000  Data: 0000
>>>>         Capabilities: [a0] MSI-X: Enable- Mask- TabSize=9
>>>>                 Vector table: BAR=0 offset=0000c000
>>>>                 PBA: BAR=0 offset=0000e000
>>>>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
>>>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>>>>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>>>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <2us
>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>         Capabilities: [100] Device Serial Number e3-66-6a-fe-ff-19-22-00
>>>>         Capabilities: [110] Advanced Error Reporting <?>
>>>>         Capabilities: [150] Power Budgeting <?>
>>>>         Capabilities: [160] Virtual Channel <?>
>>>>         Kernel driver in use: bnx2
>>>>         Kernel modules: bnx2
>>>>
>>>> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic Device 0079 (rev 04)
>>>>         Subsystem: Dell Device 1f17
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Interrupt: pin A routed to IRQ 16
>>>>         Region 0: I/O ports at fc00 [size=256]
>>>>         Region 1: Memory at df2bc000 (64-bit, non-prefetchable) [size=16K]
>>>>         Region 3: Memory at df2c0000 (64-bit, non-prefetchable) [size=256K]
>>>>         Expansion ROM at df200000 [disabled] [size=256K]
>>>>         Capabilities: [50] Power Management version 3
>>>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [68] Express (v2) Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>>>>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <64ns, L1 <1us
>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>         Capabilities: [d0] Vital Product Data <?>
>>>>         Capabilities: [a8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>>>>                 Address: 0000000000000000  Data: 0000
>>>>         Capabilities: [c0] MSI-X: Enable- Mask- TabSize=15
>>>>                 Vector table: BAR=1 offset=00002000
>>>>                 PBA: BAR=1 offset=00003800
>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>         Capabilities: [138] Power Budgeting <?>
>>>>         Kernel driver in use: megaraid_sas
>>>>
>>>> 04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
>>>>         Subsystem: Dell PERC 6/E Adapter RAID Controller
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Interrupt: pin A routed to IRQ 38
>>>>         Region 0: Memory at df180000 (64-bit, non-prefetchable) [size=256K]
>>>>         Region 2: I/O ports at ec00 [size=256]
>>>>         Region 3: Memory at df1c0000 (64-bit, non-prefetchable) [size=256K]
>>>>         Expansion ROM at df100000 [disabled] [size=32K]
>>>>         Capabilities: [b0] Express (v1) Endpoint, MSI 00
>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
>>>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>                         MaxPayload 256 bytes, MaxReadReq 2048 bytes
>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 unlimited
>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>>>>         Capabilities: [c4] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
>>>>                 Address: 0000000000000000  Data: 0000
>>>>         Capabilities: [d4] MSI-X: Enable- Mask- TabSize=4
>>>>                 Vector table: BAR=0 offset=0003e000
>>>>                 PBA: BAR=0 offset=00fff000
>>>>         Capabilities: [e0] Power Management version 2
>>>>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>         Capabilities: [ec] Vital Product Data <?>
>>>>         Capabilities: [100] Power Budgeting <?>
>>>>         Kernel driver in use: megaraid_sas
>>>>
>>>> 06:03.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW WPCM450 [Hermon] - Winbond/Nuvoton (rev 0a) (prog-if 00 [VGA controller])
>>>>         Subsystem: Dell Device 0236
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
>>>>         Interrupt: pin A routed to IRQ 10
>>>>         Region 0: Memory at d9800000 (32-bit, prefetchable) [size=8M]
>>>>         Region 1: Memory at de7fc000 (32-bit, non-prefetchable) [size=16K]
>>>>         Region 2: Memory at de800000 (32-bit, non-prefetchable) [size=8M]
>>>>         [virtual] Expansion ROM at de000000 [disabled] [size=64K]
>>>>         Capabilities: [dc] Power Management version 1
>>>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>
>>>> [7.6.] SCSI information (from /proc/scsi/scsi)
>>>> Attached devices:
>>>> Host: scsi0 Channel: 00 Id: 46 Lun: 00
>>>>   Vendor: Dell     Model: J23              Rev: R109
>>>>   Type:   Enclosure                        ANSI  SCSI revision: 05
>>>> Host: scsi0 Channel: 00 Id: 47 Lun: 00
>>>>   Vendor: Dell     Model: J23              Rev: R109
>>>>   Type:   Enclosure                        ANSI  SCSI revision: 05
>>>> Host: scsi0 Channel: 02 Id: 00 Lun: 00
>>>>   Vendor: DELL     Model: PERC 6/E Adapter Rev: 1.22
>>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>>> Host: scsi0 Channel: 02 Id: 01 Lun: 00
>>>>   Vendor: DELL     Model: PERC 6/E Adapter Rev: 1.22
>>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>>> Host: scsi1 Channel: 02 Id: 00 Lun: 00
>>>>   Vendor: DELL     Model: PERC H700        Rev: 2.0.
>>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>>>
>>>> [7.7.] Other information that might be relevant to the problem
>>>>        (please look in /proc and include all information that you
>>>>        think to be relevant):
>>>> [X.] Other notes, patches, fixes, workarounds:
>>>> I think the problem is the H700 controller in combination with the megasas-driver.
>>>> We have a lot more systems running 2.6.33.2 and only the servers with the H700 controller are giving this problem.
>>>> Also after some sime (after the scanning and oops) we experience user space freezes.
>>>> I tried 2.6.34 and give the same problem, only not the 'scanning-loop', just 1 'scanning-line'.
>>>> It's on a production server so I didn't test 2.6.35, can't reproduce it on a test machine.
>>>>
>>>> Best Regards,
>>>>
>>>> Reinier
>>>> --
>>>> News-Service.com - European Usenet Provider
>>>> Luttenbergweg 4, 1101 EC Amsterdam
>>>> P.O BOX: 12026 1100 AA, Netherlands
>>>> http://www.news-service.com +31(0)20 398 1111
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>

--------------020409020608080801030505
Content-Type: text/x-csrc;
 name="megaraid_sas.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="megaraid_sas.c"

/*
 *
 *		Linux MegaRAID driver for SAS based RAID controllers
 *
 * Copyright (c) 2003-2005  LSI Corporation.
 *
 *	   This program is free software; you can redistribute it and/or
 *	   modify it under the terms of the GNU General Public License
 *	   as published by the Free Software Foundation; either version
 *	   2 of the License, or (at your option) any later version.
 *
 * FILE		: megaraid_sas.c
 * Version     : v00.00.04.17.1-rc1
 *
 * Authors:
 *	(email-id : megaraidlinux@lsi.com)
 * 	Sreenivas Bagalkote
 * 	Sumant Patro
 *	Bo Yang
 *
 * List of supported controllers
 *
 * OEM	Product Name			VID	DID	SSVID	SSID
 * ---	------------			---	---	----	----
 */

#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/pci.h>
#include <linux/list.h>
#include <linux/moduleparam.h>
#include <linux/module.h>
#include <linux/spinlock.h>
#include <linux/interrupt.h>
#include <linux/delay.h>
#include <linux/smp_lock.h>
#include <linux/uio.h>
#include <linux/slab.h>
#include <asm/uaccess.h>
#include <linux/fs.h>
#include <linux/compat.h>
#include <linux/blkdev.h>
#include <linux/mutex.h>
#include <linux/poll.h>

#include <scsi/scsi.h>
#include <scsi/scsi_cmnd.h>
#include <scsi/scsi_device.h>
#include <scsi/scsi_host.h>
#include "megaraid_sas.h"

/*
 * poll_mode_io:1- schedule complete completion from q cmd
 */
static unsigned int poll_mode_io;
module_param_named(poll_mode_io, poll_mode_io, int, 0);
MODULE_PARM_DESC(poll_mode_io,
	"Complete cmds from IO path, (default=0)");

/*
 * Number of sectors per IO command
 * Will be set in megasas_init_mfi if user does not provide
 */
static unsigned int max_sectors;
module_param_named(max_sectors, max_sectors, int, 0);
MODULE_PARM_DESC(max_sectors,
	"Maximum number of sectors per IO command");

MODULE_LICENSE("GPL");
MODULE_VERSION(MEGASAS_VERSION);
MODULE_AUTHOR("megaraidlinux@lsi.com");
MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");

/*
 * PCI ID table for all supported controllers
 */
static struct pci_device_id megasas_pci_table[] = {

	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064R)},
	/* xscale IOP */
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078R)},
	/* ppc IOP */
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078DE)},
	/* ppc IOP */
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078GEN2)},
	/* gen2*/
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0079GEN2)},
	/* gen2*/
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0073SKINNY)},
	/* skinny*/
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0071SKINNY)},
	/* skinny*/
	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VERDE_ZCR)},
	/* xscale IOP, vega */
	{PCI_DEVICE(PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_PERC5)},
	/* xscale IOP */
	{}
};

MODULE_DEVICE_TABLE(pci, megasas_pci_table);

static int megasas_mgmt_majorno;
static struct megasas_mgmt_info megasas_mgmt_info;
static struct fasync_struct *megasas_async_queue;
static DEFINE_MUTEX(megasas_async_queue_mutex);

static int megasas_poll_wait_aen;
static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
static u32 support_poll_for_event;
static u32 megasas_dbg_lvl;
static u32 support_device_change;

/* define lock for aen poll */
spinlock_t poll_aen_lock;

static void
megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
		     u8 alt_status);

static int megasas_transition_to_ready(struct megasas_instance *instance);
static int megasas_get_pd_list(struct megasas_instance *instance);
static int megasas_issue_init_mfi(struct megasas_instance *instance);
static int megasas_register_aen(struct megasas_instance *instance,
				u32 seq_num, u32 class_locale_word);

/**
 * megasas_get_cmd -	Get a command from the free pool
 * @instance:		Adapter soft state
 *
 * Returns a free command from the pool
 */
static struct megasas_cmd *megasas_get_cmd(struct megasas_instance
						  *instance)
{
	unsigned long flags;
	struct megasas_cmd *cmd = NULL;

	spin_lock_irqsave(&instance->cmd_pool_lock, flags);

	if (!list_empty(&instance->cmd_pool)) {
		cmd = list_entry((&instance->cmd_pool)->next,
				 struct megasas_cmd, list);
		list_del_init(&cmd->list);
	} else {
		printk(KERN_ERR "megasas: Command pool empty!\n");
	}

	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
	return cmd;
}

/**
 * megasas_return_cmd -	Return a cmd to free command pool
 * @instance:		Adapter soft state
 * @cmd:		Command packet to be returned to free command pool
 */
static inline void
megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
{
	unsigned long flags;

	spin_lock_irqsave(&instance->cmd_pool_lock, flags);

	cmd->scmd = NULL;
	list_add_tail(&cmd->list, &instance->cmd_pool);

	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
}


/**
*	The following functions are defined for xscale 
*	(deviceid : 1064R, PERC5) controllers
*/

/**
 * megasas_enable_intr_xscale -	Enables interrupts
 * @regs:			MFI register set
 */
static inline void
megasas_enable_intr_xscale(struct megasas_register_set __iomem * regs)
{
	writel(0, &(regs)->outbound_intr_mask);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_disable_intr_xscale -Disables interrupt
 * @regs:			MFI register set
 */
static inline void
megasas_disable_intr_xscale(struct megasas_register_set __iomem * regs)
{
	u32 mask = 0x1f;
	writel(mask, &regs->outbound_intr_mask);
	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_read_fw_status_reg_xscale - returns the current FW status value
 * @regs:			MFI register set
 */
static u32
megasas_read_fw_status_reg_xscale(struct megasas_register_set __iomem * regs)
{
	return readl(&(regs)->outbound_msg_0);
}
/**
 * megasas_clear_interrupt_xscale -	Check & clear interrupt
 * @regs:				MFI register set
 */
static int 
megasas_clear_intr_xscale(struct megasas_register_set __iomem * regs)
{
	u32 status;
	u32 mfiStatus = 0;
	/*
	 * Check if it is our interrupt
	 */
	status = readl(&regs->outbound_intr_status);

	if (status & MFI_OB_INTR_STATUS_MASK)
		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
	if (status & MFI_XSCALE_OMR0_CHANGE_INTERRUPT)
		mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;

	/*
	 * Clear the interrupt by writing back the same value
	 */
	if (mfiStatus)
		writel(status, &regs->outbound_intr_status);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_status);

	return mfiStatus;
}

/**
 * megasas_fire_cmd_xscale -	Sends command to the FW
 * @frame_phys_addr :		Physical address of cmd
 * @frame_count :		Number of frames for the command
 * @regs :			MFI register set
 */
static inline void 
megasas_fire_cmd_xscale(struct megasas_instance *instance,
		dma_addr_t frame_phys_addr,
		u32 frame_count,
		struct megasas_register_set __iomem *regs)
{
	unsigned long flags;
	spin_lock_irqsave(&instance->hba_lock, flags);
	writel((frame_phys_addr >> 3)|(frame_count),
	       &(regs)->inbound_queue_port);
	spin_unlock_irqrestore(&instance->hba_lock, flags);
}

/**
 * megasas_adp_reset_xscale -  For controller reset
 * @regs:                              MFI register set
 */
static int
megasas_adp_reset_xscale(struct megasas_instance *instance,
	struct megasas_register_set __iomem *regs)
{
	u32 i;
	u32 pcidata;
	writel(MFI_ADP_RESET, &regs->inbound_doorbell);

	for (i = 0; i < 3; i++)
		msleep(1000); /* sleep for 3 secs */
	pcidata  = 0;
	pci_read_config_dword(instance->pdev, MFI_1068_PCSR_OFFSET, &pcidata);
	printk(KERN_NOTICE "pcidata = %x\n", pcidata);
	if (pcidata & 0x2) {
		printk(KERN_NOTICE "mfi 1068 offset read=%x\n", pcidata);
		pcidata &= ~0x2;
		pci_write_config_dword(instance->pdev,
				MFI_1068_PCSR_OFFSET, pcidata);

		for (i = 0; i < 2; i++)
			msleep(1000); /* need to wait 2 secs again */

		pcidata  = 0;
		pci_read_config_dword(instance->pdev,
				MFI_1068_FW_HANDSHAKE_OFFSET, &pcidata);
		printk(KERN_NOTICE "1068 offset handshake read=%x\n", pcidata);
		if ((pcidata & 0xffff0000) == MFI_1068_FW_READY) {
			printk(KERN_NOTICE "1068 offset pcidt=%x\n", pcidata);
			pcidata = 0;
			pci_write_config_dword(instance->pdev,
				MFI_1068_FW_HANDSHAKE_OFFSET, pcidata);
		}
	}
	return 0;
}

/**
 * megasas_check_reset_xscale -	For controller reset check
 * @regs:				MFI register set
 */
static int
megasas_check_reset_xscale(struct megasas_instance *instance,
		struct megasas_register_set __iomem *regs)
{
	u32 consumer;
	consumer = *instance->consumer;

	if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
		(*instance->consumer == MEGASAS_ADPRESET_INPROG_SIGN)) {
		return 1;
	}
	return 0;
}

static struct megasas_instance_template megasas_instance_template_xscale = {

	.fire_cmd = megasas_fire_cmd_xscale,
	.enable_intr = megasas_enable_intr_xscale,
	.disable_intr = megasas_disable_intr_xscale,
	.clear_intr = megasas_clear_intr_xscale,
	.read_fw_status_reg = megasas_read_fw_status_reg_xscale,
	.adp_reset = megasas_adp_reset_xscale,
	.check_reset = megasas_check_reset_xscale,
};

/**
*	This is the end of set of functions & definitions specific 
*	to xscale (deviceid : 1064R, PERC5) controllers
*/

/**
*	The following functions are defined for ppc (deviceid : 0x60) 
* 	controllers
*/

/**
 * megasas_enable_intr_ppc -	Enables interrupts
 * @regs:			MFI register set
 */
static inline void
megasas_enable_intr_ppc(struct megasas_register_set __iomem * regs)
{
	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
    
	writel(~0x80000000, &(regs)->outbound_intr_mask);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_disable_intr_ppc -	Disable interrupt
 * @regs:			MFI register set
 */
static inline void
megasas_disable_intr_ppc(struct megasas_register_set __iomem * regs)
{
	u32 mask = 0xFFFFFFFF;
	writel(mask, &regs->outbound_intr_mask);
	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_read_fw_status_reg_ppc - returns the current FW status value
 * @regs:			MFI register set
 */
static u32
megasas_read_fw_status_reg_ppc(struct megasas_register_set __iomem * regs)
{
	return readl(&(regs)->outbound_scratch_pad);
}

/**
 * megasas_clear_interrupt_ppc -	Check & clear interrupt
 * @regs:				MFI register set
 */
static int 
megasas_clear_intr_ppc(struct megasas_register_set __iomem * regs)
{
	u32 status;
	/*
	 * Check if it is our interrupt
	 */
	status = readl(&regs->outbound_intr_status);

	if (!(status & MFI_REPLY_1078_MESSAGE_INTERRUPT)) {
		return 0;
	}

	/*
	 * Clear the interrupt by writing back the same value
	 */
	writel(status, &regs->outbound_doorbell_clear);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_doorbell_clear);

	return 1;
}
/**
 * megasas_fire_cmd_ppc -	Sends command to the FW
 * @frame_phys_addr :		Physical address of cmd
 * @frame_count :		Number of frames for the command
 * @regs :			MFI register set
 */
static inline void 
megasas_fire_cmd_ppc(struct megasas_instance *instance,
		dma_addr_t frame_phys_addr,
		u32 frame_count,
		struct megasas_register_set __iomem *regs)
{
	unsigned long flags;
	spin_lock_irqsave(&instance->hba_lock, flags);
	writel((frame_phys_addr | (frame_count<<1))|1, 
			&(regs)->inbound_queue_port);
	spin_unlock_irqrestore(&instance->hba_lock, flags);
}

/**
 * megasas_adp_reset_ppc -	For controller reset
 * @regs:				MFI register set
 */
static int
megasas_adp_reset_ppc(struct megasas_instance *instance,
			struct megasas_register_set __iomem *regs)
{
	return 0;
}

/**
 * megasas_check_reset_ppc -	For controller reset check
 * @regs:				MFI register set
 */
static int
megasas_check_reset_ppc(struct megasas_instance *instance,
			struct megasas_register_set __iomem *regs)
{
	return 0;
}
static struct megasas_instance_template megasas_instance_template_ppc = {
	
	.fire_cmd = megasas_fire_cmd_ppc,
	.enable_intr = megasas_enable_intr_ppc,
	.disable_intr = megasas_disable_intr_ppc,
	.clear_intr = megasas_clear_intr_ppc,
	.read_fw_status_reg = megasas_read_fw_status_reg_ppc,
	.adp_reset = megasas_adp_reset_ppc,
	.check_reset = megasas_check_reset_ppc,
};

/**
 * megasas_enable_intr_skinny -	Enables interrupts
 * @regs:			MFI register set
 */
static inline void
megasas_enable_intr_skinny(struct megasas_register_set __iomem *regs)
{
	writel(0xFFFFFFFF, &(regs)->outbound_intr_mask);

	writel(~MFI_SKINNY_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_disable_intr_skinny -	Disables interrupt
 * @regs:			MFI register set
 */
static inline void
megasas_disable_intr_skinny(struct megasas_register_set __iomem *regs)
{
	u32 mask = 0xFFFFFFFF;
	writel(mask, &regs->outbound_intr_mask);
	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_read_fw_status_reg_skinny - returns the current FW status value
 * @regs:			MFI register set
 */
static u32
megasas_read_fw_status_reg_skinny(struct megasas_register_set __iomem *regs)
{
	return readl(&(regs)->outbound_scratch_pad);
}

/**
 * megasas_clear_interrupt_skinny -	Check & clear interrupt
 * @regs:				MFI register set
 */
static int
megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
{
	u32 status;
	/*
	 * Check if it is our interrupt
	 */
	status = readl(&regs->outbound_intr_status);

	if (!(status & MFI_SKINNY_ENABLE_INTERRUPT_MASK)) {
		return 0;
	}

	/*
	 * Clear the interrupt by writing back the same value
	 */
	writel(status, &regs->outbound_intr_status);

	/*
	* dummy read to flush PCI
	*/
	readl(&regs->outbound_intr_status);

	return 1;
}

/**
 * megasas_fire_cmd_skinny -	Sends command to the FW
 * @frame_phys_addr :		Physical address of cmd
 * @frame_count :		Number of frames for the command
 * @regs :			MFI register set
 */
static inline void
megasas_fire_cmd_skinny(struct megasas_instance *instance,
			dma_addr_t frame_phys_addr,
			u32 frame_count,
			struct megasas_register_set __iomem *regs)
{
	unsigned long flags;
	spin_lock_irqsave(&instance->hba_lock, flags);
	writel(0, &(regs)->inbound_high_queue_port);
	writel((frame_phys_addr | (frame_count<<1))|1,
		&(regs)->inbound_low_queue_port);
	spin_unlock_irqrestore(&instance->hba_lock, flags);
}

/**
 * megasas_adp_reset_skinny -	For controller reset
 * @regs:				MFI register set
 */
static int
megasas_adp_reset_skinny(struct megasas_instance *instance,
			struct megasas_register_set __iomem *regs)
{
	return 0;
}

/**
 * megasas_check_reset_skinny -	For controller reset check
 * @regs:				MFI register set
 */
static int
megasas_check_reset_skinny(struct megasas_instance *instance,
				struct megasas_register_set __iomem *regs)
{
	return 0;
}

static struct megasas_instance_template megasas_instance_template_skinny = {

	.fire_cmd = megasas_fire_cmd_skinny,
	.enable_intr = megasas_enable_intr_skinny,
	.disable_intr = megasas_disable_intr_skinny,
	.clear_intr = megasas_clear_intr_skinny,
	.read_fw_status_reg = megasas_read_fw_status_reg_skinny,
	.adp_reset = megasas_adp_reset_skinny,
	.check_reset = megasas_check_reset_skinny,
};


/**
*	The following functions are defined for gen2 (deviceid : 0x78 0x79)
*	controllers
*/

/**
 * megasas_enable_intr_gen2 -  Enables interrupts
 * @regs:                      MFI register set
 */
static inline void
megasas_enable_intr_gen2(struct megasas_register_set __iomem *regs)
{
	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);

	/* write ~0x00000005 (4 & 1) to the intr mask*/
	writel(~MFI_GEN2_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_disable_intr_gen2 - Disables interrupt
 * @regs:                      MFI register set
 */
static inline void
megasas_disable_intr_gen2(struct megasas_register_set __iomem *regs)
{
	u32 mask = 0xFFFFFFFF;
	writel(mask, &regs->outbound_intr_mask);
	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_mask);
}

/**
 * megasas_read_fw_status_reg_gen2 - returns the current FW status value
 * @regs:                      MFI register set
 */
static u32
megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem *regs)
{
	return readl(&(regs)->outbound_scratch_pad);
}

/**
 * megasas_clear_interrupt_gen2 -      Check & clear interrupt
 * @regs:                              MFI register set
 */
static int
megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
{
	u32 status;
	u32 mfiStatus = 0;
	/*
	 * Check if it is our interrupt
	 */
	status = readl(&regs->outbound_intr_status);

	if (status & MFI_GEN2_ENABLE_INTERRUPT_MASK) {
		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
	}
	if (status & MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT) {
		mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
	}

	/*
	 * Clear the interrupt by writing back the same value
	 */
	if (mfiStatus)
		writel(status, &regs->outbound_doorbell_clear);

	/* Dummy readl to force pci flush */
	readl(&regs->outbound_intr_status);

	return mfiStatus;
}
/**
 * megasas_fire_cmd_gen2 -     Sends command to the FW
 * @frame_phys_addr :          Physical address of cmd
 * @frame_count :              Number of frames for the command
 * @regs :                     MFI register set
 */
static inline void
megasas_fire_cmd_gen2(struct megasas_instance *instance,
			dma_addr_t frame_phys_addr,
			u32 frame_count,
			struct megasas_register_set __iomem *regs)
{
	unsigned long flags;
	spin_lock_irqsave(&instance->hba_lock, flags);
	writel((frame_phys_addr | (frame_count<<1))|1,
			&(regs)->inbound_queue_port);
	spin_unlock_irqrestore(&instance->hba_lock, flags);
}

/**
 * megasas_adp_reset_gen2 -	For controller reset
 * @regs:				MFI register set
 */
static int
megasas_adp_reset_gen2(struct megasas_instance *instance,
			struct megasas_register_set __iomem *reg_set)
{
	u32			retry = 0 ;
	u32			HostDiag;

	writel(0, &reg_set->seq_offset);
	writel(4, &reg_set->seq_offset);
	writel(0xb, &reg_set->seq_offset);
	writel(2, &reg_set->seq_offset);
	writel(7, &reg_set->seq_offset);
	writel(0xd, &reg_set->seq_offset);
	msleep(1000);

	HostDiag = (u32)readl(&reg_set->host_diag);

	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
		msleep(100);
		HostDiag = (u32)readl(&reg_set->host_diag);
		printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
					retry, HostDiag);

		if (retry++ >= 100)
			return 1;

	}

	printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);

	writel((HostDiag | DIAG_RESET_ADAPTER), &reg_set->host_diag);

	ssleep(10);

	HostDiag = (u32)readl(&reg_set->host_diag);
	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
		msleep(100);
		HostDiag = (u32)readl(&reg_set->host_diag);
		printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
				retry, HostDiag);

		if (retry++ >= 1000)
			return 1;

	}
	return 0;
}

/**
 * megasas_check_reset_gen2 -	For controller reset check
 * @regs:				MFI register set
 */
static int
megasas_check_reset_gen2(struct megasas_instance *instance,
		struct megasas_register_set __iomem *regs)
{
	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
		return 1;
	}

	return 0;
}

static struct megasas_instance_template megasas_instance_template_gen2 = {

	.fire_cmd = megasas_fire_cmd_gen2,
	.enable_intr = megasas_enable_intr_gen2,
	.disable_intr = megasas_disable_intr_gen2,
	.clear_intr = megasas_clear_intr_gen2,
	.read_fw_status_reg = megasas_read_fw_status_reg_gen2,
	.adp_reset = megasas_adp_reset_gen2,
	.check_reset = megasas_check_reset_gen2,
};

/**
*	This is the end of set of functions & definitions
*       specific to gen2 (deviceid : 0x78, 0x79) controllers
*/

/**
 * megasas_issue_polled -	Issues a polling command
 * @instance:			Adapter soft state
 * @cmd:			Command packet to be issued 
 *
 * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
 */
static int
megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
{
	int i;
	u32 msecs = MFI_POLL_TIMEOUT_SECS * 1000;

	struct megasas_header *frame_hdr = &cmd->frame->hdr;

	frame_hdr->cmd_status = 0xFF;
	frame_hdr->flags |= MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;

	/*
	 * Issue the frame using inbound queue port
	 */
	instance->instancet->fire_cmd(instance,
			cmd->frame_phys_addr, 0, instance->reg_set);

	/*
	 * Wait for cmd_status to change
	 */
	for (i = 0; (i < msecs) && (frame_hdr->cmd_status == 0xff); i++) {
		rmb();
		msleep(1);
	}

	if (frame_hdr->cmd_status == 0xff)
		return -ETIME;

	return 0;
}

/**
 * megasas_issue_blocked_cmd -	Synchronous wrapper around regular FW cmds
 * @instance:			Adapter soft state
 * @cmd:			Command to be issued
 *
 * This function waits on an event for the command to be returned from ISR.
 * Max wait time is MEGASAS_INTERNAL_CMD_WAIT_TIME secs
 * Used to issue ioctl commands.
 */
static int
megasas_issue_blocked_cmd(struct megasas_instance *instance,
			  struct megasas_cmd *cmd)
{
	cmd->cmd_status = ENODATA;

	instance->instancet->fire_cmd(instance,
			cmd->frame_phys_addr, 0, instance->reg_set);

	wait_event(instance->int_cmd_wait_q, cmd->cmd_status != ENODATA);

	return 0;
}

/**
 * megasas_issue_blocked_abort_cmd -	Aborts previously issued cmd
 * @instance:				Adapter soft state
 * @cmd_to_abort:			Previously issued cmd to be aborted
 *
 * MFI firmware can abort previously issued AEN comamnd (automatic event
 * notification). The megasas_issue_blocked_abort_cmd() issues such abort
 * cmd and waits for return status.
 * Max wait time is MEGASAS_INTERNAL_CMD_WAIT_TIME secs
 */
static int
megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
				struct megasas_cmd *cmd_to_abort)
{
	struct megasas_cmd *cmd;
	struct megasas_abort_frame *abort_fr;

	cmd = megasas_get_cmd(instance);

	if (!cmd)
		return -1;

	abort_fr = &cmd->frame->abort;

	/*
	 * Prepare and issue the abort frame
	 */
	abort_fr->cmd = MFI_CMD_ABORT;
	abort_fr->cmd_status = 0xFF;
	abort_fr->flags = 0;
	abort_fr->abort_context = cmd_to_abort->index;
	abort_fr->abort_mfi_phys_addr_lo = cmd_to_abort->frame_phys_addr;
	abort_fr->abort_mfi_phys_addr_hi = 0;

	cmd->sync_cmd = 1;
	cmd->cmd_status = 0xFF;

	instance->instancet->fire_cmd(instance,
			cmd->frame_phys_addr, 0, instance->reg_set);

	/*
	 * Wait for this cmd to complete
	 */
	wait_event(instance->abort_cmd_wait_q, cmd->cmd_status != 0xFF);
	cmd->sync_cmd = 0;

	megasas_return_cmd(instance, cmd);
	return 0;
}

/**
 * megasas_make_sgl32 -	Prepares 32-bit SGL
 * @instance:		Adapter soft state
 * @scp:		SCSI command from the mid-layer
 * @mfi_sgl:		SGL to be filled in
 *
 * If successful, this function returns the number of SG elements. Otherwise,
 * it returnes -1.
 */
static int
megasas_make_sgl32(struct megasas_instance *instance, struct scsi_cmnd *scp,
		   union megasas_sgl *mfi_sgl)
{
	int i;
	int sge_count;
	struct scatterlist *os_sgl;

	sge_count = scsi_dma_map(scp);
	BUG_ON(sge_count < 0);

	if (sge_count) {
		scsi_for_each_sg(scp, os_sgl, sge_count, i) {
			mfi_sgl->sge32[i].length = sg_dma_len(os_sgl);
			mfi_sgl->sge32[i].phys_addr = sg_dma_address(os_sgl);
		}
	}
	return sge_count;
}

/**
 * megasas_make_sgl64 -	Prepares 64-bit SGL
 * @instance:		Adapter soft state
 * @scp:		SCSI command from the mid-layer
 * @mfi_sgl:		SGL to be filled in
 *
 * If successful, this function returns the number of SG elements. Otherwise,
 * it returnes -1.
 */
static int
megasas_make_sgl64(struct megasas_instance *instance, struct scsi_cmnd *scp,
		   union megasas_sgl *mfi_sgl)
{
	int i;
	int sge_count;
	struct scatterlist *os_sgl;

	sge_count = scsi_dma_map(scp);
	BUG_ON(sge_count < 0);

	if (sge_count) {
		scsi_for_each_sg(scp, os_sgl, sge_count, i) {
			mfi_sgl->sge64[i].length = sg_dma_len(os_sgl);
			mfi_sgl->sge64[i].phys_addr = sg_dma_address(os_sgl);
		}
	}
	return sge_count;
}

/**
 * megasas_make_sgl_skinny - Prepares IEEE SGL
 * @instance:           Adapter soft state
 * @scp:                SCSI command from the mid-layer
 * @mfi_sgl:            SGL to be filled in
 *
 * If successful, this function returns the number of SG elements. Otherwise,
 * it returnes -1.
 */
static int
megasas_make_sgl_skinny(struct megasas_instance *instance,
		struct scsi_cmnd *scp, union megasas_sgl *mfi_sgl)
{
	int i;
	int sge_count;
	struct scatterlist *os_sgl;

	sge_count = scsi_dma_map(scp);

	if (sge_count) {
		scsi_for_each_sg(scp, os_sgl, sge_count, i) {
			mfi_sgl->sge_skinny[i].length = sg_dma_len(os_sgl);
			mfi_sgl->sge_skinny[i].phys_addr =
						sg_dma_address(os_sgl);
			mfi_sgl->sge_skinny[i].flag = 0;
		}
	}
	return sge_count;
}

 /**
 * megasas_get_frame_count - Computes the number of frames
 * @frame_type		: type of frame- io or pthru frame
 * @sge_count		: number of sg elements
 *
 * Returns the number of frames required for numnber of sge's (sge_count)
 */

static u32 megasas_get_frame_count(struct megasas_instance *instance,
			u8 sge_count, u8 frame_type)
{
	int num_cnt;
	int sge_bytes;
	u32 sge_sz;
	u32 frame_count=0;

	sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
	    sizeof(struct megasas_sge32);

	if (instance->flag_ieee) {
		sge_sz = sizeof(struct megasas_sge_skinny);
	}

	/*
	 * Main frame can contain 2 SGEs for 64-bit SGLs and
	 * 3 SGEs for 32-bit SGLs for ldio &
	 * 1 SGEs for 64-bit SGLs and
	 * 2 SGEs for 32-bit SGLs for pthru frame
	 */
	if (unlikely(frame_type == PTHRU_FRAME)) {
		if (instance->flag_ieee == 1) {
			num_cnt = sge_count - 1;
		} else if (IS_DMA64)
			num_cnt = sge_count - 1;
		else
			num_cnt = sge_count - 2;
	} else {
		if (instance->flag_ieee == 1) {
			num_cnt = sge_count - 1;
		} else if (IS_DMA64)
			num_cnt = sge_count - 2;
		else
			num_cnt = sge_count - 3;
	}

	if(num_cnt>0){
		sge_bytes = sge_sz * num_cnt;

		frame_count = (sge_bytes / MEGAMFI_FRAME_SIZE) +
		    ((sge_bytes % MEGAMFI_FRAME_SIZE) ? 1 : 0) ;
	}
	/* Main frame */
	frame_count +=1;

	if (frame_count > 7)
		frame_count = 8;
	return frame_count;
}

/**
 * megasas_build_dcdb -	Prepares a direct cdb (DCDB) command
 * @instance:		Adapter soft state
 * @scp:		SCSI command
 * @cmd:		Command to be prepared in
 *
 * This function prepares CDB commands. These are typcially pass-through
 * commands to the devices.
 */
static int
megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
		   struct megasas_cmd *cmd)
{
	u32 is_logical;
	u32 device_id;
	u16 flags = 0;
	struct megasas_pthru_frame *pthru;

	is_logical = MEGASAS_IS_LOGICAL(scp);
	device_id = MEGASAS_DEV_INDEX(instance, scp);
	pthru = (struct megasas_pthru_frame *)cmd->frame;

	if (scp->sc_data_direction == PCI_DMA_TODEVICE)
		flags = MFI_FRAME_DIR_WRITE;
	else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
		flags = MFI_FRAME_DIR_READ;
	else if (scp->sc_data_direction == PCI_DMA_NONE)
		flags = MFI_FRAME_DIR_NONE;

	if (instance->flag_ieee == 1) {
		flags |= MFI_FRAME_IEEE;
	}

	/*
	 * Prepare the DCDB frame
	 */
	pthru->cmd = (is_logical) ? MFI_CMD_LD_SCSI_IO : MFI_CMD_PD_SCSI_IO;
	pthru->cmd_status = 0x0;
	pthru->scsi_status = 0x0;
	pthru->target_id = device_id;
	pthru->lun = scp->device->lun;
	pthru->cdb_len = scp->cmd_len;
	pthru->timeout = 0;
	pthru->pad_0 = 0;
	pthru->flags = flags;
	pthru->data_xfer_len = scsi_bufflen(scp);

	memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);

	/*
	* If the command is for the tape device, set the
	* pthru timeout to the os layer timeout value.
	*/
	if (scp->device->type == TYPE_TAPE) {
		if ((scp->request->timeout / HZ) > 0xFFFF)
			pthru->timeout = 0xFFFF;
		else
			pthru->timeout = scp->request->timeout / HZ;
	}

	/*
	 * Construct SGL
	 */
	if (instance->flag_ieee == 1) {
		pthru->flags |= MFI_FRAME_SGL64;
		pthru->sge_count = megasas_make_sgl_skinny(instance, scp,
						      &pthru->sgl);
	} else if (IS_DMA64) {
		pthru->flags |= MFI_FRAME_SGL64;
		pthru->sge_count = megasas_make_sgl64(instance, scp,
						      &pthru->sgl);
	} else
		pthru->sge_count = megasas_make_sgl32(instance, scp,
						      &pthru->sgl);

	if (pthru->sge_count > instance->max_num_sge) {
		printk(KERN_ERR "megasas: DCDB two many SGE NUM=%x\n",
			pthru->sge_count);
		return 0;
	}

	/*
	 * Sense info specific
	 */
	pthru->sense_len = SCSI_SENSE_BUFFERSIZE;
	pthru->sense_buf_phys_addr_hi = 0;
	pthru->sense_buf_phys_addr_lo = cmd->sense_phys_addr;

	/*
	 * Compute the total number of frames this command consumes. FW uses
	 * this number to pull sufficient number of frames from host memory.
	 */
	cmd->frame_count = megasas_get_frame_count(instance, pthru->sge_count,
							PTHRU_FRAME);

	return cmd->frame_count;
}

/**
 * megasas_build_ldio -	Prepares IOs to logical devices
 * @instance:		Adapter soft state
 * @scp:		SCSI command
 * @cmd:		Command to be prepared
 *
 * Frames (and accompanying SGLs) for regular SCSI IOs use this function.
 */
static int
megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
		   struct megasas_cmd *cmd)
{
	u32 device_id;
	u8 sc = scp->cmnd[0];
	u16 flags = 0;
	struct megasas_io_frame *ldio;

	device_id = MEGASAS_DEV_INDEX(instance, scp);
	ldio = (struct megasas_io_frame *)cmd->frame;

	if (scp->sc_data_direction == PCI_DMA_TODEVICE)
		flags = MFI_FRAME_DIR_WRITE;
	else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
		flags = MFI_FRAME_DIR_READ;

	if (instance->flag_ieee == 1) {
		flags |= MFI_FRAME_IEEE;
	}

	/*
	 * Prepare the Logical IO frame: 2nd bit is zero for all read cmds
	 */
	ldio->cmd = (sc & 0x02) ? MFI_CMD_LD_WRITE : MFI_CMD_LD_READ;
	ldio->cmd_status = 0x0;
	ldio->scsi_status = 0x0;
	ldio->target_id = device_id;
	ldio->timeout = 0;
	ldio->reserved_0 = 0;
	ldio->pad_0 = 0;
	ldio->flags = flags;
	ldio->start_lba_hi = 0;
	ldio->access_byte = (scp->cmd_len != 6) ? scp->cmnd[1] : 0;

	/*
	 * 6-byte READ(0x08) or WRITE(0x0A) cdb
	 */
	if (scp->cmd_len == 6) {
		ldio->lba_count = (u32) scp->cmnd[4];
		ldio->start_lba_lo = ((u32) scp->cmnd[1] << 16) |
		    ((u32) scp->cmnd[2] << 8) | (u32) scp->cmnd[3];

		ldio->start_lba_lo &= 0x1FFFFF;
	}

	/*
	 * 10-byte READ(0x28) or WRITE(0x2A) cdb
	 */
	else if (scp->cmd_len == 10) {
		ldio->lba_count = (u32) scp->cmnd[8] |
		    ((u32) scp->cmnd[7] << 8);
		ldio->start_lba_lo = ((u32) scp->cmnd[2] << 24) |
		    ((u32) scp->cmnd[3] << 16) |
		    ((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
	}

	/*
	 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
	 */
	else if (scp->cmd_len == 12) {
		ldio->lba_count = ((u32) scp->cmnd[6] << 24) |
		    ((u32) scp->cmnd[7] << 16) |
		    ((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];

		ldio->start_lba_lo = ((u32) scp->cmnd[2] << 24) |
		    ((u32) scp->cmnd[3] << 16) |
		    ((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
	}

	/*
	 * 16-byte READ(0x88) or WRITE(0x8A) cdb
	 */
	else if (scp->cmd_len == 16) {
		ldio->lba_count = ((u32) scp->cmnd[10] << 24) |
		    ((u32) scp->cmnd[11] << 16) |
		    ((u32) scp->cmnd[12] << 8) | (u32) scp->cmnd[13];

		ldio->start_lba_lo = ((u32) scp->cmnd[6] << 24) |
		    ((u32) scp->cmnd[7] << 16) |
		    ((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];

		ldio->start_lba_hi = ((u32) scp->cmnd[2] << 24) |
		    ((u32) scp->cmnd[3] << 16) |
		    ((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];

	}

	/*
	 * Construct SGL
	 */
	if (instance->flag_ieee) {
		ldio->flags |= MFI_FRAME_SGL64;
		ldio->sge_count = megasas_make_sgl_skinny(instance, scp,
					      &ldio->sgl);
	} else if (IS_DMA64) {
		ldio->flags |= MFI_FRAME_SGL64;
		ldio->sge_count = megasas_make_sgl64(instance, scp, &ldio->sgl);
	} else
		ldio->sge_count = megasas_make_sgl32(instance, scp, &ldio->sgl);

	if (ldio->sge_count > instance->max_num_sge) {
		printk(KERN_ERR "megasas: build_ld_io: sge_count = %x\n",
			ldio->sge_count);
		return 0;
	}

	/*
	 * Sense info specific
	 */
	ldio->sense_len = SCSI_SENSE_BUFFERSIZE;
	ldio->sense_buf_phys_addr_hi = 0;
	ldio->sense_buf_phys_addr_lo = cmd->sense_phys_addr;

	/*
	 * Compute the total number of frames this command consumes. FW uses
	 * this number to pull sufficient number of frames from host memory.
	 */
	cmd->frame_count = megasas_get_frame_count(instance,
			ldio->sge_count, IO_FRAME);

	return cmd->frame_count;
}

/**
 * megasas_is_ldio -		Checks if the cmd is for logical drive
 * @scmd:			SCSI command
 *	
 * Called by megasas_queue_command to find out if the command to be queued
 * is a logical drive command	
 */
static inline int megasas_is_ldio(struct scsi_cmnd *cmd)
{
	if (!MEGASAS_IS_LOGICAL(cmd))
		return 0;
	switch (cmd->cmnd[0]) {
	case READ_10:
	case WRITE_10:
	case READ_12:
	case WRITE_12:
	case READ_6:
	case WRITE_6:
	case READ_16:
	case WRITE_16:
		return 1;
	default:
		return 0;
	}
}

 /**
 * megasas_dump_pending_frames -	Dumps the frame address of all pending cmds
 *                              	in FW
 * @instance:				Adapter soft state
 */
static inline void
megasas_dump_pending_frames(struct megasas_instance *instance)
{
	struct megasas_cmd *cmd;
	int i,n;
	union megasas_sgl *mfi_sgl;
	struct megasas_io_frame *ldio;
	struct megasas_pthru_frame *pthru;
	u32 sgcount;
	u32 max_cmd = instance->max_fw_cmds;

	printk(KERN_ERR "\nmegasas[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
	printk(KERN_ERR "megasas[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
	if (IS_DMA64)
		printk(KERN_ERR "\nmegasas[%d]: 64 bit SGLs were sent to FW\n",instance->host->host_no);
	else
		printk(KERN_ERR "\nmegasas[%d]: 32 bit SGLs were sent to FW\n",instance->host->host_no);

	printk(KERN_ERR "megasas[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
	for (i = 0; i < max_cmd; i++) {
		cmd = instance->cmd_list[i];
		if(!cmd->scmd)
			continue;
		printk(KERN_ERR "megasas[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
		if (megasas_is_ldio(cmd->scmd)){
			ldio = (struct megasas_io_frame *)cmd->frame;
			mfi_sgl = &ldio->sgl;
			sgcount = ldio->sge_count;
			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",instance->host->host_no, cmd->frame_count,ldio->cmd,ldio->target_id, ldio->start_lba_lo,ldio->start_lba_hi,ldio->sense_buf_phys_addr_lo,sgcount);
		}
		else {
			pthru = (struct megasas_pthru_frame *) cmd->frame;
			mfi_sgl = &pthru->sgl;
			sgcount = pthru->sge_count;
			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",instance->host->host_no,cmd->frame_count,pthru->cmd,pthru->target_id,pthru->lun,pthru->cdb_len , pthru->data_xfer_len,pthru->sense_buf_phys_addr_lo,sgcount);
		}
	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
		for (n = 0; n < sgcount; n++){
			if (IS_DMA64)
				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%08lx ",mfi_sgl->sge64[n].length , (unsigned long)mfi_sgl->sge64[n].phys_addr) ;
			else
				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%x ",mfi_sgl->sge32[n].length , mfi_sgl->sge32[n].phys_addr) ;
			}
		}
		printk(KERN_ERR "\n");
	} /*for max_cmd*/
	printk(KERN_ERR "\nmegasas[%d]: Pending Internal cmds in FW : \n",instance->host->host_no);
	for (i = 0; i < max_cmd; i++) {

		cmd = instance->cmd_list[i];

		if(cmd->sync_cmd == 1){
			printk(KERN_ERR "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
		}
	}
	printk(KERN_ERR "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
}

/**
 * megasas_queue_command -	Queue entry point
 * @scmd:			SCSI command to be queued
 * @done:			Callback entry point
 */
static int
megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
{
	u32 frame_count;
	struct megasas_cmd *cmd;
	struct megasas_instance *instance;
	unsigned long flags;

	instance = (struct megasas_instance *)
	    scmd->device->host->hostdata;

	if (instance->issuepend_done == 0)
		return SCSI_MLQUEUE_HOST_BUSY;

	spin_lock_irqsave(&instance->hba_lock, flags);
	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
		spin_unlock_irqrestore(&instance->hba_lock, flags);
		return SCSI_MLQUEUE_HOST_BUSY;
	}

	spin_unlock_irqrestore(&instance->hba_lock, flags);

	scmd->scsi_done = done;
	scmd->result = 0;

	if (MEGASAS_IS_LOGICAL(scmd) &&
	    (scmd->device->id >= MEGASAS_MAX_LD || scmd->device->lun)) {
		scmd->result = DID_BAD_TARGET << 16;
		goto out_done;
	}

	switch (scmd->cmnd[0]) {
	case SYNCHRONIZE_CACHE:
		/*
		 * FW takes care of flush cache on its own
		 * No need to send it down
		 */
		scmd->result = DID_OK << 16;
		goto out_done;
	default:
		break;
	}

	cmd = megasas_get_cmd(instance);
	if (!cmd)
		return SCSI_MLQUEUE_HOST_BUSY;

	/*
	 * Logical drive command
	 */
	if (megasas_is_ldio(scmd))
		frame_count = megasas_build_ldio(instance, scmd, cmd);
	else
		frame_count = megasas_build_dcdb(instance, scmd, cmd);

	if (!frame_count)
		goto out_return_cmd;

	cmd->scmd = scmd;
	scmd->SCp.ptr = (char *)cmd;

	/*
	 * Issue the command to the FW
	 */
	atomic_inc(&instance->fw_outstanding);

	instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
				cmd->frame_count-1, instance->reg_set);
	/*
	 * Check if we have pend cmds to be completed
	 */
	if (poll_mode_io && atomic_read(&instance->fw_outstanding))
		tasklet_schedule(&instance->isr_tasklet);


	return 0;

 out_return_cmd:
	megasas_return_cmd(instance, cmd);
 out_done:
	done(scmd);
	return 0;
}

static struct megasas_instance *megasas_lookup_instance(u16 host_no)
{
	int i;

	for (i = 0; i < megasas_mgmt_info.max_index; i++) {

		if ((megasas_mgmt_info.instance[i]) &&
		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
			return megasas_mgmt_info.instance[i];
	}

	return NULL;
}

static int megasas_slave_configure(struct scsi_device *sdev)
{
	u16             pd_index = 0;
	struct  megasas_instance *instance ;

	instance = megasas_lookup_instance(sdev->host->host_no);

	/*
	* Don't export physical disk devices to the disk driver.
	*
	* FIXME: Currently we don't export them to the midlayer at all.
	*        That will be fixed once LSI engineers have audited the
	*        firmware for possible issues.
	*/
	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
				sdev->type == TYPE_DISK) {
		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
								sdev->id;
		if (instance->pd_list[pd_index].driveState ==
						MR_PD_STATE_SYSTEM) {
			blk_queue_rq_timeout(sdev->request_queue,
				MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
			return 0;
		}
		return -ENXIO;
	}

	/*
	* The RAID firmware may require extended timeouts.
	*/
	blk_queue_rq_timeout(sdev->request_queue,
		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
	return 0;
}

static int megasas_slave_alloc(struct scsi_device *sdev)
{
	u16             pd_index = 0;
	struct megasas_instance *instance ;
	instance = megasas_lookup_instance(sdev->host->host_no);
	if ((sdev->channel < MEGASAS_MAX_PD_CHANNELS) &&
				(sdev->type == TYPE_DISK)) {
		/*
		 * Open the OS scan to the SYSTEM PD
		 */
		pd_index =
			(sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
			sdev->id;
		if ((instance->pd_list[pd_index].driveState ==
					MR_PD_STATE_SYSTEM) &&
			(instance->pd_list[pd_index].driveType ==
						TYPE_DISK)) {
			return 0;
		}
		return -ENXIO;
	}
	return 0;
}

static void megaraid_sas_kill_hba(struct megasas_instance *instance)
{
	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
		writel(MFI_STOP_ADP,
			&instance->reg_set->reserved_0[0]);
	} else {
		writel(MFI_STOP_ADP,
			&instance->reg_set->inbound_doorbell);
	}
}

/**
 * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
 * @instance_addr:			Address of adapter soft state
 *
 * Tasklet to complete cmds
 */
static void megasas_complete_cmd_dpc(unsigned long instance_addr)
{
	u32 producer;
	u32 consumer;
	u32 context;
	struct megasas_cmd *cmd;
	struct megasas_instance *instance =
				(struct megasas_instance *)instance_addr;
	unsigned long flags;

	/* If we have already declared adapter dead, donot complete cmds */
	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR )
		return;

	spin_lock_irqsave(&instance->completion_lock, flags);

	producer = *instance->producer;
	consumer = *instance->consumer;

	while (consumer != producer) {
		context = instance->reply_queue[consumer];
		if (context >= instance->max_fw_cmds) {
			printk(KERN_ERR "Unexpected context value %x\n",
				context);
			BUG();
		}

		cmd = instance->cmd_list[context];

		megasas_complete_cmd(instance, cmd, DID_OK);

		consumer++;
		if (consumer == (instance->max_fw_cmds + 1)) {
			consumer = 0;
		}
	}

	*instance->consumer = producer;

	spin_unlock_irqrestore(&instance->completion_lock, flags);

	/*
	 * Check if we can restore can_queue
	 */
	if (instance->flag & MEGASAS_FW_BUSY
		&& time_after(jiffies, instance->last_time + 5 * HZ)
		&& atomic_read(&instance->fw_outstanding) < 17) {

		spin_lock_irqsave(instance->host->host_lock, flags);
		instance->flag &= ~MEGASAS_FW_BUSY;
		if ((instance->pdev->device ==
			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
			(instance->pdev->device ==
			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
			instance->host->can_queue =
				instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
		} else
			instance->host->can_queue =
				instance->max_fw_cmds - MEGASAS_INT_CMDS;

		spin_unlock_irqrestore(instance->host->host_lock, flags);
	}
}

static void
megasas_internal_reset_defer_cmds(struct megasas_instance *instance);

static void
process_fw_state_change_wq(struct work_struct *work);

void megasas_do_ocr(struct megasas_instance *instance)
{
	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
	(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
	(instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR)) {
		*instance->consumer     = MEGASAS_ADPRESET_INPROG_SIGN;
	}
	instance->instancet->disable_intr(instance->reg_set);
	instance->adprecovery   = MEGASAS_ADPRESET_SM_INFAULT;
	instance->issuepend_done = 0;

	atomic_set(&instance->fw_outstanding, 0);
	megasas_internal_reset_defer_cmds(instance);
	process_fw_state_change_wq(&instance->work_init);
}

/**
 * megasas_wait_for_outstanding -	Wait for all outstanding cmds
 * @instance:				Adapter soft state
 *
 * This function waits for upto MEGASAS_RESET_WAIT_TIME seconds for FW to
 * complete all its outstanding commands. Returns error if one or more IOs
 * are pending after this time period. It also marks the controller dead.
 */
static int megasas_wait_for_outstanding(struct megasas_instance *instance)
{
	int i;
	u32 reset_index;
	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
	u8 adprecovery;
	unsigned long flags;
	struct list_head clist_local;
	struct megasas_cmd *reset_cmd;
	u32 fw_state;
	u8 kill_adapter_flag;

	spin_lock_irqsave(&instance->hba_lock, flags);
	adprecovery = instance->adprecovery;
	spin_unlock_irqrestore(&instance->hba_lock, flags);

	if (adprecovery != MEGASAS_HBA_OPERATIONAL) {

		INIT_LIST_HEAD(&clist_local);
		spin_lock_irqsave(&instance->hba_lock, flags);
		list_splice_init(&instance->internal_reset_pending_q,
				&clist_local);
		spin_unlock_irqrestore(&instance->hba_lock, flags);

		printk(KERN_NOTICE "megasas: HBA reset wait ...\n");
		for (i = 0; i < wait_time; i++) {
			msleep(1000);
			spin_lock_irqsave(&instance->hba_lock, flags);
			adprecovery = instance->adprecovery;
			spin_unlock_irqrestore(&instance->hba_lock, flags);
			if (adprecovery == MEGASAS_HBA_OPERATIONAL)
				break;
		}

		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
			printk(KERN_NOTICE "megasas: reset: Stopping HBA.\n");
			spin_lock_irqsave(&instance->hba_lock, flags);
			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
			spin_unlock_irqrestore(&instance->hba_lock, flags);
			return FAILED;
		}

		reset_index	= 0;
		while (!list_empty(&clist_local)) {
			reset_cmd	= list_entry((&clist_local)->next,
						struct megasas_cmd, list);
			list_del_init(&reset_cmd->list);
			if (reset_cmd->scmd) {
				reset_cmd->scmd->result = DID_RESET << 16;
				printk(KERN_NOTICE "%d:%p reset [%02x], %#lx\n",
					reset_index, reset_cmd,
					reset_cmd->scmd->cmnd[0],
					reset_cmd->scmd->serial_number);

				reset_cmd->scmd->scsi_done(reset_cmd->scmd);
				megasas_return_cmd(instance, reset_cmd);
			} else if (reset_cmd->sync_cmd) {
				printk(KERN_NOTICE "megasas:%p synch cmds"
						"reset queue\n",
						reset_cmd);

				reset_cmd->cmd_status = ENODATA;
				instance->instancet->fire_cmd(instance,
						reset_cmd->frame_phys_addr,
						0, instance->reg_set);
			} else {
				printk(KERN_NOTICE "megasas: %p unexpected"
					"cmds lst\n",
					reset_cmd);
			}
			reset_index++;
		}

		return SUCCESS;
	}

	for (i = 0; i < wait_time; i++) {

		int outstanding = atomic_read(&instance->fw_outstanding);

		if (!outstanding)
			break;

		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
			       "commands to complete\n",i,outstanding);
			/*
			 * Call cmd completion routine. Cmd to be
			 * be completed directly without depending on isr.
			 */
			megasas_complete_cmd_dpc((unsigned long)instance);
		}

		msleep(1000);
	}

	i = 0;
	kill_adapter_flag = 0;
	do {
		fw_state = instance->instancet->read_fw_status_reg(
					instance->reg_set) & MFI_STATE_MASK;
		if ((fw_state == MFI_STATE_FAULT) &&
			(instance->disableOnlineCtrlReset == 0)) {
			if (i == 3) {
				kill_adapter_flag = 2;
				break;
			}
			megasas_do_ocr(instance);
			kill_adapter_flag = 1;

			/* wait for 1 secs to let FW finish the pending cmds */
			msleep(1000);
		}
		i++;
	} while (i <= 3);

	if (atomic_read(&instance->fw_outstanding) &&
					!kill_adapter_flag) {
		if (instance->disableOnlineCtrlReset == 0) {

			megasas_do_ocr(instance);

			/* wait for 5 secs to let FW finish the pending cmds */
			for (i = 0; i < wait_time; i++) {
				int outstanding =
					atomic_read(&instance->fw_outstanding);
				if (!outstanding)
					return SUCCESS;
				msleep(1000);
			}
		}
	}

	if (atomic_read(&instance->fw_outstanding) ||
					(kill_adapter_flag == 2)) {
		printk(KERN_NOTICE "megaraid_sas: pending cmds after reset\n");
		/*
		* Send signal to FW to stop processing any pending cmds.
		* The controller will be taken offline by the OS now.
		*/
		if ((instance->pdev->device ==
			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
			(instance->pdev->device ==
			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
			writel(MFI_STOP_ADP,
				&instance->reg_set->reserved_0[0]);
		} else {
			writel(MFI_STOP_ADP,
				&instance->reg_set->inbound_doorbell);
		}
		megasas_dump_pending_frames(instance);
		spin_lock_irqsave(&instance->hba_lock, flags);
		instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
		spin_unlock_irqrestore(&instance->hba_lock, flags);
		return FAILED;
	}

	printk(KERN_NOTICE "megaraid_sas: no pending cmds after reset\n");

	return SUCCESS;
}

/**
 * megasas_generic_reset -	Generic reset routine
 * @scmd:			Mid-layer SCSI command
 *
 * This routine implements a generic reset handler for device, bus and host
 * reset requests. Device, bus and host specific reset handlers can use this
 * function after they do their specific tasks.
 */
static int megasas_generic_reset(struct scsi_cmnd *scmd)
{
	int ret_val;
	struct megasas_instance *instance;

	instance = (struct megasas_instance *)scmd->device->host->hostdata;

	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x retries=%x\n",
		 scmd->serial_number, scmd->cmnd[0], scmd->retries);

	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
		printk(KERN_ERR "megasas: cannot recover from previous reset "
		       "failures\n");
		return FAILED;
	}

	ret_val = megasas_wait_for_outstanding(instance);
	if (ret_val == SUCCESS)
		printk(KERN_NOTICE "megasas: reset successful \n");
	else
		printk(KERN_ERR "megasas: failed to do reset\n");

	return ret_val;
}

/**
 * megasas_reset_timer - quiesce the adapter if required
 * @scmd:		scsi cmnd
 *
 * Sets the FW busy flag and reduces the host->can_queue if the
 * cmd has not been completed within the timeout period.
 */
static enum
blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
{
	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
	struct megasas_instance *instance;
	unsigned long flags;

	if (time_after(jiffies, scmd->jiffies_at_alloc +
				(MEGASAS_DEFAULT_CMD_TIMEOUT * 2) * HZ)) {
		return BLK_EH_NOT_HANDLED;
	}

	instance = cmd->instance;
	if (!(instance->flag & MEGASAS_FW_BUSY)) {
		/* FW is busy, throttle IO */
		spin_lock_irqsave(instance->host->host_lock, flags);

		instance->host->can_queue = 16;
		instance->last_time = jiffies;
		instance->flag |= MEGASAS_FW_BUSY;

		spin_unlock_irqrestore(instance->host->host_lock, flags);
	}
	return BLK_EH_RESET_TIMER;
}

/**
 * megasas_reset_device -	Device reset handler entry point
 */
static int megasas_reset_device(struct scsi_cmnd *scmd)
{
	int ret;

	/*
	 * First wait for all commands to complete
	 */
	ret = megasas_generic_reset(scmd);

	return ret;
}

/**
 * megasas_reset_bus_host -	Bus & host reset handler entry point
 */
static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
{
	int ret;

	/*
	 * First wait for all commands to complete
	 */
	ret = megasas_generic_reset(scmd);

	return ret;
}

/**
 * megasas_bios_param - Returns disk geometry for a disk
 * @sdev: 		device handle
 * @bdev:		block device
 * @capacity:		drive capacity
 * @geom:		geometry parameters
 */
static int
megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
		 sector_t capacity, int geom[])
{
	int heads;
	int sectors;
	sector_t cylinders;
	unsigned long tmp;
	/* Default heads (64) & sectors (32) */
	heads = 64;
	sectors = 32;

	tmp = heads * sectors;
	cylinders = capacity;

	sector_div(cylinders, tmp);

	/*
	 * Handle extended translation size for logical drives > 1Gb
	 */

	if (capacity >= 0x200000) {
		heads = 255;
		sectors = 63;
		tmp = heads*sectors;
		cylinders = capacity;
		sector_div(cylinders, tmp);
	}

	geom[0] = heads;
	geom[1] = sectors;
	geom[2] = cylinders;

	return 0;
}

static void megasas_aen_polling(struct work_struct *work);

/**
 * megasas_service_aen -	Processes an event notification
 * @instance:			Adapter soft state
 * @cmd:			AEN command completed by the ISR
 *
 * For AEN, driver sends a command down to FW that is held by the FW till an
 * event occurs. When an event of interest occurs, FW completes the command
 * that it was previously holding.
 *
 * This routines sends SIGIO signal to processes that have registered with the
 * driver for AEN.
 */
static void
megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
{
	unsigned long flags;
	/*
	 * Don't signal app if it is just an aborted previously registered aen
	 */
	if ((!cmd->abort_aen) && (instance->unload == 0)) {
		spin_lock_irqsave(&poll_aen_lock, flags);
		megasas_poll_wait_aen = 1;
		spin_unlock_irqrestore(&poll_aen_lock, flags);
		wake_up(&megasas_poll_wait);
		kill_fasync(&megasas_async_queue, SIGIO, POLL_IN);
	}
	else
		cmd->abort_aen = 0;

	instance->aen_cmd = NULL;
	megasas_return_cmd(instance, cmd);

	if ((instance->unload == 0) &&
		((instance->issuepend_done == 1))) {
		struct megasas_aen_event *ev;
		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
		if (!ev) {
			printk(KERN_ERR "megasas_service_aen: out of memory\n");
		} else {
			ev->instance = instance;
			instance->ev = ev;
			INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
			schedule_delayed_work(
				(struct delayed_work *)&ev->hotplug_work, 0);
		}
	}
}

/*
 * Scsi host template for megaraid_sas driver
 */
static struct scsi_host_template megasas_template = {

	.module = THIS_MODULE,
	.name = "LSI SAS based MegaRAID driver",
	.proc_name = "megaraid_sas",
	.slave_configure = megasas_slave_configure,
	.slave_alloc = megasas_slave_alloc,
	.queuecommand = megasas_queue_command,
	.eh_device_reset_handler = megasas_reset_device,
	.eh_bus_reset_handler = megasas_reset_bus_host,
	.eh_host_reset_handler = megasas_reset_bus_host,
	.eh_timed_out = megasas_reset_timer,
	.bios_param = megasas_bios_param,
	.use_clustering = ENABLE_CLUSTERING,
};

/**
 * megasas_complete_int_cmd -	Completes an internal command
 * @instance:			Adapter soft state
 * @cmd:			Command to be completed
 *
 * The megasas_issue_blocked_cmd() function waits for a command to complete
 * after it issues a command. This function wakes up that waiting routine by
 * calling wake_up() on the wait queue.
 */
static void
megasas_complete_int_cmd(struct megasas_instance *instance,
			 struct megasas_cmd *cmd)
{
	cmd->cmd_status = cmd->frame->io.cmd_status;

	if (cmd->cmd_status == ENODATA) {
		cmd->cmd_status = 0;
	}
	wake_up(&instance->int_cmd_wait_q);
}

/**
 * megasas_complete_abort -	Completes aborting a command
 * @instance:			Adapter soft state
 * @cmd:			Cmd that was issued to abort another cmd
 *
 * The megasas_issue_blocked_abort_cmd() function waits on abort_cmd_wait_q 
 * after it issues an abort on a previously issued command. This function 
 * wakes up all functions waiting on the same wait queue.
 */
static void
megasas_complete_abort(struct megasas_instance *instance,
		       struct megasas_cmd *cmd)
{
	if (cmd->sync_cmd) {
		cmd->sync_cmd = 0;
		cmd->cmd_status = 0;
		wake_up(&instance->abort_cmd_wait_q);
	}

	return;
}

/**
 * megasas_complete_cmd -	Completes a command
 * @instance:			Adapter soft state
 * @cmd:			Command to be completed
 * @alt_status:			If non-zero, use this value as status to 
 * 				SCSI mid-layer instead of the value returned
 * 				by the FW. This should be used if caller wants
 * 				an alternate status (as in the case of aborted
 * 				commands)
 */
static void
megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
		     u8 alt_status)
{
	int exception = 0;
	struct megasas_header *hdr = &cmd->frame->hdr;
	unsigned long flags;

	/* flag for the retry reset */
	cmd->retry_for_fw_reset = 0;

	if (cmd->scmd)
		cmd->scmd->SCp.ptr = NULL;

	switch (hdr->cmd) {

	case MFI_CMD_PD_SCSI_IO:
	case MFI_CMD_LD_SCSI_IO:

		/*
		 * MFI_CMD_PD_SCSI_IO and MFI_CMD_LD_SCSI_IO could have been
		 * issued either through an IO path or an IOCTL path. If it
		 * was via IOCTL, we will send it to internal completion.
		 */
		if (cmd->sync_cmd) {
			cmd->sync_cmd = 0;
			megasas_complete_int_cmd(instance, cmd);
			break;
		}

	case MFI_CMD_LD_READ:
	case MFI_CMD_LD_WRITE:

		if (alt_status) {
			cmd->scmd->result = alt_status << 16;
			exception = 1;
		}

		if (exception) {

			atomic_dec(&instance->fw_outstanding);

			scsi_dma_unmap(cmd->scmd);
			cmd->scmd->scsi_done(cmd->scmd);
			megasas_return_cmd(instance, cmd);

			break;
		}

		switch (hdr->cmd_status) {

		case MFI_STAT_OK:
			cmd->scmd->result = DID_OK << 16;
			break;

		case MFI_STAT_SCSI_IO_FAILED:
		case MFI_STAT_LD_INIT_IN_PROGRESS:
			cmd->scmd->result =
			    (DID_ERROR << 16) | hdr->scsi_status;
			break;

		case MFI_STAT_SCSI_DONE_WITH_ERROR:

			cmd->scmd->result = (DID_OK << 16) | hdr->scsi_status;

			if (hdr->scsi_status == SAM_STAT_CHECK_CONDITION) {
				memset(cmd->scmd->sense_buffer, 0,
				       SCSI_SENSE_BUFFERSIZE);
				memcpy(cmd->scmd->sense_buffer, cmd->sense,
				       hdr->sense_len);

				cmd->scmd->result |= DRIVER_SENSE << 24;
			}

			break;

		case MFI_STAT_LD_OFFLINE:
		case MFI_STAT_DEVICE_NOT_FOUND:
			cmd->scmd->result = DID_BAD_TARGET << 16;
			break;

		default:
			printk(KERN_DEBUG "megasas: MFI FW status %#x\n",
			       hdr->cmd_status);
			cmd->scmd->result = DID_ERROR << 16;
			break;
		}

		atomic_dec(&instance->fw_outstanding);

		scsi_dma_unmap(cmd->scmd);
		cmd->scmd->scsi_done(cmd->scmd);
		megasas_return_cmd(instance, cmd);

		break;

	case MFI_CMD_SMP:
	case MFI_CMD_STP:
	case MFI_CMD_DCMD:
		if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
			cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET) {
			spin_lock_irqsave(&poll_aen_lock, flags);
			megasas_poll_wait_aen = 0;
			spin_unlock_irqrestore(&poll_aen_lock, flags);
		}

		/*
		 * See if got an event notification
		 */
		if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_WAIT)
			megasas_service_aen(instance, cmd);
		else
			megasas_complete_int_cmd(instance, cmd);

		break;

	case MFI_CMD_ABORT:
		/*
		 * Cmd issued to abort another cmd returned
		 */
		megasas_complete_abort(instance, cmd);
		break;

	default:
		printk("megasas: Unknown command completed! [0x%X]\n",
		       hdr->cmd);
		break;
	}
}

/**
 * megasas_issue_pending_cmds_again -	issue all pending cmds
 *                              	in FW again because of the fw reset
 * @instance:				Adapter soft state
 */
static inline void
megasas_issue_pending_cmds_again(struct megasas_instance *instance)
{
	struct megasas_cmd *cmd;
	struct list_head clist_local;
	union megasas_evt_class_locale class_locale;
	unsigned long flags;
	u32 seq_num;

	INIT_LIST_HEAD(&clist_local);
	spin_lock_irqsave(&instance->hba_lock, flags);
	list_splice_init(&instance->internal_reset_pending_q, &clist_local);
	spin_unlock_irqrestore(&instance->hba_lock, flags);

	while (!list_empty(&clist_local)) {
		cmd	= list_entry((&clist_local)->next,
					struct megasas_cmd, list);
		list_del_init(&cmd->list);

		if (cmd->sync_cmd || cmd->scmd) {
			printk(KERN_NOTICE "megaraid_sas: command %p, %p:%d"
				"detected to be pending while HBA reset.\n",
					cmd, cmd->scmd, cmd->sync_cmd);

			cmd->retry_for_fw_reset++;

			if (cmd->retry_for_fw_reset == 3) {
				printk(KERN_NOTICE "megaraid_sas: cmd %p, %p:%d"
					"was tried multiple times during reset."
					"Shutting down the HBA\n",
					cmd, cmd->scmd, cmd->sync_cmd);
				megaraid_sas_kill_hba(instance);

				instance->adprecovery =
						MEGASAS_HW_CRITICAL_ERROR;
				return;
			}
		}

		if (cmd->sync_cmd == 1) {
			if (cmd->scmd) {
				printk(KERN_NOTICE "megaraid_sas: unexpected"
					"cmd attached to internal command!\n");
			}
			printk(KERN_NOTICE "megasas: %p synchronous cmd"
						"on the internal reset queue,"
						"issue it again.\n", cmd);
			cmd->cmd_status = ENODATA;
			instance->instancet->fire_cmd(instance,
							cmd->frame_phys_addr ,
							0, instance->reg_set);
		} else if (cmd->scmd) {
			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x],%#lx"
			"detected on the internal queue, issue again.\n",
			cmd, cmd->scmd->cmnd[0], cmd->scmd->serial_number);

			atomic_inc(&instance->fw_outstanding);
			instance->instancet->fire_cmd(instance,
					cmd->frame_phys_addr,
					cmd->frame_count-1, instance->reg_set);
		} else {
			printk(KERN_NOTICE "megasas: %p unexpected cmd on the"
				"internal reset defer list while re-issue!!\n",
				cmd);
		}
	}

	if (instance->aen_cmd) {
		printk(KERN_NOTICE "megaraid_sas: aen_cmd in def process\n");
		megasas_return_cmd(instance, instance->aen_cmd);

		instance->aen_cmd	= NULL;
	}

	/*
	* Initiate AEN (Asynchronous Event Notification)
	*/
	seq_num = instance->last_seq_num;
	class_locale.members.reserved = 0;
	class_locale.members.locale = MR_EVT_LOCALE_ALL;
	class_locale.members.class = MR_EVT_CLASS_DEBUG;

	megasas_register_aen(instance, seq_num, class_locale.word);
}

/**
 * Move the internal reset pending commands to a deferred queue.
 *
 * We move the commands pending at internal reset time to a
 * pending queue. This queue would be flushed after successful
 * completion of the internal reset sequence. if the internal reset
 * did not complete in time, the kernel reset handler would flush
 * these commands.
 **/
static void
megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
{
	struct megasas_cmd *cmd;
	int i;
	u32 max_cmd = instance->max_fw_cmds;
	u32 defer_index;
	unsigned long flags;

	defer_index     = 0;
	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
	for (i = 0; i < max_cmd; i++) {
		cmd = instance->cmd_list[i];
		if (cmd->sync_cmd == 1 || cmd->scmd) {
			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
					"on the defer queue as internal\n",
				defer_index, cmd, cmd->sync_cmd, cmd->scmd);

			if (!list_empty(&cmd->list)) {
				printk(KERN_NOTICE "megaraid_sas: ERROR while"
					" moving this cmd:%p, %d %p, it was"
					"discovered on some list?\n",
					cmd, cmd->sync_cmd, cmd->scmd);

				list_del_init(&cmd->list);
			}
			defer_index++;
			list_add_tail(&cmd->list,
				&instance->internal_reset_pending_q);
		}
	}
	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
}


static void
process_fw_state_change_wq(struct work_struct *work)
{
	struct megasas_instance *instance =
		container_of(work, struct megasas_instance, work_init);
	u32 wait;
	unsigned long flags;

	if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
		printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
				instance->adprecovery);
		return ;
	}

	if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
		printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
					"state, restarting it...\n");

		instance->instancet->disable_intr(instance->reg_set);
		atomic_set(&instance->fw_outstanding, 0);

		atomic_set(&instance->fw_reset_no_pci_access, 1);
		instance->instancet->adp_reset(instance, instance->reg_set);
		atomic_set(&instance->fw_reset_no_pci_access, 0 );

		printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
					"initiating next stage...\n");

		printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
					"state 2 starting...\n");

		/*waitting for about 20 second before start the second init*/
		for (wait = 0; wait < 30; wait++) {
			msleep(1000);
		}

		if (megasas_transition_to_ready(instance)) {
			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");

			megaraid_sas_kill_hba(instance);
			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
			return ;
		}

		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
			(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
			(instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR)
			) {
			*instance->consumer = *instance->producer;
		} else {
			*instance->consumer = 0;
			*instance->producer = 0;
		}

		megasas_issue_init_mfi(instance);

		spin_lock_irqsave(&instance->hba_lock, flags);
		instance->adprecovery	= MEGASAS_HBA_OPERATIONAL;
		spin_unlock_irqrestore(&instance->hba_lock, flags);
		instance->instancet->enable_intr(instance->reg_set);

		megasas_issue_pending_cmds_again(instance);
		instance->issuepend_done = 1;
	}
	return ;
}

/**
 * megasas_deplete_reply_queue -	Processes all completed commands
 * @instance:				Adapter soft state
 * @alt_status:				Alternate status to be returned to
 * 					SCSI mid-layer instead of the status
 * 					returned by the FW
 * Note: this must be called with hba lock held
 */
static int
megasas_deplete_reply_queue(struct megasas_instance *instance,
					u8 alt_status)
{
	u32 mfiStatus;
	u32 fw_state;

	if ((mfiStatus = instance->instancet->check_reset(instance,
					instance->reg_set)) == 1) {
		return IRQ_HANDLED;
	}

	if ((mfiStatus = instance->instancet->clear_intr(
						instance->reg_set)
						) == 0) {
		return IRQ_NONE;
	}

	instance->mfiStatus = mfiStatus;

	if ((mfiStatus & MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE)) {
		fw_state = instance->instancet->read_fw_status_reg(
				instance->reg_set) & MFI_STATE_MASK;

		if (fw_state != MFI_STATE_FAULT) {
			printk(KERN_NOTICE "megaraid_sas: fw state:%x\n",
						fw_state);
		}

		if ((fw_state == MFI_STATE_FAULT) &&
				(instance->disableOnlineCtrlReset == 0)) {
			printk(KERN_NOTICE "megaraid_sas: wait adp restart\n");

			if ((instance->pdev->device ==
					PCI_DEVICE_ID_LSI_SAS1064R) ||
				(instance->pdev->device ==
					PCI_DEVICE_ID_DELL_PERC5) ||
				(instance->pdev->device ==
					PCI_DEVICE_ID_LSI_VERDE_ZCR)) {

				*instance->consumer =
					MEGASAS_ADPRESET_INPROG_SIGN;
			}


			instance->instancet->disable_intr(instance->reg_set);
			instance->adprecovery	= MEGASAS_ADPRESET_SM_INFAULT;
			instance->issuepend_done = 0;

			atomic_set(&instance->fw_outstanding, 0);
			megasas_internal_reset_defer_cmds(instance);

			printk(KERN_NOTICE "megasas: fwState=%x, stage:%d\n",
					fw_state, instance->adprecovery);

			schedule_work(&instance->work_init);
			return IRQ_HANDLED;

		} else {
			printk(KERN_NOTICE "megasas: fwstate:%x, dis_OCR=%x\n",
				fw_state, instance->disableOnlineCtrlReset);
		}
	}

	tasklet_schedule(&instance->isr_tasklet);
	return IRQ_HANDLED;
}
/**
 * megasas_isr - isr entry point
 */
static irqreturn_t megasas_isr(int irq, void *devp)
{
	struct megasas_instance *instance;
	unsigned long flags;
	irqreturn_t	rc;

	if (atomic_read(
		&(((struct megasas_instance *)devp)->fw_reset_no_pci_access)))
		return IRQ_HANDLED;

	instance = (struct megasas_instance *)devp;

	spin_lock_irqsave(&instance->hba_lock, flags);
	rc =  megasas_deplete_reply_queue(instance, DID_OK);
	spin_unlock_irqrestore(&instance->hba_lock, flags);

	return rc;
}

/**
 * megasas_transition_to_ready -	Move the FW to READY state
 * @instance:				Adapter soft state
 *
 * During the initialization, FW passes can potentially be in any one of
 * several possible states. If the FW in operational, waiting-for-handshake
 * states, driver must take steps to bring it to ready state. Otherwise, it
 * has to wait for the ready state.
 */
static int
megasas_transition_to_ready(struct megasas_instance* instance)
{
	int i;
	u8 max_wait;
	u32 fw_state;
	u32 cur_state;
	u32 abs_state, curr_abs_state;

	fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;

	if (fw_state != MFI_STATE_READY)
 		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
 		       " state\n");

	while (fw_state != MFI_STATE_READY) {

		abs_state =
		instance->instancet->read_fw_status_reg(instance->reg_set);

		switch (fw_state) {

		case MFI_STATE_FAULT:

			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
			return -ENODEV;

		case MFI_STATE_WAIT_HANDSHAKE:
			/*
			 * Set the CLR bit in inbound doorbell
			 */
			if ((instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
				(instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {

				writel(
				  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
				  &instance->reg_set->reserved_0[0]);
			} else {
				writel(
				    MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
					&instance->reg_set->inbound_doorbell);
			}

			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_WAIT_HANDSHAKE;
			break;

		case MFI_STATE_BOOT_MESSAGE_PENDING:
			if ((instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
			(instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
				writel(MFI_INIT_HOTPLUG,
				&instance->reg_set->reserved_0[0]);
			} else
				writel(MFI_INIT_HOTPLUG,
					&instance->reg_set->inbound_doorbell);

			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
			break;

		case MFI_STATE_OPERATIONAL:
			/*
			 * Bring it to READY state; assuming max wait 10 secs
			 */
			instance->instancet->disable_intr(instance->reg_set);
			if ((instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
				(instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
				writel(MFI_RESET_FLAGS,
					&instance->reg_set->reserved_0[0]);
			} else
				writel(MFI_RESET_FLAGS,
					&instance->reg_set->inbound_doorbell);

			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_OPERATIONAL;
			break;

		case MFI_STATE_UNDEFINED:
			/*
			 * This state should not last for more than 2 seconds
			 */
			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_UNDEFINED;
			break;

		case MFI_STATE_BB_INIT:
			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_BB_INIT;
			break;

		case MFI_STATE_FW_INIT:
			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_FW_INIT;
			break;

		case MFI_STATE_FW_INIT_2:
			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_FW_INIT_2;
			break;

		case MFI_STATE_DEVICE_SCAN:
			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_DEVICE_SCAN;
			break;

		case MFI_STATE_FLUSH_CACHE:
			max_wait = MEGASAS_RESET_WAIT_TIME;
			cur_state = MFI_STATE_FLUSH_CACHE;
			break;

		default:
			printk(KERN_DEBUG "megasas: Unknown state 0x%x\n",
			       fw_state);
			return -ENODEV;
		}

		/*
		 * The cur_state should not last for more than max_wait secs
		 */
		for (i = 0; i < (max_wait * 1000); i++) {
			fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) &  
					MFI_STATE_MASK ;
		curr_abs_state =
		instance->instancet->read_fw_status_reg(instance->reg_set);

			if (abs_state == curr_abs_state) {
				msleep(1);
			} else
				break;
		}

		/*
		 * Return error if fw_state hasn't changed after max_wait
		 */
		if (curr_abs_state == abs_state) {
			printk(KERN_DEBUG "FW state [%d] hasn't changed "
			       "in %d secs\n", fw_state, max_wait);
			return -ENODEV;
		}
	}
 	printk(KERN_INFO "megasas: FW now in Ready state\n");

	return 0;
}

/**
 * megasas_teardown_frame_pool -	Destroy the cmd frame DMA pool
 * @instance:				Adapter soft state
 */
static void megasas_teardown_frame_pool(struct megasas_instance *instance)
{
	int i;
	u32 max_cmd = instance->max_fw_cmds;
	struct megasas_cmd *cmd;

	if (!instance->frame_dma_pool)
		return;

	/*
	 * Return all frames to pool
	 */
	for (i = 0; i < max_cmd; i++) {

		cmd = instance->cmd_list[i];

		if (cmd->frame)
			pci_pool_free(instance->frame_dma_pool, cmd->frame,
				      cmd->frame_phys_addr);

		if (cmd->sense)
			pci_pool_free(instance->sense_dma_pool, cmd->sense,
				      cmd->sense_phys_addr);
	}

	/*
	 * Now destroy the pool itself
	 */
	pci_pool_destroy(instance->frame_dma_pool);
	pci_pool_destroy(instance->sense_dma_pool);

	instance->frame_dma_pool = NULL;
	instance->sense_dma_pool = NULL;
}

/**
 * megasas_create_frame_pool -	Creates DMA pool for cmd frames
 * @instance:			Adapter soft state
 *
 * Each command packet has an embedded DMA memory buffer that is used for
 * filling MFI frame and the SG list that immediately follows the frame. This
 * function creates those DMA memory buffers for each command packet by using
 * PCI pool facility.
 */
static int megasas_create_frame_pool(struct megasas_instance *instance)
{
	int i;
	u32 max_cmd;
	u32 sge_sz;
	u32 sgl_sz;
	u32 total_sz;
	u32 frame_count;
	struct megasas_cmd *cmd;

	max_cmd = instance->max_fw_cmds;

	/*
	 * Size of our frame is 64 bytes for MFI frame, followed by max SG
	 * elements and finally SCSI_SENSE_BUFFERSIZE bytes for sense buffer
	 */
	sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
	    sizeof(struct megasas_sge32);

	if (instance->flag_ieee) {
		sge_sz = sizeof(struct megasas_sge_skinny);
	}

	/*
	 * Calculated the number of 64byte frames required for SGL
	 */
	sgl_sz = sge_sz * instance->max_num_sge;
	frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
	frame_count = 15;

	/*
	 * We need one extra frame for the MFI command
	 */
	frame_count++;

	total_sz = MEGAMFI_FRAME_SIZE * frame_count;
	/*
	 * Use DMA pool facility provided by PCI layer
	 */
	instance->frame_dma_pool = pci_pool_create("megasas frame pool",
						   instance->pdev, total_sz, 64,
						   0);

	if (!instance->frame_dma_pool) {
		printk(KERN_DEBUG "megasas: failed to setup frame pool\n");
		return -ENOMEM;
	}

	instance->sense_dma_pool = pci_pool_create("megasas sense pool",
						   instance->pdev, 128, 4, 0);

	if (!instance->sense_dma_pool) {
		printk(KERN_DEBUG "megasas: failed to setup sense pool\n");

		pci_pool_destroy(instance->frame_dma_pool);
		instance->frame_dma_pool = NULL;

		return -ENOMEM;
	}

	/*
	 * Allocate and attach a frame to each of the commands in cmd_list.
	 * By making cmd->index as the context instead of the &cmd, we can
	 * always use 32bit context regardless of the architecture
	 */
	for (i = 0; i < max_cmd; i++) {

		cmd = instance->cmd_list[i];

		cmd->frame = pci_pool_alloc(instance->frame_dma_pool,
					    GFP_KERNEL, &cmd->frame_phys_addr);

		cmd->sense = pci_pool_alloc(instance->sense_dma_pool,
					    GFP_KERNEL, &cmd->sense_phys_addr);

		/*
		 * megasas_teardown_frame_pool() takes care of freeing
		 * whatever has been allocated
		 */
		if (!cmd->frame || !cmd->sense) {
			printk(KERN_DEBUG "megasas: pci_pool_alloc failed \n");
			megasas_teardown_frame_pool(instance);
			return -ENOMEM;
		}

		memset(cmd->frame, 0, total_sz);
		cmd->frame->io.context = cmd->index;
		cmd->frame->io.pad_0 = 0;
	}

	return 0;
}

/**
 * megasas_free_cmds -	Free all the cmds in the free cmd pool
 * @instance:		Adapter soft state
 */
static void megasas_free_cmds(struct megasas_instance *instance)
{
	int i;
	/* First free the MFI frame pool */
	megasas_teardown_frame_pool(instance);

	/* Free all the commands in the cmd_list */
	for (i = 0; i < instance->max_fw_cmds; i++)
		kfree(instance->cmd_list[i]);

	/* Free the cmd_list buffer itself */
	kfree(instance->cmd_list);
	instance->cmd_list = NULL;

	INIT_LIST_HEAD(&instance->cmd_pool);
}

/**
 * megasas_alloc_cmds -	Allocates the command packets
 * @instance:		Adapter soft state
 *
 * Each command that is issued to the FW, whether IO commands from the OS or
 * internal commands like IOCTLs, are wrapped in local data structure called
 * megasas_cmd. The frame embedded in this megasas_cmd is actually issued to
 * the FW.
 *
 * Each frame has a 32-bit field called context (tag). This context is used
 * to get back the megasas_cmd from the frame when a frame gets completed in
 * the ISR. Typically the address of the megasas_cmd itself would be used as
 * the context. But we wanted to keep the differences between 32 and 64 bit
 * systems to the mininum. We always use 32 bit integers for the context. In
 * this driver, the 32 bit values are the indices into an array cmd_list.
 * This array is used only to look up the megasas_cmd given the context. The
 * free commands themselves are maintained in a linked list called cmd_pool.
 */
static int megasas_alloc_cmds(struct megasas_instance *instance)
{
	int i;
	int j;
	u32 max_cmd;
	struct megasas_cmd *cmd;

	max_cmd = instance->max_fw_cmds;

	/*
	 * instance->cmd_list is an array of struct megasas_cmd pointers.
	 * Allocate the dynamic array first and then allocate individual
	 * commands.
	 */
	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);

	if (!instance->cmd_list) {
		printk(KERN_DEBUG "megasas: out of memory\n");
		return -ENOMEM;
	}


	for (i = 0; i < max_cmd; i++) {
		instance->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd),
						GFP_KERNEL);

		if (!instance->cmd_list[i]) {

			for (j = 0; j < i; j++)
				kfree(instance->cmd_list[j]);

			kfree(instance->cmd_list);
			instance->cmd_list = NULL;

			return -ENOMEM;
		}
	}

	/*
	 * Add all the commands to command pool (instance->cmd_pool)
	 */
	for (i = 0; i < max_cmd; i++) {
		cmd = instance->cmd_list[i];
		memset(cmd, 0, sizeof(struct megasas_cmd));
		cmd->index = i;
		cmd->scmd = NULL;
		cmd->instance = instance;

		list_add_tail(&cmd->list, &instance->cmd_pool);
	}

	/*
	 * Create a frame pool and assign one frame to each cmd
	 */
	if (megasas_create_frame_pool(instance)) {
		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
		megasas_free_cmds(instance);
	}

	return 0;
}

/*
 * megasas_get_pd_list_info -	Returns FW's pd_list structure
 * @instance:				Adapter soft state
 * @pd_list:				pd_list structure
 *
 * Issues an internal command (DCMD) to get the FW's controller PD
 * list structure.  This information is mainly used to find out SYSTEM
 * supported by the FW.
 */
static int
megasas_get_pd_list(struct megasas_instance *instance)
{
	int ret = 0, pd_index = 0;
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;
	struct MR_PD_LIST *ci;
	struct MR_PD_ADDRESS *pd_addr;
	dma_addr_t ci_h = 0;

	cmd = megasas_get_cmd(instance);

	if (!cmd) {
		printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
		return -ENOMEM;
	}

	dcmd = &cmd->frame->dcmd;

	ci = pci_alloc_consistent(instance->pdev,
		  MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST), &ci_h);

	if (!ci) {
		printk(KERN_DEBUG "Failed to alloc mem for pd_list\n");
		megasas_return_cmd(instance, cmd);
		return -ENOMEM;
	}

	memset(ci, 0, sizeof(*ci));
	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->mbox.b[0] = MR_PD_QUERY_TYPE_EXPOSED_TO_HOST;
	dcmd->mbox.b[1] = 0;
	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0xFF;
	dcmd->sge_count = 1;
	dcmd->flags = MFI_FRAME_DIR_READ;
	dcmd->timeout = 0;
	dcmd->pad_0 = 0;
	dcmd->data_xfer_len = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);
	dcmd->opcode = MR_DCMD_PD_LIST_QUERY;
	dcmd->sgl.sge32[0].phys_addr = ci_h;
	dcmd->sgl.sge32[0].length = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);

	if (!megasas_issue_polled(instance, cmd)) {
		ret = 0;
	} else {
		ret = -1;
	}

	/*
	* the following function will get the instance PD LIST.
	*/

	pd_addr = ci->addr;

	if ( ret == 0 &&
		(ci->count <
		  (MEGASAS_MAX_PD_CHANNELS * MEGASAS_MAX_DEV_PER_CHANNEL))) {

		memset(instance->pd_list, 0,
			MEGASAS_MAX_PD * sizeof(struct megasas_pd_list));

		for (pd_index = 0; pd_index < ci->count; pd_index++) {

			instance->pd_list[pd_addr->deviceId].tid	=
							pd_addr->deviceId;
			instance->pd_list[pd_addr->deviceId].driveType	=
							pd_addr->scsiDevType;
			instance->pd_list[pd_addr->deviceId].driveState	=
							MR_PD_STATE_SYSTEM;
			pd_addr++;
		}
	}

	pci_free_consistent(instance->pdev,
				MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST),
				ci, ci_h);
	megasas_return_cmd(instance, cmd);

	return ret;
}

/*
 * megasas_get_ld_list_info -	Returns FW's ld_list structure
 * @instance:				Adapter soft state
 * @ld_list:				ld_list structure
 *
 * Issues an internal command (DCMD) to get the FW's controller PD
 * list structure.  This information is mainly used to find out SYSTEM
 * supported by the FW.
 */
static int
megasas_get_ld_list(struct megasas_instance *instance)
{
	int ret = 0, ld_index = 0, ids = 0;
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;
	struct MR_LD_LIST *ci;
	dma_addr_t ci_h = 0;

	cmd = megasas_get_cmd(instance);

	if (!cmd) {
		printk(KERN_DEBUG "megasas_get_ld_list: Failed to get cmd\n");
		return -ENOMEM;
	}

	dcmd = &cmd->frame->dcmd;

	ci = pci_alloc_consistent(instance->pdev,
				sizeof(struct MR_LD_LIST),
				&ci_h);

	if (!ci) {
		printk(KERN_DEBUG "Failed to alloc mem in get_ld_list\n");
		megasas_return_cmd(instance, cmd);
		return -ENOMEM;
	}

	memset(ci, 0, sizeof(*ci));
	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0xFF;
	dcmd->sge_count = 1;
	dcmd->flags = MFI_FRAME_DIR_READ;
	dcmd->timeout = 0;
	dcmd->data_xfer_len = sizeof(struct MR_LD_LIST);
	dcmd->opcode = MR_DCMD_LD_GET_LIST;
	dcmd->sgl.sge32[0].phys_addr = ci_h;
	dcmd->sgl.sge32[0].length = sizeof(struct MR_LD_LIST);
	dcmd->pad_0  = 0;

	if (!megasas_issue_polled(instance, cmd)) {
		ret = 0;
	} else {
		ret = -1;
	}

	/* the following function will get the instance PD LIST */

	if ((ret == 0) && (ci->ldCount <= MAX_LOGICAL_DRIVES)) {
		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);

		for (ld_index = 0; ld_index < ci->ldCount; ld_index++) {
			if (ci->ldList[ld_index].state != 0) {
				ids = ci->ldList[ld_index].ref.targetId;
				instance->ld_ids[ids] =
					ci->ldList[ld_index].ref.targetId;
			}
		}
	}

	pci_free_consistent(instance->pdev,
				sizeof(struct MR_LD_LIST),
				ci,
				ci_h);

	megasas_return_cmd(instance, cmd);
	return ret;
}

/**
 * megasas_get_controller_info -	Returns FW's controller structure
 * @instance:				Adapter soft state
 * @ctrl_info:				Controller information structure
 *
 * Issues an internal command (DCMD) to get the FW's controller structure.
 * This information is mainly used to find out the maximum IO transfer per
 * command supported by the FW.
 */
static int
megasas_get_ctrl_info(struct megasas_instance *instance,
		      struct megasas_ctrl_info *ctrl_info)
{
	int ret = 0;
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;
	struct megasas_ctrl_info *ci;
	dma_addr_t ci_h = 0;

	cmd = megasas_get_cmd(instance);

	if (!cmd) {
		printk(KERN_DEBUG "megasas: Failed to get a free cmd\n");
		return -ENOMEM;
	}

	dcmd = &cmd->frame->dcmd;

	ci = pci_alloc_consistent(instance->pdev,
				  sizeof(struct megasas_ctrl_info), &ci_h);

	if (!ci) {
		printk(KERN_DEBUG "Failed to alloc mem for ctrl info\n");
		megasas_return_cmd(instance, cmd);
		return -ENOMEM;
	}

	memset(ci, 0, sizeof(*ci));
	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0xFF;
	dcmd->sge_count = 1;
	dcmd->flags = MFI_FRAME_DIR_READ;
	dcmd->timeout = 0;
	dcmd->pad_0 = 0;
	dcmd->data_xfer_len = sizeof(struct megasas_ctrl_info);
	dcmd->opcode = MR_DCMD_CTRL_GET_INFO;
	dcmd->sgl.sge32[0].phys_addr = ci_h;
	dcmd->sgl.sge32[0].length = sizeof(struct megasas_ctrl_info);

	if (!megasas_issue_polled(instance, cmd)) {
		ret = 0;
		memcpy(ctrl_info, ci, sizeof(struct megasas_ctrl_info));
	} else {
		ret = -1;
	}

	pci_free_consistent(instance->pdev, sizeof(struct megasas_ctrl_info),
			    ci, ci_h);

	megasas_return_cmd(instance, cmd);
	return ret;
}

/**
 * megasas_issue_init_mfi -	Initializes the FW
 * @instance:		Adapter soft state
 *
 * Issues the INIT MFI cmd
 */
static int
megasas_issue_init_mfi(struct megasas_instance *instance)
{
	u32 context;

	struct megasas_cmd *cmd;

	struct megasas_init_frame *init_frame;
	struct megasas_init_queue_info *initq_info;
	dma_addr_t init_frame_h;
	dma_addr_t initq_info_h;

	/*
	 * Prepare a init frame. Note the init frame points to queue info
	 * structure. Each frame has SGL allocated after first 64 bytes. For
	 * this frame - since we don't need any SGL - we use SGL's space as
	 * queue info structure
	 *
	 * We will not get a NULL command below. We just created the pool.
	 */
	cmd = megasas_get_cmd(instance);

	init_frame = (struct megasas_init_frame *)cmd->frame;
	initq_info = (struct megasas_init_queue_info *)
		((unsigned long)init_frame + 64);

	init_frame_h = cmd->frame_phys_addr;
	initq_info_h = init_frame_h + 64;

	context = init_frame->context;
	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
	memset(initq_info, 0, sizeof(struct megasas_init_queue_info));
	init_frame->context = context;

	initq_info->reply_queue_entries = instance->max_fw_cmds + 1;
	initq_info->reply_queue_start_phys_addr_lo = instance->reply_queue_h;

	initq_info->producer_index_phys_addr_lo = instance->producer_h;
	initq_info->consumer_index_phys_addr_lo = instance->consumer_h;

	init_frame->cmd = MFI_CMD_INIT;
	init_frame->cmd_status = 0xFF;
	init_frame->queue_info_new_phys_addr_lo = initq_info_h;

	init_frame->data_xfer_len = sizeof(struct megasas_init_queue_info);

	/*
	 * disable the intr before firing the init frame to FW
	 */
	instance->instancet->disable_intr(instance->reg_set);

	/*
	 * Issue the init frame in polled mode
	 */

	if (megasas_issue_polled(instance, cmd)) {
		printk(KERN_ERR "megasas: Failed to init firmware\n");
		megasas_return_cmd(instance, cmd);
		goto fail_fw_init;
	}

	megasas_return_cmd(instance, cmd);

	return 0;

fail_fw_init:
	return -EINVAL;
}

/**
 * megasas_start_timer - Initializes a timer object
 * @instance:		Adapter soft state
 * @timer:		timer object to be initialized
 * @fn:			timer function
 * @interval:		time interval between timer function call
 */
static inline void
megasas_start_timer(struct megasas_instance *instance,
			struct timer_list *timer,
			void *fn, unsigned long interval)
{
	init_timer(timer);
	timer->expires = jiffies + interval;
	timer->data = (unsigned long)instance;
	timer->function = fn;
	add_timer(timer);
}

/**
 * megasas_io_completion_timer - Timer fn
 * @instance_addr:	Address of adapter soft state
 *
 * Schedules tasklet for cmd completion
 * if poll_mode_io is set
 */
static void
megasas_io_completion_timer(unsigned long instance_addr)
{
	struct megasas_instance *instance =
			(struct megasas_instance *)instance_addr;

	if (atomic_read(&instance->fw_outstanding))
		tasklet_schedule(&instance->isr_tasklet);

	/* Restart timer */
	if (poll_mode_io)
		mod_timer(&instance->io_completion_timer,
			jiffies + MEGASAS_COMPLETION_TIMER_INTERVAL);
}

/**
 * megasas_init_mfi -	Initializes the FW
 * @instance:		Adapter soft state
 *
 * This is the main function for initializing MFI firmware.
 */
static int megasas_init_mfi(struct megasas_instance *instance)
{
	u32 context_sz;
	u32 reply_q_sz;
	u32 max_sectors_1;
	u32 max_sectors_2;
	u32 tmp_sectors;
	struct megasas_register_set __iomem *reg_set;
	struct megasas_ctrl_info *ctrl_info;
	/*
	 * Map the message registers
	 */
	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0079GEN2)) {
		instance->base_addr = pci_resource_start(instance->pdev, 1);
	} else {
		instance->base_addr = pci_resource_start(instance->pdev, 0);
	}

	if (pci_request_selected_regions(instance->pdev,
		pci_select_bars(instance->pdev, IORESOURCE_MEM),
		"megasas: LSI")) {
		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
		return -EBUSY;
	}

	instance->reg_set = ioremap_nocache(instance->base_addr, 8192);

	if (!instance->reg_set) {
		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
		goto fail_ioremap;
	}

	reg_set = instance->reg_set;

	switch(instance->pdev->device)
	{
		case PCI_DEVICE_ID_LSI_SAS1078R:
		case PCI_DEVICE_ID_LSI_SAS1078DE:
			instance->instancet = &megasas_instance_template_ppc;
			break;
		case PCI_DEVICE_ID_LSI_SAS1078GEN2:
		case PCI_DEVICE_ID_LSI_SAS0079GEN2:
			instance->instancet = &megasas_instance_template_gen2;
			break;
		case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
		case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
			instance->instancet = &megasas_instance_template_skinny;
			break;
		case PCI_DEVICE_ID_LSI_SAS1064R:
		case PCI_DEVICE_ID_DELL_PERC5:
		default:
			instance->instancet = &megasas_instance_template_xscale;
			break;
	}

	/*
	 * We expect the FW state to be READY
	 */
	if (megasas_transition_to_ready(instance))
		goto fail_ready_state;

	/*
	 * Get various operational parameters from status register
	 */
	instance->max_fw_cmds = instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
	/*
	 * Reduce the max supported cmds by 1. This is to ensure that the
	 * reply_q_sz (1 more than the max cmd that driver may send)
	 * does not exceed max cmds that the FW can support
	 */
	instance->max_fw_cmds = instance->max_fw_cmds-1;
	instance->max_num_sge = (instance->instancet->read_fw_status_reg(reg_set) & 0xFF0000) >> 
					0x10;
	/*
	 * Create a pool of commands
	 */
	if (megasas_alloc_cmds(instance))
		goto fail_alloc_cmds;

	/*
	 * Allocate memory for reply queue. Length of reply queue should
	 * be _one_ more than the maximum commands handled by the firmware.
	 *
	 * Note: When FW completes commands, it places corresponding contex
	 * values in this circular reply queue. This circular queue is a fairly
	 * typical producer-consumer queue. FW is the producer (of completed
	 * commands) and the driver is the consumer.
	 */
	context_sz = sizeof(u32);
	reply_q_sz = context_sz * (instance->max_fw_cmds + 1);

	instance->reply_queue = pci_alloc_consistent(instance->pdev,
						     reply_q_sz,
						     &instance->reply_queue_h);

	if (!instance->reply_queue) {
		printk(KERN_DEBUG "megasas: Out of DMA mem for reply queue\n");
		goto fail_reply_queue;
	}

	if (megasas_issue_init_mfi(instance))
		goto fail_fw_init;

	instance->fw_support_ieee = 0;
	instance->fw_support_ieee =
		(instance->instancet->read_fw_status_reg(reg_set) &
		0x04000000);

	printk(KERN_NOTICE "megasas_init_mfi: fw_support_ieee=%d",
			instance->fw_support_ieee);

	if (instance->fw_support_ieee)
		instance->flag_ieee = 1;

	/** for passthrough
	* the following function will get the PD LIST.
	*/

	memset(instance->pd_list, 0 ,
		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
	megasas_get_pd_list(instance);

	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
	megasas_get_ld_list(instance);

	ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);

	/*
	 * Compute the max allowed sectors per IO: The controller info has two
	 * limits on max sectors. Driver should use the minimum of these two.
	 *
	 * 1 << stripe_sz_ops.min = max sectors per strip
	 *
	 * Note that older firmwares ( < FW ver 30) didn't report information
	 * to calculate max_sectors_1. So the number ended up as zero always.
	 */
	tmp_sectors = 0;
	if (ctrl_info && !megasas_get_ctrl_info(instance, ctrl_info)) {

		max_sectors_1 = (1 << ctrl_info->stripe_sz_ops.min) *
		    ctrl_info->max_strips_per_io;
		max_sectors_2 = ctrl_info->max_request_size;

		tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
		instance->disableOnlineCtrlReset =
		ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
	}

	instance->max_sectors_per_req = instance->max_num_sge *
						PAGE_SIZE / 512;
	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
		instance->max_sectors_per_req = tmp_sectors;

	kfree(ctrl_info);

        /*
	* Setup tasklet for cmd completion
	*/

	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
		(unsigned long)instance);

	/* Initialize the cmd completion timer */
	if (poll_mode_io)
		megasas_start_timer(instance, &instance->io_completion_timer,
				megasas_io_completion_timer,
				MEGASAS_COMPLETION_TIMER_INTERVAL);
	return 0;

      fail_fw_init:

	pci_free_consistent(instance->pdev, reply_q_sz,
			    instance->reply_queue, instance->reply_queue_h);
      fail_reply_queue:
	megasas_free_cmds(instance);

      fail_alloc_cmds:
      fail_ready_state:
	iounmap(instance->reg_set);

      fail_ioremap:
	pci_release_selected_regions(instance->pdev,
		pci_select_bars(instance->pdev, IORESOURCE_MEM));

	return -EINVAL;
}

/**
 * megasas_release_mfi -	Reverses the FW initialization
 * @intance:			Adapter soft state
 */
static void megasas_release_mfi(struct megasas_instance *instance)
{
	u32 reply_q_sz = sizeof(u32) * (instance->max_fw_cmds + 1);

	pci_free_consistent(instance->pdev, reply_q_sz,
			    instance->reply_queue, instance->reply_queue_h);

	megasas_free_cmds(instance);

	iounmap(instance->reg_set);

	pci_release_selected_regions(instance->pdev,
		pci_select_bars(instance->pdev, IORESOURCE_MEM));
}

/**
 * megasas_get_seq_num -	Gets latest event sequence numbers
 * @instance:			Adapter soft state
 * @eli:			FW event log sequence numbers information
 *
 * FW maintains a log of all events in a non-volatile area. Upper layers would
 * usually find out the latest sequence number of the events, the seq number at
 * the boot etc. They would "read" all the events below the latest seq number
 * by issuing a direct fw cmd (DCMD). For the future events (beyond latest seq
 * number), they would subsribe to AEN (asynchronous event notification) and
 * wait for the events to happen.
 */
static int
megasas_get_seq_num(struct megasas_instance *instance,
		    struct megasas_evt_log_info *eli)
{
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;
	struct megasas_evt_log_info *el_info;
	dma_addr_t el_info_h = 0;

	cmd = megasas_get_cmd(instance);

	if (!cmd) {
		return -ENOMEM;
	}

	dcmd = &cmd->frame->dcmd;
	el_info = pci_alloc_consistent(instance->pdev,
				       sizeof(struct megasas_evt_log_info),
				       &el_info_h);

	if (!el_info) {
		megasas_return_cmd(instance, cmd);
		return -ENOMEM;
	}

	memset(el_info, 0, sizeof(*el_info));
	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0x0;
	dcmd->sge_count = 1;
	dcmd->flags = MFI_FRAME_DIR_READ;
	dcmd->timeout = 0;
	dcmd->pad_0 = 0;
	dcmd->data_xfer_len = sizeof(struct megasas_evt_log_info);
	dcmd->opcode = MR_DCMD_CTRL_EVENT_GET_INFO;
	dcmd->sgl.sge32[0].phys_addr = el_info_h;
	dcmd->sgl.sge32[0].length = sizeof(struct megasas_evt_log_info);

	megasas_issue_blocked_cmd(instance, cmd);

	/*
	 * Copy the data back into callers buffer
	 */
	memcpy(eli, el_info, sizeof(struct megasas_evt_log_info));

	pci_free_consistent(instance->pdev, sizeof(struct megasas_evt_log_info),
			    el_info, el_info_h);

	megasas_return_cmd(instance, cmd);

	return 0;
}

/**
 * megasas_register_aen -	Registers for asynchronous event notification
 * @instance:			Adapter soft state
 * @seq_num:			The starting sequence number
 * @class_locale:		Class of the event
 *
 * This function subscribes for AEN for events beyond the @seq_num. It requests
 * to be notified if and only if the event is of type @class_locale
 */
static int
megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
		     u32 class_locale_word)
{
	int ret_val;
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;
	union megasas_evt_class_locale curr_aen;
	union megasas_evt_class_locale prev_aen;

	/*
	 * If there an AEN pending already (aen_cmd), check if the
	 * class_locale of that pending AEN is inclusive of the new
	 * AEN request we currently have. If it is, then we don't have
	 * to do anything. In other words, whichever events the current
	 * AEN request is subscribing to, have already been subscribed
	 * to.
	 *
	 * If the old_cmd is _not_ inclusive, then we have to abort
	 * that command, form a class_locale that is superset of both
	 * old and current and re-issue to the FW
	 */

	curr_aen.word = class_locale_word;

	if (instance->aen_cmd) {

		prev_aen.word = instance->aen_cmd->frame->dcmd.mbox.w[1];

		/*
		 * A class whose enum value is smaller is inclusive of all
		 * higher values. If a PROGRESS (= -1) was previously
		 * registered, then a new registration requests for higher
		 * classes need not be sent to FW. They are automatically
		 * included.
		 *
		 * Locale numbers don't have such hierarchy. They are bitmap
		 * values
		 */
		if ((prev_aen.members.class <= curr_aen.members.class) &&
		    !((prev_aen.members.locale & curr_aen.members.locale) ^
		      curr_aen.members.locale)) {
			/*
			 * Previously issued event registration includes
			 * current request. Nothing to do.
			 */
			return 0;
		} else {
			curr_aen.members.locale |= prev_aen.members.locale;

			if (prev_aen.members.class < curr_aen.members.class)
				curr_aen.members.class = prev_aen.members.class;

			instance->aen_cmd->abort_aen = 1;
			ret_val = megasas_issue_blocked_abort_cmd(instance,
								  instance->
								  aen_cmd);

			if (ret_val) {
				printk(KERN_DEBUG "megasas: Failed to abort "
				       "previous AEN command\n");
				return ret_val;
			}
		}
	}

	cmd = megasas_get_cmd(instance);

	if (!cmd)
		return -ENOMEM;

	dcmd = &cmd->frame->dcmd;

	memset(instance->evt_detail, 0, sizeof(struct megasas_evt_detail));

	/*
	 * Prepare DCMD for aen registration
	 */
	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0x0;
	dcmd->sge_count = 1;
	dcmd->flags = MFI_FRAME_DIR_READ;
	dcmd->timeout = 0;
	dcmd->pad_0 = 0;
	instance->last_seq_num = seq_num;
	dcmd->data_xfer_len = sizeof(struct megasas_evt_detail);
	dcmd->opcode = MR_DCMD_CTRL_EVENT_WAIT;
	dcmd->mbox.w[0] = seq_num;
	dcmd->mbox.w[1] = curr_aen.word;
	dcmd->sgl.sge32[0].phys_addr = (u32) instance->evt_detail_h;
	dcmd->sgl.sge32[0].length = sizeof(struct megasas_evt_detail);

	if (instance->aen_cmd != NULL) {
		megasas_return_cmd(instance, cmd);
		return 0;
	}

	/*
	 * Store reference to the cmd used to register for AEN. When an
	 * application wants us to register for AEN, we have to abort this
	 * cmd and re-register with a new EVENT LOCALE supplied by that app
	 */
	instance->aen_cmd = cmd;

	/*
	 * Issue the aen registration frame
	 */
	instance->instancet->fire_cmd(instance,
			cmd->frame_phys_addr, 0, instance->reg_set);

	return 0;
}

/**
 * megasas_start_aen -	Subscribes to AEN during driver load time
 * @instance:		Adapter soft state
 */
static int megasas_start_aen(struct megasas_instance *instance)
{
	struct megasas_evt_log_info eli;
	union megasas_evt_class_locale class_locale;

	/*
	 * Get the latest sequence number from FW
	 */
	memset(&eli, 0, sizeof(eli));

	if (megasas_get_seq_num(instance, &eli))
		return -1;

	/*
	 * Register AEN with FW for latest sequence number plus 1
	 */
	class_locale.members.reserved = 0;
	class_locale.members.locale = MR_EVT_LOCALE_ALL;
	class_locale.members.class = MR_EVT_CLASS_DEBUG;

	return megasas_register_aen(instance, eli.newest_seq_num + 1,
				    class_locale.word);
}

/**
 * megasas_io_attach -	Attaches this driver to SCSI mid-layer
 * @instance:		Adapter soft state
 */
static int megasas_io_attach(struct megasas_instance *instance)
{
	struct Scsi_Host *host = instance->host;

	/*
	 * Export parameters required by SCSI mid-layer
	 */
	host->irq = instance->pdev->irq;
	host->unique_id = instance->unique_id;
	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
		host->can_queue =
			instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
	} else
		host->can_queue =
			instance->max_fw_cmds - MEGASAS_INT_CMDS;
	host->this_id = instance->init_id;
	host->sg_tablesize = instance->max_num_sge;
	/*
	 * Check if the module parameter value for max_sectors can be used
	 */
	if (max_sectors && max_sectors < instance->max_sectors_per_req)
		instance->max_sectors_per_req = max_sectors;
	else {
		if (max_sectors) {
			if (((instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
				(instance->pdev->device ==
				PCI_DEVICE_ID_LSI_SAS0079GEN2)) &&
				(max_sectors <= MEGASAS_MAX_SECTORS)) {
				instance->max_sectors_per_req = max_sectors;
			} else {
			printk(KERN_INFO "megasas: max_sectors should be > 0"
				"and <= %d (or < 1MB for GEN2 controller)\n",
				instance->max_sectors_per_req);
			}
		}
	}

	host->max_sectors = instance->max_sectors_per_req;
	host->cmd_per_lun = 128;
	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
	host->max_lun = MEGASAS_MAX_LUN;
	host->max_cmd_len = 16;

	/*
	 * Notify the mid-layer about the new controller
	 */
	if (scsi_add_host(host, &instance->pdev->dev)) {
		printk(KERN_DEBUG "megasas: scsi_add_host failed\n");
		return -ENODEV;
	}

	/*
	 * Trigger SCSI to scan our drives
	 */
	scsi_scan_host(host);
	return 0;
}

static int
megasas_set_dma_mask(struct pci_dev *pdev)
{
	/*
	 * All our contollers are capable of performing 64-bit DMA
	 */
	if (IS_DMA64) {
		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {

			if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
				goto fail_set_dma_mask;
		}
	} else {
		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
			goto fail_set_dma_mask;
	}
	return 0;

fail_set_dma_mask:
	return 1;
}

/**
 * megasas_probe_one -	PCI hotplug entry point
 * @pdev:		PCI device structure
 * @id:			PCI ids of supported hotplugged adapter	
 */
static int __devinit
megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
{
	int rval;
	struct Scsi_Host *host;
	struct megasas_instance *instance;

	/*
	 * Announce PCI information
	 */
	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
	       pdev->subsystem_device);

	printk("bus %d:slot %d:func %d\n",
	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));

	/*
	 * PCI prepping: enable device set bus mastering and dma mask
	 */
	rval = pci_enable_device_mem(pdev);

	if (rval) {
		return rval;
	}

	pci_set_master(pdev);

	if (megasas_set_dma_mask(pdev))
		goto fail_set_dma_mask;

	host = scsi_host_alloc(&megasas_template,
			       sizeof(struct megasas_instance));

	if (!host) {
		printk(KERN_DEBUG "megasas: scsi_host_alloc failed\n");
		goto fail_alloc_instance;
	}

	instance = (struct megasas_instance *)host->hostdata;
	memset(instance, 0, sizeof(*instance));
	atomic_set( &instance->fw_reset_no_pci_access, 0 );

	instance->producer = pci_alloc_consistent(pdev, sizeof(u32),
						  &instance->producer_h);
	instance->consumer = pci_alloc_consistent(pdev, sizeof(u32),
						  &instance->consumer_h);

	if (!instance->producer || !instance->consumer) {
		printk(KERN_DEBUG "megasas: Failed to allocate memory for "
		       "producer, consumer\n");
		goto fail_alloc_dma_buf;
	}

	*instance->producer = 0;
	*instance->consumer = 0;
	megasas_poll_wait_aen = 0;
	instance->flag_ieee = 0;
	instance->ev = NULL;
	instance->issuepend_done = 1;
	instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
	megasas_poll_wait_aen = 0;

	instance->evt_detail = pci_alloc_consistent(pdev,
						    sizeof(struct
							   megasas_evt_detail),
						    &instance->evt_detail_h);

	if (!instance->evt_detail) {
		printk(KERN_DEBUG "megasas: Failed to allocate memory for "
		       "event detail structure\n");
		goto fail_alloc_dma_buf;
	}

	/*
	 * Initialize locks and queues
	 */
	INIT_LIST_HEAD(&instance->cmd_pool);
	INIT_LIST_HEAD(&instance->internal_reset_pending_q);

	atomic_set(&instance->fw_outstanding,0);

	init_waitqueue_head(&instance->int_cmd_wait_q);
	init_waitqueue_head(&instance->abort_cmd_wait_q);

	spin_lock_init(&instance->cmd_pool_lock);
	spin_lock_init(&instance->hba_lock);
	spin_lock_init(&instance->completion_lock);
	spin_lock_init(&poll_aen_lock);

	mutex_init(&instance->aen_mutex);

	/*
	 * Initialize PCI related and misc parameters
	 */
	instance->pdev = pdev;
	instance->host = host;
	instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
	instance->init_id = MEGASAS_DEFAULT_INIT_ID;

	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
		instance->flag_ieee = 1;
		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
	} else
		sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);

	megasas_dbg_lvl = 0;
	instance->flag = 0;
	instance->unload = 1;
	instance->last_time = 0;
	instance->disableOnlineCtrlReset = 1;

	INIT_WORK(&instance->work_init, process_fw_state_change_wq);

	/*
	 * Initialize MFI Firmware
	 */
	if (megasas_init_mfi(instance))
		goto fail_init_mfi;

	/*
	 * Register IRQ
	 */
	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED, "megasas", instance)) {
		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
		goto fail_irq;
	}

	instance->instancet->enable_intr(instance->reg_set);

	/*
	 * Store instance in PCI softstate
	 */
	pci_set_drvdata(pdev, instance);

	/*
	 * Add this controller to megasas_mgmt_info structure so that it
	 * can be exported to management applications
	 */
	megasas_mgmt_info.count++;
	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = instance;
	megasas_mgmt_info.max_index++;

	/*
	 * Initiate AEN (Asynchronous Event Notification)
	 */
	if (megasas_start_aen(instance)) {
		printk(KERN_DEBUG "megasas: start aen failed\n");
		goto fail_start_aen;
	}

	/*
	 * Register with SCSI mid-layer
	 */
	if (megasas_io_attach(instance))
		goto fail_io_attach;

	instance->unload = 0;
	return 0;

      fail_start_aen:
      fail_io_attach:
	megasas_mgmt_info.count--;
	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
	megasas_mgmt_info.max_index--;

	pci_set_drvdata(pdev, NULL);
	instance->instancet->disable_intr(instance->reg_set);
	free_irq(instance->pdev->irq, instance);

	megasas_release_mfi(instance);

      fail_irq:
      fail_init_mfi:
      fail_alloc_dma_buf:
	if (instance->evt_detail)
		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
				    instance->evt_detail,
				    instance->evt_detail_h);

	if (instance->producer)
		pci_free_consistent(pdev, sizeof(u32), instance->producer,
				    instance->producer_h);
	if (instance->consumer)
		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
				    instance->consumer_h);
	scsi_host_put(host);

      fail_alloc_instance:
      fail_set_dma_mask:
	pci_disable_device(pdev);

	return -ENODEV;
}

/**
 * megasas_flush_cache -	Requests FW to flush all its caches
 * @instance:			Adapter soft state
 */
static void megasas_flush_cache(struct megasas_instance *instance)
{
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;

	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
		return;

	cmd = megasas_get_cmd(instance);

	if (!cmd)
		return;

	dcmd = &cmd->frame->dcmd;

	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0x0;
	dcmd->sge_count = 0;
	dcmd->flags = MFI_FRAME_DIR_NONE;
	dcmd->timeout = 0;
	dcmd->pad_0 = 0;
	dcmd->data_xfer_len = 0;
	dcmd->opcode = MR_DCMD_CTRL_CACHE_FLUSH;
	dcmd->mbox.b[0] = MR_FLUSH_CTRL_CACHE | MR_FLUSH_DISK_CACHE;

	megasas_issue_blocked_cmd(instance, cmd);

	megasas_return_cmd(instance, cmd);

	return;
}

/**
 * megasas_shutdown_controller -	Instructs FW to shutdown the controller
 * @instance:				Adapter soft state
 * @opcode:				Shutdown/Hibernate
 */
static void megasas_shutdown_controller(struct megasas_instance *instance,
					u32 opcode)
{
	struct megasas_cmd *cmd;
	struct megasas_dcmd_frame *dcmd;

	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
		return;

	cmd = megasas_get_cmd(instance);

	if (!cmd)
		return;

	if (instance->aen_cmd)
		megasas_issue_blocked_abort_cmd(instance, instance->aen_cmd);

	dcmd = &cmd->frame->dcmd;

	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

	dcmd->cmd = MFI_CMD_DCMD;
	dcmd->cmd_status = 0x0;
	dcmd->sge_count = 0;
	dcmd->flags = MFI_FRAME_DIR_NONE;
	dcmd->timeout = 0;
	dcmd->pad_0 = 0;
	dcmd->data_xfer_len = 0;
	dcmd->opcode = opcode;

	megasas_issue_blocked_cmd(instance, cmd);

	megasas_return_cmd(instance, cmd);

	return;
}

#ifdef CONFIG_PM
/**
 * megasas_suspend -	driver suspend entry point
 * @pdev:		PCI device structure
 * @state:		PCI power state to suspend routine
 */
static int
megasas_suspend(struct pci_dev *pdev, pm_message_t state)
{
	struct Scsi_Host *host;
	struct megasas_instance *instance;

	instance = pci_get_drvdata(pdev);
	host = instance->host;
	instance->unload = 1;

	if (poll_mode_io)
		del_timer_sync(&instance->io_completion_timer);

	megasas_flush_cache(instance);
	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);

	/* cancel the delayed work if this work still in queue */
	if (instance->ev != NULL) {
		struct megasas_aen_event *ev = instance->ev;
		cancel_delayed_work(
			(struct delayed_work *)&ev->hotplug_work);
		flush_scheduled_work();
		instance->ev = NULL;
	}

	tasklet_kill(&instance->isr_tasklet);

	pci_set_drvdata(instance->pdev, instance);
	instance->instancet->disable_intr(instance->reg_set);
	free_irq(instance->pdev->irq, instance);

	pci_save_state(pdev);
	pci_disable_device(pdev);

	pci_set_power_state(pdev, pci_choose_state(pdev, state));

	return 0;
}

/**
 * megasas_resume-      driver resume entry point
 * @pdev:               PCI device structure
 */
static int
megasas_resume(struct pci_dev *pdev)
{
	int rval;
	struct Scsi_Host *host;
	struct megasas_instance *instance;

	instance = pci_get_drvdata(pdev);
	host = instance->host;
	pci_set_power_state(pdev, PCI_D0);
	pci_enable_wake(pdev, PCI_D0, 0);
	pci_restore_state(pdev);

	/*
	 * PCI prepping: enable device set bus mastering and dma mask
	 */
	rval = pci_enable_device_mem(pdev);

	if (rval) {
		printk(KERN_ERR "megasas: Enable device failed\n");
		return rval;
	}

	pci_set_master(pdev);

	if (megasas_set_dma_mask(pdev))
		goto fail_set_dma_mask;

	/*
	 * Initialize MFI Firmware
	 */

	*instance->producer = 0;
	*instance->consumer = 0;

	atomic_set(&instance->fw_outstanding, 0);

	/*
	 * We expect the FW state to be READY
	 */
	if (megasas_transition_to_ready(instance))
		goto fail_ready_state;

	if (megasas_issue_init_mfi(instance))
		goto fail_init_mfi;

	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
			(unsigned long)instance);

	/*
	 * Register IRQ
	 */
	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
		"megasas", instance)) {
		printk(KERN_ERR "megasas: Failed to register IRQ\n");
		goto fail_irq;
	}

	instance->instancet->enable_intr(instance->reg_set);

	/*
	 * Initiate AEN (Asynchronous Event Notification)
	 */
	if (megasas_start_aen(instance))
		printk(KERN_ERR "megasas: Start AEN failed\n");

	/* Initialize the cmd completion timer */
	if (poll_mode_io)
		megasas_start_timer(instance, &instance->io_completion_timer,
				megasas_io_completion_timer,
				MEGASAS_COMPLETION_TIMER_INTERVAL);
	instance->unload = 0;

	return 0;

fail_irq:
fail_init_mfi:
	if (instance->evt_detail)
		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
				instance->evt_detail,
				instance->evt_detail_h);

	if (instance->producer)
		pci_free_consistent(pdev, sizeof(u32), instance->producer,
				instance->producer_h);
	if (instance->consumer)
		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
				instance->consumer_h);
	scsi_host_put(host);

fail_set_dma_mask:
fail_ready_state:

	pci_disable_device(pdev);

	return -ENODEV;
}
#else
#define megasas_suspend	NULL
#define megasas_resume	NULL
#endif

/**
 * megasas_detach_one -	PCI hot"un"plug entry point
 * @pdev:		PCI device structure
 */
static void __devexit megasas_detach_one(struct pci_dev *pdev)
{
	int i;
	struct Scsi_Host *host;
	struct megasas_instance *instance;

	instance = pci_get_drvdata(pdev);
	instance->unload = 1;
	host = instance->host;

	if (poll_mode_io)
		del_timer_sync(&instance->io_completion_timer);

	scsi_remove_host(instance->host);
	megasas_flush_cache(instance);
	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);

	/* cancel the delayed work if this work still in queue*/
	if (instance->ev != NULL) {
		struct megasas_aen_event *ev = instance->ev;
		cancel_delayed_work(
			(struct delayed_work *)&ev->hotplug_work);
		flush_scheduled_work();
		instance->ev = NULL;
	}

	tasklet_kill(&instance->isr_tasklet);

	/*
	 * Take the instance off the instance array. Note that we will not
	 * decrement the max_index. We let this array be sparse array
	 */
	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
		if (megasas_mgmt_info.instance[i] == instance) {
			megasas_mgmt_info.count--;
			megasas_mgmt_info.instance[i] = NULL;

			break;
		}
	}

	pci_set_drvdata(instance->pdev, NULL);

	instance->instancet->disable_intr(instance->reg_set);

	free_irq(instance->pdev->irq, instance);

	megasas_release_mfi(instance);

	pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
			    instance->evt_detail, instance->evt_detail_h);

	pci_free_consistent(pdev, sizeof(u32), instance->producer,
			    instance->producer_h);

	pci_free_consistent(pdev, sizeof(u32), instance->consumer,
			    instance->consumer_h);

	scsi_host_put(host);

	pci_set_drvdata(pdev, NULL);

	pci_disable_device(pdev);

	return;
}

/**
 * megasas_shutdown -	Shutdown entry point
 * @device:		Generic device structure
 */
static void megasas_shutdown(struct pci_dev *pdev)
{
	struct megasas_instance *instance = pci_get_drvdata(pdev);
	instance->unload = 1;
	megasas_flush_cache(instance);
	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
}

/**
 * megasas_mgmt_open -	char node "open" entry point
 */
static int megasas_mgmt_open(struct inode *inode, struct file *filep)
{
	cycle_kernel_lock();
	/*
	 * Allow only those users with admin rights
	 */
	if (!capable(CAP_SYS_ADMIN))
		return -EACCES;

	return 0;
}

/**
 * megasas_mgmt_fasync -	Async notifier registration from applications
 *
 * This function adds the calling process to a driver global queue. When an
 * event occurs, SIGIO will be sent to all processes in this queue.
 */
static int megasas_mgmt_fasync(int fd, struct file *filep, int mode)
{
	int rc;

	mutex_lock(&megasas_async_queue_mutex);

	rc = fasync_helper(fd, filep, mode, &megasas_async_queue);

	mutex_unlock(&megasas_async_queue_mutex);

	if (rc >= 0) {
		/* For sanity check when we get ioctl */
		filep->private_data = filep;
		return 0;
	}

	printk(KERN_DEBUG "megasas: fasync_helper failed [%d]\n", rc);

	return rc;
}

/**
 * megasas_mgmt_poll -  char node "poll" entry point
 * */
static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
{
	unsigned int mask;
	unsigned long flags;
	poll_wait(file, &megasas_poll_wait, wait);
	spin_lock_irqsave(&poll_aen_lock, flags);
	if (megasas_poll_wait_aen)
		mask =   (POLLIN | POLLRDNORM);
	else
		mask = 0;
	spin_unlock_irqrestore(&poll_aen_lock, flags);
	return mask;
}

/**
 * megasas_mgmt_fw_ioctl -	Issues management ioctls to FW
 * @instance:			Adapter soft state
 * @argp:			User's ioctl packet
 */
static int
megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
		      struct megasas_iocpacket __user * user_ioc,
		      struct megasas_iocpacket *ioc)
{
	struct megasas_sge32 *kern_sge32;
	struct megasas_cmd *cmd;
	void *kbuff_arr[MAX_IOCTL_SGE];
	dma_addr_t buf_handle = 0;
	int error = 0, i;
	void *sense = NULL;
	dma_addr_t sense_handle;
	unsigned long *sense_ptr;

	memset(kbuff_arr, 0, sizeof(kbuff_arr));

	if (ioc->sge_count > MAX_IOCTL_SGE) {
		printk(KERN_DEBUG "megasas: SGE count [%d] >  max limit [%d]\n",
		       ioc->sge_count, MAX_IOCTL_SGE);
		return -EINVAL;
	}

	cmd = megasas_get_cmd(instance);
	if (!cmd) {
		printk(KERN_DEBUG "megasas: Failed to get a cmd packet\n");
		return -ENOMEM;
	}

	/*
	 * User's IOCTL packet has 2 frames (maximum). Copy those two
	 * frames into our cmd's frames. cmd->frame's context will get
	 * overwritten when we copy from user's frames. So set that value
	 * alone separately
	 */
	memcpy(cmd->frame, ioc->frame.raw, 2 * MEGAMFI_FRAME_SIZE);
	cmd->frame->hdr.context = cmd->index;
	cmd->frame->hdr.pad_0 = 0;

	/*
	 * The management interface between applications and the fw uses
	 * MFI frames. E.g, RAID configuration changes, LD property changes
	 * etc are accomplishes through different kinds of MFI frames. The
	 * driver needs to care only about substituting user buffers with
	 * kernel buffers in SGLs. The location of SGL is embedded in the
	 * struct iocpacket itself.
	 */
	kern_sge32 = (struct megasas_sge32 *)
	    ((unsigned long)cmd->frame + ioc->sgl_off);

	/*
	 * For each user buffer, create a mirror buffer and copy in
	 */
	for (i = 0; i < ioc->sge_count; i++) {
		kbuff_arr[i] = dma_alloc_coherent(&instance->pdev->dev,
						    ioc->sgl[i].iov_len,
						    &buf_handle, GFP_KERNEL);
		if (!kbuff_arr[i]) {
			printk(KERN_DEBUG "megasas: Failed to alloc "
			       "kernel SGL buffer for IOCTL \n");
			error = -ENOMEM;
			goto out;
		}

		/*
		 * We don't change the dma_coherent_mask, so
		 * pci_alloc_consistent only returns 32bit addresses
		 */
		kern_sge32[i].phys_addr = (u32) buf_handle;
		kern_sge32[i].length = ioc->sgl[i].iov_len;

		/*
		 * We created a kernel buffer corresponding to the
		 * user buffer. Now copy in from the user buffer
		 */
		if (copy_from_user(kbuff_arr[i], ioc->sgl[i].iov_base,
				   (u32) (ioc->sgl[i].iov_len))) {
			error = -EFAULT;
			goto out;
		}
	}

	if (ioc->sense_len) {
		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
					     &sense_handle, GFP_KERNEL);
		if (!sense) {
			error = -ENOMEM;
			goto out;
		}

		sense_ptr =
		(unsigned long *) ((unsigned long)cmd->frame + ioc->sense_off);
		*sense_ptr = sense_handle;
	}

	/*
	 * Set the sync_cmd flag so that the ISR knows not to complete this
	 * cmd to the SCSI mid-layer
	 */
	cmd->sync_cmd = 1;
	megasas_issue_blocked_cmd(instance, cmd);
	cmd->sync_cmd = 0;

	/*
	 * copy out the kernel buffers to user buffers
	 */
	for (i = 0; i < ioc->sge_count; i++) {
		if (copy_to_user(ioc->sgl[i].iov_base, kbuff_arr[i],
				 ioc->sgl[i].iov_len)) {
			error = -EFAULT;
			goto out;
		}
	}

	/*
	 * copy out the sense
	 */
	if (ioc->sense_len) {
		/*
		 * sense_ptr points to the location that has the user
		 * sense buffer address
		 */
		sense_ptr = (unsigned long *) ((unsigned long)ioc->frame.raw +
				ioc->sense_off);

		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
				 sense, ioc->sense_len)) {
			printk(KERN_ERR "megasas: Failed to copy out to user "
					"sense data\n");
			error = -EFAULT;
			goto out;
		}
	}

	/*
	 * copy the status codes returned by the fw
	 */
	if (copy_to_user(&user_ioc->frame.hdr.cmd_status,
			 &cmd->frame->hdr.cmd_status, sizeof(u8))) {
		printk(KERN_DEBUG "megasas: Error copying out cmd_status\n");
		error = -EFAULT;
	}

      out:
	if (sense) {
		dma_free_coherent(&instance->pdev->dev, ioc->sense_len,
				    sense, sense_handle);
	}

	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
		dma_free_coherent(&instance->pdev->dev,
				    kern_sge32[i].length,
				    kbuff_arr[i], kern_sge32[i].phys_addr);
	}

	megasas_return_cmd(instance, cmd);
	return error;
}

static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
{
	struct megasas_iocpacket __user *user_ioc =
	    (struct megasas_iocpacket __user *)arg;
	struct megasas_iocpacket *ioc;
	struct megasas_instance *instance;
	int error;
	int i;
	unsigned long flags;
	u32 wait_time = MEGASAS_RESET_WAIT_TIME;

	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
	if (!ioc)
		return -ENOMEM;

	if (copy_from_user(ioc, user_ioc, sizeof(*ioc))) {
		error = -EFAULT;
		goto out_kfree_ioc;
	}

	instance = megasas_lookup_instance(ioc->host_no);
	if (!instance) {
		error = -ENODEV;
		goto out_kfree_ioc;
	}

	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
		printk(KERN_ERR "Controller in crit error\n");
		error = -ENODEV;
		goto out_kfree_ioc;
	}

	if (instance->unload == 1) {
		error = -ENODEV;
		goto out_kfree_ioc;
	}

	/*
	 * We will allow only MEGASAS_INT_CMDS number of parallel ioctl cmds
	 */
	if (down_interruptible(&instance->ioctl_sem)) {
		error = -ERESTARTSYS;
		goto out_kfree_ioc;
	}

	for (i = 0; i < wait_time; i++) {

		spin_lock_irqsave(&instance->hba_lock, flags);
		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
			spin_unlock_irqrestore(&instance->hba_lock, flags);
			break;
		}
		spin_unlock_irqrestore(&instance->hba_lock, flags);

		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
			printk(KERN_NOTICE "megasas: waiting"
				"for controller reset to finish\n");
		}

		msleep(1000);
	}

	spin_lock_irqsave(&instance->hba_lock, flags);
	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
		spin_unlock_irqrestore(&instance->hba_lock, flags);

		printk(KERN_ERR "megaraid_sas: timed out while"
			"waiting for HBA to recover\n");
		error = -ENODEV;
		goto out_kfree_ioc;
	}
	spin_unlock_irqrestore(&instance->hba_lock, flags);

	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
	up(&instance->ioctl_sem);

      out_kfree_ioc:
	kfree(ioc);
	return error;
}

static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
{
	struct megasas_instance *instance;
	struct megasas_aen aen;
	int error;
	int i;
	unsigned long flags;
	u32 wait_time = MEGASAS_RESET_WAIT_TIME;

	if (file->private_data != file) {
		printk(KERN_DEBUG "megasas: fasync_helper was not "
		       "called first\n");
		return -EINVAL;
	}

	if (copy_from_user(&aen, (void __user *)arg, sizeof(aen)))
		return -EFAULT;

	instance = megasas_lookup_instance(aen.host_no);

	if (!instance)
		return -ENODEV;

	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
		return -ENODEV;
	}

	if (instance->unload == 1) {
		return -ENODEV;
	}

	for (i = 0; i < wait_time; i++) {

		spin_lock_irqsave(&instance->hba_lock, flags);
		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
			spin_unlock_irqrestore(&instance->hba_lock,
						flags);
			break;
		}

		spin_unlock_irqrestore(&instance->hba_lock, flags);

		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
			printk(KERN_NOTICE "megasas: waiting for"
				"controller reset to finish\n");
		}

		msleep(1000);
	}

	spin_lock_irqsave(&instance->hba_lock, flags);
	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
		spin_unlock_irqrestore(&instance->hba_lock, flags);
		printk(KERN_ERR "megaraid_sas: timed out while waiting"
				"for HBA to recover.\n");
		return -ENODEV;
	}
	spin_unlock_irqrestore(&instance->hba_lock, flags);

	mutex_lock(&instance->aen_mutex);
	error = megasas_register_aen(instance, aen.seq_num,
				     aen.class_locale_word);
	mutex_unlock(&instance->aen_mutex);
	return error;
}

/**
 * megasas_mgmt_ioctl -	char node ioctl entry point
 */
static long
megasas_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	switch (cmd) {
	case MEGASAS_IOC_FIRMWARE:
		return megasas_mgmt_ioctl_fw(file, arg);

	case MEGASAS_IOC_GET_AEN:
		return megasas_mgmt_ioctl_aen(file, arg);
	}

	return -ENOTTY;
}

#ifdef CONFIG_COMPAT
static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
{
	struct compat_megasas_iocpacket __user *cioc =
	    (struct compat_megasas_iocpacket __user *)arg;
	struct megasas_iocpacket __user *ioc =
	    compat_alloc_user_space(sizeof(struct megasas_iocpacket));
	int i;
	int error = 0;
	compat_uptr_t ptr;

	if (clear_user(ioc, sizeof(*ioc)))
		return -EFAULT;

	if (copy_in_user(&ioc->host_no, &cioc->host_no, sizeof(u16)) ||
	    copy_in_user(&ioc->sgl_off, &cioc->sgl_off, sizeof(u32)) ||
	    copy_in_user(&ioc->sense_off, &cioc->sense_off, sizeof(u32)) ||
	    copy_in_user(&ioc->sense_len, &cioc->sense_len, sizeof(u32)) ||
	    copy_in_user(ioc->frame.raw, cioc->frame.raw, 128) ||
	    copy_in_user(&ioc->sge_count, &cioc->sge_count, sizeof(u32)))
		return -EFAULT;

	/*
	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
	 * sense_len is not null, so prepare the 64bit value under
	 * the same condition.
	 */
	if (ioc->sense_len) {
		void __user **sense_ioc_ptr =
			(void __user **)(ioc->frame.raw + ioc->sense_off);
		compat_uptr_t *sense_cioc_ptr =
			(compat_uptr_t *)(cioc->frame.raw + cioc->sense_off);
		if (get_user(ptr, sense_cioc_ptr) ||
		    put_user(compat_ptr(ptr), sense_ioc_ptr))
			return -EFAULT;
	}

	for (i = 0; i < MAX_IOCTL_SGE; i++) {
		if (get_user(ptr, &cioc->sgl[i].iov_base) ||
		    put_user(compat_ptr(ptr), &ioc->sgl[i].iov_base) ||
		    copy_in_user(&ioc->sgl[i].iov_len,
				 &cioc->sgl[i].iov_len, sizeof(compat_size_t)))
			return -EFAULT;
	}

	error = megasas_mgmt_ioctl_fw(file, (unsigned long)ioc);

	if (copy_in_user(&cioc->frame.hdr.cmd_status,
			 &ioc->frame.hdr.cmd_status, sizeof(u8))) {
		printk(KERN_DEBUG "megasas: error copy_in_user cmd_status\n");
		return -EFAULT;
	}
	return error;
}

static long
megasas_mgmt_compat_ioctl(struct file *file, unsigned int cmd,
			  unsigned long arg)
{
	switch (cmd) {
	case MEGASAS_IOC_FIRMWARE32:
		return megasas_mgmt_compat_ioctl_fw(file, arg);
	case MEGASAS_IOC_GET_AEN:
		return megasas_mgmt_ioctl_aen(file, arg);
	}

	return -ENOTTY;
}
#endif

/*
 * File operations structure for management interface
 */
static const struct file_operations megasas_mgmt_fops = {
	.owner = THIS_MODULE,
	.open = megasas_mgmt_open,
	.fasync = megasas_mgmt_fasync,
	.unlocked_ioctl = megasas_mgmt_ioctl,
	.poll = megasas_mgmt_poll,
#ifdef CONFIG_COMPAT
	.compat_ioctl = megasas_mgmt_compat_ioctl,
#endif
};

/*
 * PCI hotplug support registration structure
 */
static struct pci_driver megasas_pci_driver = {

	.name = "megaraid_sas",
	.id_table = megasas_pci_table,
	.probe = megasas_probe_one,
	.remove = __devexit_p(megasas_detach_one),
	.suspend = megasas_suspend,
	.resume = megasas_resume,
	.shutdown = megasas_shutdown,
};

/*
 * Sysfs driver attributes
 */
static ssize_t megasas_sysfs_show_version(struct device_driver *dd, char *buf)
{
	return snprintf(buf, strlen(MEGASAS_VERSION) + 2, "%s\n",
			MEGASAS_VERSION);
}

static DRIVER_ATTR(version, S_IRUGO, megasas_sysfs_show_version, NULL);

static ssize_t
megasas_sysfs_show_release_date(struct device_driver *dd, char *buf)
{
	return snprintf(buf, strlen(MEGASAS_RELDATE) + 2, "%s\n",
			MEGASAS_RELDATE);
}

static DRIVER_ATTR(release_date, S_IRUGO, megasas_sysfs_show_release_date,
		   NULL);

static ssize_t
megasas_sysfs_show_support_poll_for_event(struct device_driver *dd, char *buf)
{
	return sprintf(buf, "%u\n", support_poll_for_event);
}

static DRIVER_ATTR(support_poll_for_event, S_IRUGO,
			megasas_sysfs_show_support_poll_for_event, NULL);

 static ssize_t
megasas_sysfs_show_support_device_change(struct device_driver *dd, char *buf)
{
	return sprintf(buf, "%u\n", support_device_change);
}

static DRIVER_ATTR(support_device_change, S_IRUGO,
			megasas_sysfs_show_support_device_change, NULL);

static ssize_t
megasas_sysfs_show_dbg_lvl(struct device_driver *dd, char *buf)
{
	return sprintf(buf, "%u\n", megasas_dbg_lvl);
}

static ssize_t
megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t count)
{
	int retval = count;
	if(sscanf(buf,"%u",&megasas_dbg_lvl)<1){
		printk(KERN_ERR "megasas: could not set dbg_lvl\n");
		retval = -EINVAL;
	}
	return retval;
}

static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR, megasas_sysfs_show_dbg_lvl,
		megasas_sysfs_set_dbg_lvl);

static ssize_t
megasas_sysfs_show_poll_mode_io(struct device_driver *dd, char *buf)
{
	return sprintf(buf, "%u\n", poll_mode_io);
}

static ssize_t
megasas_sysfs_set_poll_mode_io(struct device_driver *dd,
				const char *buf, size_t count)
{
	int retval = count;
	int tmp = poll_mode_io;
	int i;
	struct megasas_instance *instance;

	if (sscanf(buf, "%u", &poll_mode_io) < 1) {
		printk(KERN_ERR "megasas: could not set poll_mode_io\n");
		retval = -EINVAL;
	}

	/*
	 * Check if poll_mode_io is already set or is same as previous value
	 */
	if ((tmp && poll_mode_io) || (tmp == poll_mode_io))
		goto out;

	if (poll_mode_io) {
		/*
		 * Start timers for all adapters
		 */
		for (i = 0; i < megasas_mgmt_info.max_index; i++) {
			instance = megasas_mgmt_info.instance[i];
			if (instance) {
				megasas_start_timer(instance,
					&instance->io_completion_timer,
					megasas_io_completion_timer,
					MEGASAS_COMPLETION_TIMER_INTERVAL);
			}
		}
	} else {
		/*
		 * Delete timers for all adapters
		 */
		for (i = 0; i < megasas_mgmt_info.max_index; i++) {
			instance = megasas_mgmt_info.instance[i];
			if (instance)
				del_timer_sync(&instance->io_completion_timer);
		}
	}

out:
	return retval;
}

static void
megasas_aen_polling(struct work_struct *work)
{
	struct megasas_aen_event *ev =
		container_of(work, struct megasas_aen_event, hotplug_work);
	struct megasas_instance *instance = ev->instance;
	union megasas_evt_class_locale class_locale;
	struct  Scsi_Host *host;
	struct  scsi_device *sdev1;
	u16     pd_index = 0;
	u16	ld_index = 0;
	int     i, j, doscan = 0;
	u32 seq_num;
	int error;

	if (!instance) {
		printk(KERN_ERR "invalid instance!\n");
		kfree(ev);
		return;
	}
	instance->ev = NULL;
	host = instance->host;
	if (instance->evt_detail) {

		switch (instance->evt_detail->code) {
		case MR_EVT_PD_INSERTED:
			if (megasas_get_pd_list(instance) == 0) {
			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
				for (j = 0;
				j < MEGASAS_MAX_DEV_PER_CHANNEL;
				j++) {

				pd_index =
				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

				sdev1 =
				scsi_device_lookup(host, i, j, 0);

				if (instance->pd_list[pd_index].driveState
						== MR_PD_STATE_SYSTEM) {
						if (!sdev1) {
						scsi_add_device(host, i, j, 0);
						}

					if (sdev1)
						scsi_device_put(sdev1);
					}
				}
			}
			}
			doscan = 0;
			break;

		case MR_EVT_PD_REMOVED:
			if (megasas_get_pd_list(instance) == 0) {
			megasas_get_pd_list(instance);
			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
				for (j = 0;
				j < MEGASAS_MAX_DEV_PER_CHANNEL;
				j++) {

				pd_index =
				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

				sdev1 =
				scsi_device_lookup(host, i, j, 0);

				if (instance->pd_list[pd_index].driveState
					== MR_PD_STATE_SYSTEM) {
					if (sdev1) {
						scsi_device_put(sdev1);
					}
				} else {
					if (sdev1) {
						scsi_remove_device(sdev1);
						scsi_device_put(sdev1);
					}
				}
				}
			}
			}
			doscan = 0;
			break;

		case MR_EVT_LD_OFFLINE:
		case MR_EVT_LD_DELETED:
			megasas_get_ld_list(instance);
			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
				for (j = 0;
				j < MEGASAS_MAX_DEV_PER_CHANNEL;
				j++) {

				ld_index =
				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

				sdev1 = scsi_device_lookup(host,
					i + MEGASAS_MAX_LD_CHANNELS,
					j,
					0);

				if (instance->ld_ids[ld_index] != 0xff) {
					if (sdev1) {
						scsi_device_put(sdev1);
					}
				} else {
					if (sdev1) {
						scsi_remove_device(sdev1);
						scsi_device_put(sdev1);
					}
				}
				}
			}
			doscan = 0;
			break;
		case MR_EVT_LD_CREATED:
			megasas_get_ld_list(instance);
			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
				for (j = 0;
					j < MEGASAS_MAX_DEV_PER_CHANNEL;
					j++) {
					ld_index =
					(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

					sdev1 = scsi_device_lookup(host,
						i+MEGASAS_MAX_LD_CHANNELS,
						j, 0);

					if (instance->ld_ids[ld_index] !=
								0xff) {
						if (!sdev1) {
							scsi_add_device(host,
								i + 2,
								j, 0);
						}
					}
					if (sdev1) {
						scsi_device_put(sdev1);
					}
				}
			}
			doscan = 0;
			break;
		case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
		case MR_EVT_FOREIGN_CFG_IMPORTED:
			doscan = 1;
			break;
		default:
			doscan = 0;
			break;
		}
	} else {
		printk(KERN_ERR "invalid evt_detail!\n");
		kfree(ev);
		return;
	}

	if (doscan) {
		printk(KERN_INFO "scanning ...\n");
		megasas_get_pd_list(instance);
		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
				pd_index = i*MEGASAS_MAX_DEV_PER_CHANNEL + j;
				sdev1 = scsi_device_lookup(host, i, j, 0);
				if (instance->pd_list[pd_index].driveState ==
							MR_PD_STATE_SYSTEM) {
					if (!sdev1) {
						scsi_add_device(host, i, j, 0);
					}
					if (sdev1)
						scsi_device_put(sdev1);
				} else {
					if (sdev1) {
						scsi_remove_device(sdev1);
						scsi_device_put(sdev1);
					}
				}
			}
		}

		megasas_get_ld_list(instance);
		for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
				ld_index =
				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

				sdev1 = scsi_device_lookup(host,
					i+MEGASAS_MAX_LD_CHANNELS, j, 0);
				if (instance->ld_ids[ld_index] != 0xff) {
					if (!sdev1) {
						scsi_add_device(host,
								i+2,
								j, 0);
					} else {
						scsi_device_put(sdev1);
					}
				} else {
					if (sdev1) {
						scsi_remove_device(sdev1);
						scsi_device_put(sdev1);
					}
				}
			}
		}
	}

	if ( instance->aen_cmd != NULL ) {
		kfree(ev);
		return ;
	}

	seq_num = instance->evt_detail->seq_num + 1;

	/* Register AEN with FW for latest sequence number plus 1 */
	class_locale.members.reserved = 0;
	class_locale.members.locale = MR_EVT_LOCALE_ALL;
	class_locale.members.class = MR_EVT_CLASS_DEBUG;
	mutex_lock(&instance->aen_mutex);
	error = megasas_register_aen(instance, seq_num,
					class_locale.word);
	mutex_unlock(&instance->aen_mutex);

	if (error)
		printk(KERN_ERR "register aen failed error %x\n", error);

	kfree(ev);
}


static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
		megasas_sysfs_show_poll_mode_io,
		megasas_sysfs_set_poll_mode_io);

/**
 * megasas_init - Driver load entry point
 */
static int __init megasas_init(void)
{
	int rval;

	/*
	 * Announce driver version and other information
	 */
	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
	       MEGASAS_EXT_VERSION);

	support_poll_for_event = 2;
	support_device_change = 1;

	memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));

	/*
	 * Register character device node
	 */
	rval = register_chrdev(0, "megaraid_sas_ioctl", &megasas_mgmt_fops);

	if (rval < 0) {
		printk(KERN_DEBUG "megasas: failed to open device node\n");
		return rval;
	}

	megasas_mgmt_majorno = rval;

	/*
	 * Register ourselves as PCI hotplug module
	 */
	rval = pci_register_driver(&megasas_pci_driver);

	if (rval) {
		printk(KERN_DEBUG "megasas: PCI hotplug regisration failed \n");
		goto err_pcidrv;
	}

	rval = driver_create_file(&megasas_pci_driver.driver,
				  &driver_attr_version);
	if (rval)
		goto err_dcf_attr_ver;
	rval = driver_create_file(&megasas_pci_driver.driver,
				  &driver_attr_release_date);
	if (rval)
		goto err_dcf_rel_date;

	rval = driver_create_file(&megasas_pci_driver.driver,
				&driver_attr_support_poll_for_event);
	if (rval)
		goto err_dcf_support_poll_for_event;

	rval = driver_create_file(&megasas_pci_driver.driver,
				  &driver_attr_dbg_lvl);
	if (rval)
		goto err_dcf_dbg_lvl;
	rval = driver_create_file(&megasas_pci_driver.driver,
				  &driver_attr_poll_mode_io);
	if (rval)
		goto err_dcf_poll_mode_io;

	rval = driver_create_file(&megasas_pci_driver.driver,
				&driver_attr_support_device_change);
	if (rval)
		goto err_dcf_support_device_change;

	return rval;

err_dcf_support_device_change:
	driver_remove_file(&megasas_pci_driver.driver,
		  &driver_attr_poll_mode_io);

err_dcf_poll_mode_io:
	driver_remove_file(&megasas_pci_driver.driver,
			   &driver_attr_dbg_lvl);
err_dcf_dbg_lvl:
	driver_remove_file(&megasas_pci_driver.driver,
			&driver_attr_support_poll_for_event);

err_dcf_support_poll_for_event:
	driver_remove_file(&megasas_pci_driver.driver,
			   &driver_attr_release_date);

err_dcf_rel_date:
	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
err_dcf_attr_ver:
	pci_unregister_driver(&megasas_pci_driver);
err_pcidrv:
	unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl");
  	return rval;
}

/**
 * megasas_exit - Driver unload entry point
 */
static void __exit megasas_exit(void)
{
	driver_remove_file(&megasas_pci_driver.driver,
			   &driver_attr_poll_mode_io);
	driver_remove_file(&megasas_pci_driver.driver,
			   &driver_attr_dbg_lvl);
	driver_remove_file(&megasas_pci_driver.driver,
			&driver_attr_support_poll_for_event);
	driver_remove_file(&megasas_pci_driver.driver,
			&driver_attr_support_device_change);
	driver_remove_file(&megasas_pci_driver.driver,
			   &driver_attr_release_date);
	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);

	pci_unregister_driver(&megasas_pci_driver);
	unregister_chrdev(megasas_mgmt_majorno, "megaraid_sas_ioctl");
}

module_init(megasas_init);
module_exit(megasas_exit);

--------------020409020608080801030505
Content-Type: text/x-chdr;
 name="megaraid_sas.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="megaraid_sas.h"

/*
 *
 *		Linux MegaRAID driver for SAS based RAID controllers
 *
 * Copyright (c) 2003-2005  LSI Corporation.
 *
 *		This program is free software; you can redistribute it and/or
 *		modify it under the terms of the GNU General Public License
 *		as published by the Free Software Foundation; either version
 *		2 of the License, or (at your option) any later version.
 *
 * FILE		: megaraid_sas.h
 */

#ifndef LSI_MEGARAID_SAS_H
#define LSI_MEGARAID_SAS_H

/*
 * MegaRAID SAS Driver meta data
 */
#define MEGASAS_VERSION			"00.00.04.31-rc1"
#define MEGASAS_RELDATE			"May 3, 2010"
#define MEGASAS_EXT_VERSION		"Mon. May 3, 11:41:51 PST 2010"

/*
 * Device IDs
 */
#define	PCI_DEVICE_ID_LSI_SAS1078R		0x0060
#define	PCI_DEVICE_ID_LSI_SAS1078DE		0x007C
#define	PCI_DEVICE_ID_LSI_VERDE_ZCR		0x0413
#define	PCI_DEVICE_ID_LSI_SAS1078GEN2		0x0078
#define	PCI_DEVICE_ID_LSI_SAS0079GEN2		0x0079
#define	PCI_DEVICE_ID_LSI_SAS0073SKINNY		0x0073
#define	PCI_DEVICE_ID_LSI_SAS0071SKINNY		0x0071

/*
 * =====================================
 * MegaRAID SAS MFI firmware definitions
 * =====================================
 */

/*
 * MFI stands for  MegaRAID SAS FW Interface. This is just a moniker for 
 * protocol between the software and firmware. Commands are issued using
 * "message frames"
 */

/*
 * FW posts its state in upper 4 bits of outbound_msg_0 register
 */
#define MFI_STATE_MASK				0xF0000000
#define MFI_STATE_UNDEFINED			0x00000000
#define MFI_STATE_BB_INIT			0x10000000
#define MFI_STATE_FW_INIT			0x40000000
#define MFI_STATE_WAIT_HANDSHAKE		0x60000000
#define MFI_STATE_FW_INIT_2			0x70000000
#define MFI_STATE_DEVICE_SCAN			0x80000000
#define MFI_STATE_BOOT_MESSAGE_PENDING		0x90000000
#define MFI_STATE_FLUSH_CACHE			0xA0000000
#define MFI_STATE_READY				0xB0000000
#define MFI_STATE_OPERATIONAL			0xC0000000
#define MFI_STATE_FAULT				0xF0000000
#define  MFI_RESET_REQUIRED			0x00000001

#define MEGAMFI_FRAME_SIZE			64

/*
 * During FW init, clear pending cmds & reset state using inbound_msg_0
 *
 * ABORT	: Abort all pending cmds
 * READY	: Move from OPERATIONAL to READY state; discard queue info
 * MFIMODE	: Discard (possible) low MFA posted in 64-bit mode (??)
 * CLR_HANDSHAKE: FW is waiting for HANDSHAKE from BIOS or Driver
 * HOTPLUG	: Resume from Hotplug
 * MFI_STOP_ADP	: Send signal to FW to stop processing
 */
#define WRITE_SEQUENCE_OFFSET		(0x0000000FC) /* I20 */
#define HOST_DIAGNOSTIC_OFFSET		(0x000000F8)  /* I20 */
#define DIAG_WRITE_ENABLE			(0x00000080)
#define DIAG_RESET_ADAPTER			(0x00000004)

#define MFI_ADP_RESET				0x00000040
#define MFI_INIT_ABORT				0x00000001
#define MFI_INIT_READY				0x00000002
#define MFI_INIT_MFIMODE			0x00000004
#define MFI_INIT_CLEAR_HANDSHAKE		0x00000008
#define MFI_INIT_HOTPLUG			0x00000010
#define MFI_STOP_ADP				0x00000020
#define MFI_RESET_FLAGS				MFI_INIT_READY| \
						MFI_INIT_MFIMODE| \
						MFI_INIT_ABORT

/*
 * MFI frame flags
 */
#define MFI_FRAME_POST_IN_REPLY_QUEUE		0x0000
#define MFI_FRAME_DONT_POST_IN_REPLY_QUEUE	0x0001
#define MFI_FRAME_SGL32				0x0000
#define MFI_FRAME_SGL64				0x0002
#define MFI_FRAME_SENSE32			0x0000
#define MFI_FRAME_SENSE64			0x0004
#define MFI_FRAME_DIR_NONE			0x0000
#define MFI_FRAME_DIR_WRITE			0x0008
#define MFI_FRAME_DIR_READ			0x0010
#define MFI_FRAME_DIR_BOTH			0x0018
#define MFI_FRAME_IEEE                          0x0020

/*
 * Definition for cmd_status
 */
#define MFI_CMD_STATUS_POLL_MODE		0xFF

/*
 * MFI command opcodes
 */
#define MFI_CMD_INIT				0x00
#define MFI_CMD_LD_READ				0x01
#define MFI_CMD_LD_WRITE			0x02
#define MFI_CMD_LD_SCSI_IO			0x03
#define MFI_CMD_PD_SCSI_IO			0x04
#define MFI_CMD_DCMD				0x05
#define MFI_CMD_ABORT				0x06
#define MFI_CMD_SMP				0x07
#define MFI_CMD_STP				0x08

#define MR_DCMD_CTRL_GET_INFO			0x01010000
#define MR_DCMD_LD_GET_LIST			0x03010000

#define MR_DCMD_CTRL_CACHE_FLUSH		0x01101000
#define MR_FLUSH_CTRL_CACHE			0x01
#define MR_FLUSH_DISK_CACHE			0x02

#define MR_DCMD_CTRL_SHUTDOWN			0x01050000
#define MR_DCMD_HIBERNATE_SHUTDOWN		0x01060000
#define MR_ENABLE_DRIVE_SPINDOWN		0x01

#define MR_DCMD_CTRL_EVENT_GET_INFO		0x01040100
#define MR_DCMD_CTRL_EVENT_GET			0x01040300
#define MR_DCMD_CTRL_EVENT_WAIT			0x01040500
#define MR_DCMD_LD_GET_PROPERTIES		0x03030000

#define MR_DCMD_CLUSTER				0x08000000
#define MR_DCMD_CLUSTER_RESET_ALL		0x08010100
#define MR_DCMD_CLUSTER_RESET_LD		0x08010200
#define MR_DCMD_PD_LIST_QUERY                   0x02010100

/*
 * MFI command completion codes
 */
enum MFI_STAT {
	MFI_STAT_OK = 0x00,
	MFI_STAT_INVALID_CMD = 0x01,
	MFI_STAT_INVALID_DCMD = 0x02,
	MFI_STAT_INVALID_PARAMETER = 0x03,
	MFI_STAT_INVALID_SEQUENCE_NUMBER = 0x04,
	MFI_STAT_ABORT_NOT_POSSIBLE = 0x05,
	MFI_STAT_APP_HOST_CODE_NOT_FOUND = 0x06,
	MFI_STAT_APP_IN_USE = 0x07,
	MFI_STAT_APP_NOT_INITIALIZED = 0x08,
	MFI_STAT_ARRAY_INDEX_INVALID = 0x09,
	MFI_STAT_ARRAY_ROW_NOT_EMPTY = 0x0a,
	MFI_STAT_CONFIG_RESOURCE_CONFLICT = 0x0b,
	MFI_STAT_DEVICE_NOT_FOUND = 0x0c,
	MFI_STAT_DRIVE_TOO_SMALL = 0x0d,
	MFI_STAT_FLASH_ALLOC_FAIL = 0x0e,
	MFI_STAT_FLASH_BUSY = 0x0f,
	MFI_STAT_FLASH_ERROR = 0x10,
	MFI_STAT_FLASH_IMAGE_BAD = 0x11,
	MFI_STAT_FLASH_IMAGE_INCOMPLETE = 0x12,
	MFI_STAT_FLASH_NOT_OPEN = 0x13,
	MFI_STAT_FLASH_NOT_STARTED = 0x14,
	MFI_STAT_FLUSH_FAILED = 0x15,
	MFI_STAT_HOST_CODE_NOT_FOUNT = 0x16,
	MFI_STAT_LD_CC_IN_PROGRESS = 0x17,
	MFI_STAT_LD_INIT_IN_PROGRESS = 0x18,
	MFI_STAT_LD_LBA_OUT_OF_RANGE = 0x19,
	MFI_STAT_LD_MAX_CONFIGURED = 0x1a,
	MFI_STAT_LD_NOT_OPTIMAL = 0x1b,
	MFI_STAT_LD_RBLD_IN_PROGRESS = 0x1c,
	MFI_STAT_LD_RECON_IN_PROGRESS = 0x1d,
	MFI_STAT_LD_WRONG_RAID_LEVEL = 0x1e,
	MFI_STAT_MAX_SPARES_EXCEEDED = 0x1f,
	MFI_STAT_MEMORY_NOT_AVAILABLE = 0x20,
	MFI_STAT_MFC_HW_ERROR = 0x21,
	MFI_STAT_NO_HW_PRESENT = 0x22,
	MFI_STAT_NOT_FOUND = 0x23,
	MFI_STAT_NOT_IN_ENCL = 0x24,
	MFI_STAT_PD_CLEAR_IN_PROGRESS = 0x25,
	MFI_STAT_PD_TYPE_WRONG = 0x26,
	MFI_STAT_PR_DISABLED = 0x27,
	MFI_STAT_ROW_INDEX_INVALID = 0x28,
	MFI_STAT_SAS_CONFIG_INVALID_ACTION = 0x29,
	MFI_STAT_SAS_CONFIG_INVALID_DATA = 0x2a,
	MFI_STAT_SAS_CONFIG_INVALID_PAGE = 0x2b,
	MFI_STAT_SAS_CONFIG_INVALID_TYPE = 0x2c,
	MFI_STAT_SCSI_DONE_WITH_ERROR = 0x2d,
	MFI_STAT_SCSI_IO_FAILED = 0x2e,
	MFI_STAT_SCSI_RESERVATION_CONFLICT = 0x2f,
	MFI_STAT_SHUTDOWN_FAILED = 0x30,
	MFI_STAT_TIME_NOT_SET = 0x31,
	MFI_STAT_WRONG_STATE = 0x32,
	MFI_STAT_LD_OFFLINE = 0x33,
	MFI_STAT_PEER_NOTIFICATION_REJECTED = 0x34,
	MFI_STAT_PEER_NOTIFICATION_FAILED = 0x35,
	MFI_STAT_RESERVATION_IN_PROGRESS = 0x36,
	MFI_STAT_I2C_ERRORS_DETECTED = 0x37,
	MFI_STAT_PCI_ERRORS_DETECTED = 0x38,

	MFI_STAT_INVALID_STATUS = 0xFF
};

/*
 * Number of mailbox bytes in DCMD message frame
 */
#define MFI_MBOX_SIZE				12

enum MR_EVT_CLASS {

	MR_EVT_CLASS_DEBUG = -2,
	MR_EVT_CLASS_PROGRESS = -1,
	MR_EVT_CLASS_INFO = 0,
	MR_EVT_CLASS_WARNING = 1,
	MR_EVT_CLASS_CRITICAL = 2,
	MR_EVT_CLASS_FATAL = 3,
	MR_EVT_CLASS_DEAD = 4,

};

enum MR_EVT_LOCALE {

	MR_EVT_LOCALE_LD = 0x0001,
	MR_EVT_LOCALE_PD = 0x0002,
	MR_EVT_LOCALE_ENCL = 0x0004,
	MR_EVT_LOCALE_BBU = 0x0008,
	MR_EVT_LOCALE_SAS = 0x0010,
	MR_EVT_LOCALE_CTRL = 0x0020,
	MR_EVT_LOCALE_CONFIG = 0x0040,
	MR_EVT_LOCALE_CLUSTER = 0x0080,
	MR_EVT_LOCALE_ALL = 0xffff,

};

enum MR_EVT_ARGS {

	MR_EVT_ARGS_NONE,
	MR_EVT_ARGS_CDB_SENSE,
	MR_EVT_ARGS_LD,
	MR_EVT_ARGS_LD_COUNT,
	MR_EVT_ARGS_LD_LBA,
	MR_EVT_ARGS_LD_OWNER,
	MR_EVT_ARGS_LD_LBA_PD_LBA,
	MR_EVT_ARGS_LD_PROG,
	MR_EVT_ARGS_LD_STATE,
	MR_EVT_ARGS_LD_STRIP,
	MR_EVT_ARGS_PD,
	MR_EVT_ARGS_PD_ERR,
	MR_EVT_ARGS_PD_LBA,
	MR_EVT_ARGS_PD_LBA_LD,
	MR_EVT_ARGS_PD_PROG,
	MR_EVT_ARGS_PD_STATE,
	MR_EVT_ARGS_PCI,
	MR_EVT_ARGS_RATE,
	MR_EVT_ARGS_STR,
	MR_EVT_ARGS_TIME,
	MR_EVT_ARGS_ECC,
	MR_EVT_ARGS_LD_PROP,
	MR_EVT_ARGS_PD_SPARE,
	MR_EVT_ARGS_PD_INDEX,
	MR_EVT_ARGS_DIAG_PASS,
	MR_EVT_ARGS_DIAG_FAIL,
	MR_EVT_ARGS_PD_LBA_LBA,
	MR_EVT_ARGS_PORT_PHY,
	MR_EVT_ARGS_PD_MISSING,
	MR_EVT_ARGS_PD_ADDRESS,
	MR_EVT_ARGS_BITMAP,
	MR_EVT_ARGS_CONNECTOR,
	MR_EVT_ARGS_PD_PD,
	MR_EVT_ARGS_PD_FRU,
	MR_EVT_ARGS_PD_PATHINFO,
	MR_EVT_ARGS_PD_POWER_STATE,
	MR_EVT_ARGS_GENERIC,
};

/*
 * define constants for device list query options
 */
enum MR_PD_QUERY_TYPE {
	MR_PD_QUERY_TYPE_ALL                = 0,
	MR_PD_QUERY_TYPE_STATE              = 1,
	MR_PD_QUERY_TYPE_POWER_STATE        = 2,
	MR_PD_QUERY_TYPE_MEDIA_TYPE         = 3,
	MR_PD_QUERY_TYPE_SPEED              = 4,
	MR_PD_QUERY_TYPE_EXPOSED_TO_HOST    = 5,
};

#define MR_EVT_CFG_CLEARED                              0x0004
#define MR_EVT_LD_STATE_CHANGE                          0x0051
#define MR_EVT_PD_INSERTED                              0x005b
#define MR_EVT_PD_REMOVED                               0x0070
#define MR_EVT_LD_CREATED                               0x008a
#define MR_EVT_LD_DELETED                               0x008b
#define MR_EVT_FOREIGN_CFG_IMPORTED                     0x00db
#define MR_EVT_LD_OFFLINE                               0x00fc
#define MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED             0x0152
#define MAX_LOGICAL_DRIVES				64

enum MR_PD_STATE {
	MR_PD_STATE_UNCONFIGURED_GOOD   = 0x00,
	MR_PD_STATE_UNCONFIGURED_BAD    = 0x01,
	MR_PD_STATE_HOT_SPARE           = 0x02,
	MR_PD_STATE_OFFLINE             = 0x10,
	MR_PD_STATE_FAILED              = 0x11,
	MR_PD_STATE_REBUILD             = 0x14,
	MR_PD_STATE_ONLINE              = 0x18,
	MR_PD_STATE_COPYBACK            = 0x20,
	MR_PD_STATE_SYSTEM              = 0x40,
 };


 /*
 * defines the physical drive address structure
 */
struct MR_PD_ADDRESS {
	u16     deviceId;
	u16     enclDeviceId;

	union {
		struct {
			u8  enclIndex;
			u8  slotNumber;
		} mrPdAddress;
		struct {
			u8  enclPosition;
			u8  enclConnectorIndex;
		} mrEnclAddress;
	};
	u8      scsiDevType;
	union {
		u8      connectedPortBitmap;
		u8      connectedPortNumbers;
	};
	u64     sasAddr[2];
} __packed;

/*
 * defines the physical drive list structure
 */
struct MR_PD_LIST {
	u32             size;
	u32             count;
	struct MR_PD_ADDRESS   addr[1];
} __packed;

struct megasas_pd_list {
	u16             tid;
	u8             driveType;
	u8             driveState;
} __packed;

 /*
 * defines the logical drive reference structure
 */
union  MR_LD_REF {
	struct {
		u8      targetId;
		u8      reserved;
		u16     seqNum;
	};
	u32     ref;
} __packed;

/*
 * defines the logical drive list structure
 */
struct MR_LD_LIST {
	u32     ldCount;
	u32     reserved;
	struct {
		union MR_LD_REF   ref;
		u8          state;
		u8          reserved[3];
		u64         size;
	} ldList[MAX_LOGICAL_DRIVES];
} __packed;

/*
 * SAS controller properties
 */
struct megasas_ctrl_prop {

	u16 seq_num;
	u16 pred_fail_poll_interval;
	u16 intr_throttle_count;
	u16 intr_throttle_timeouts;
	u8 rebuild_rate;
	u8 patrol_read_rate;
	u8 bgi_rate;
	u8 cc_rate;
	u8 recon_rate;
	u8 cache_flush_interval;
	u8 spinup_drv_count;
	u8 spinup_delay;
	u8 cluster_enable;
	u8 coercion_mode;
	u8 alarm_enable;
	u8 disable_auto_rebuild;
	u8 disable_battery_warn;
	u8 ecc_bucket_size;
	u16 ecc_bucket_leak_rate;
	u8 restore_hotspare_on_insertion;
	u8 expose_encl_devices;
	u8 maintainPdFailHistory;
	u8 disallowHostRequestReordering;
	u8 abortCCOnError;
	u8 loadBalanceMode;
	u8 disableAutoDetectBackplane;

	u8 snapVDSpace;

	/*
	* Add properties that can be controlled by
	* a bit in the following structure.
	*/

	struct {
		u32     copyBackDisabled            : 1;
		u32     SMARTerEnabled              : 1;
		u32     prCorrectUnconfiguredAreas  : 1;
		u32     useFdeOnly                  : 1;
		u32     disableNCQ                  : 1;
		u32     SSDSMARTerEnabled           : 1;
		u32     SSDPatrolReadEnabled        : 1;
		u32     enableSpinDownUnconfigured  : 1;
		u32     autoEnhancedImport          : 1;
		u32     enableSecretKeyControl      : 1;
		u32     disableOnlineCtrlReset      : 1;
		u32     allowBootWithPinnedCache    : 1;
		u32     disableSpinDownHS           : 1;
		u32     enableJBOD                  : 1;
		u32     reserved                    :18;
	} OnOffProperties;
	u8 autoSnapVDSpace;
	u8 viewSpace;
	u16 spinDownTime;
	u8  reserved[24];
} __packed;

/*
 * SAS controller information
 */
struct megasas_ctrl_info {

	/*
	 * PCI device information
	 */
	struct {

		u16 vendor_id;
		u16 device_id;
		u16 sub_vendor_id;
		u16 sub_device_id;
		u8 reserved[24];

	} __attribute__ ((packed)) pci;

	/*
	 * Host interface information
	 */
	struct {

		u8 PCIX:1;
		u8 PCIE:1;
		u8 iSCSI:1;
		u8 SAS_3G:1;
		u8 reserved_0:4;
		u8 reserved_1[6];
		u8 port_count;
		u64 port_addr[8];

	} __attribute__ ((packed)) host_interface;

	/*
	 * Device (backend) interface information
	 */
	struct {

		u8 SPI:1;
		u8 SAS_3G:1;
		u8 SATA_1_5G:1;
		u8 SATA_3G:1;
		u8 reserved_0:4;
		u8 reserved_1[6];
		u8 port_count;
		u64 port_addr[8];

	} __attribute__ ((packed)) device_interface;

	/*
	 * List of components residing in flash. All str are null terminated
	 */
	u32 image_check_word;
	u32 image_component_count;

	struct {

		char name[8];
		char version[32];
		char build_date[16];
		char built_time[16];

	} __attribute__ ((packed)) image_component[8];

	/*
	 * List of flash components that have been flashed on the card, but
	 * are not in use, pending reset of the adapter. This list will be
	 * empty if a flash operation has not occurred. All stings are null
	 * terminated
	 */
	u32 pending_image_component_count;

	struct {

		char name[8];
		char version[32];
		char build_date[16];
		char build_time[16];

	} __attribute__ ((packed)) pending_image_component[8];

	u8 max_arms;
	u8 max_spans;
	u8 max_arrays;
	u8 max_lds;

	char product_name[80];
	char serial_no[32];

	/*
	 * Other physical/controller/operation information. Indicates the
	 * presence of the hardware
	 */
	struct {

		u32 bbu:1;
		u32 alarm:1;
		u32 nvram:1;
		u32 uart:1;
		u32 reserved:28;

	} __attribute__ ((packed)) hw_present;

	u32 current_fw_time;

	/*
	 * Maximum data transfer sizes
	 */
	u16 max_concurrent_cmds;
	u16 max_sge_count;
	u32 max_request_size;

	/*
	 * Logical and physical device counts
	 */
	u16 ld_present_count;
	u16 ld_degraded_count;
	u16 ld_offline_count;

	u16 pd_present_count;
	u16 pd_disk_present_count;
	u16 pd_disk_pred_failure_count;
	u16 pd_disk_failed_count;

	/*
	 * Memory size information
	 */
	u16 nvram_size;
	u16 memory_size;
	u16 flash_size;

	/*
	 * Error counters
	 */
	u16 mem_correctable_error_count;
	u16 mem_uncorrectable_error_count;

	/*
	 * Cluster information
	 */
	u8 cluster_permitted;
	u8 cluster_active;

	/*
	 * Additional max data transfer sizes
	 */
	u16 max_strips_per_io;

	/*
	 * Controller capabilities structures
	 */
	struct {

		u32 raid_level_0:1;
		u32 raid_level_1:1;
		u32 raid_level_5:1;
		u32 raid_level_1E:1;
		u32 raid_level_6:1;
		u32 reserved:27;

	} __attribute__ ((packed)) raid_levels;

	struct {

		u32 rbld_rate:1;
		u32 cc_rate:1;
		u32 bgi_rate:1;
		u32 recon_rate:1;
		u32 patrol_rate:1;
		u32 alarm_control:1;
		u32 cluster_supported:1;
		u32 bbu:1;
		u32 spanning_allowed:1;
		u32 dedicated_hotspares:1;
		u32 revertible_hotspares:1;
		u32 foreign_config_import:1;
		u32 self_diagnostic:1;
		u32 mixed_redundancy_arr:1;
		u32 global_hot_spares:1;
		u32 reserved:17;

	} __attribute__ ((packed)) adapter_operations;

	struct {

		u32 read_policy:1;
		u32 write_policy:1;
		u32 io_policy:1;
		u32 access_policy:1;
		u32 disk_cache_policy:1;
		u32 reserved:27;

	} __attribute__ ((packed)) ld_operations;

	struct {

		u8 min;
		u8 max;
		u8 reserved[2];

	} __attribute__ ((packed)) stripe_sz_ops;

	struct {

		u32 force_online:1;
		u32 force_offline:1;
		u32 force_rebuild:1;
		u32 reserved:29;

	} __attribute__ ((packed)) pd_operations;

	struct {

		u32 ctrl_supports_sas:1;
		u32 ctrl_supports_sata:1;
		u32 allow_mix_in_encl:1;
		u32 allow_mix_in_ld:1;
		u32 allow_sata_in_cluster:1;
		u32 reserved:27;

	} __attribute__ ((packed)) pd_mix_support;

	/*
	 * Define ECC single-bit-error bucket information
	 */
	u8 ecc_bucket_count;
	u8 reserved_2[11];

	/*
	 * Include the controller properties (changeable items)
	 */
	struct megasas_ctrl_prop properties;

	/*
	 * Define FW pkg version (set in envt v'bles on OEM basis)
	 */
	char package_version[0x60];

	u8 pad[0x800 - 0x6a0];

} __packed;

/*
 * ===============================
 * MegaRAID SAS driver definitions
 * ===============================
 */
#define MEGASAS_MAX_PD_CHANNELS			2
#define MEGASAS_MAX_LD_CHANNELS			2
#define MEGASAS_MAX_CHANNELS			(MEGASAS_MAX_PD_CHANNELS + \
						MEGASAS_MAX_LD_CHANNELS)
#define MEGASAS_MAX_DEV_PER_CHANNEL		128
#define MEGASAS_DEFAULT_INIT_ID			-1
#define MEGASAS_MAX_LUN				8
#define MEGASAS_MAX_LD				64
#define MEGASAS_MAX_PD                          (MEGASAS_MAX_PD_CHANNELS * \
						MEGASAS_MAX_DEV_PER_CHANNEL)
#define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
						MEGASAS_MAX_DEV_PER_CHANNEL)

#define MEGASAS_MAX_SECTORS                    (2*1024)
#define MEGASAS_DBG_LVL				1

#define MEGASAS_FW_BUSY				1

/* Frame Type */
#define IO_FRAME				0
#define PTHRU_FRAME				1

/*
 * When SCSI mid-layer calls driver's reset routine, driver waits for
 * MEGASAS_RESET_WAIT_TIME seconds for all outstanding IO to complete. Note
 * that the driver cannot _actually_ abort or reset pending commands. While
 * it is waiting for the commands to complete, it prints a diagnostic message
 * every MEGASAS_RESET_NOTICE_INTERVAL seconds
 */
#define MEGASAS_RESET_WAIT_TIME			180
#define MEGASAS_INTERNAL_CMD_WAIT_TIME		180
#define	MEGASAS_RESET_NOTICE_INTERVAL		5
#define MEGASAS_IOCTL_CMD			0
#define MEGASAS_DEFAULT_CMD_TIMEOUT		90

/*
 * FW reports the maximum of number of commands that it can accept (maximum
 * commands that can be outstanding) at any time. The driver must report a
 * lower number to the mid layer because it can issue a few internal commands
 * itself (E.g, AEN, abort cmd, IOCTLs etc). The number of commands it needs
 * is shown below
 */
#define MEGASAS_INT_CMDS			32
#define MEGASAS_SKINNY_INT_CMDS			5

/*
 * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
 * SGLs based on the size of dma_addr_t
 */
#define IS_DMA64				(sizeof(dma_addr_t) == 8)

#define MFI_XSCALE_OMR0_CHANGE_INTERRUPT		0x00000001

#define MFI_INTR_FLAG_REPLY_MESSAGE			0x00000001
#define MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE		0x00000002
#define MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT	0x00000004

#define MFI_OB_INTR_STATUS_MASK			0x00000002
#define MFI_POLL_TIMEOUT_SECS			60
#define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)

#define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
#define MFI_REPLY_GEN2_MESSAGE_INTERRUPT	0x00000001
#define MFI_GEN2_ENABLE_INTERRUPT_MASK		(0x00000001 | 0x00000004)
#define MFI_REPLY_SKINNY_MESSAGE_INTERRUPT	0x40000000
#define MFI_SKINNY_ENABLE_INTERRUPT_MASK	(0x00000001)

#define MFI_1068_PCSR_OFFSET			0x84
#define MFI_1068_FW_HANDSHAKE_OFFSET		0x64
#define MFI_1068_FW_READY			0xDDDD0000
/*
* register set for both 1068 and 1078 controllers
* structure extended for 1078 registers
*/
 
struct megasas_register_set {
	u32 	reserved_0[4];			/*0000h*/

	u32 	inbound_msg_0;			/*0010h*/
	u32 	inbound_msg_1;			/*0014h*/
	u32 	outbound_msg_0;			/*0018h*/
	u32 	outbound_msg_1;			/*001Ch*/

	u32 	inbound_doorbell;		/*0020h*/
	u32 	inbound_intr_status;		/*0024h*/
	u32 	inbound_intr_mask;		/*0028h*/

	u32 	outbound_doorbell;		/*002Ch*/
	u32 	outbound_intr_status;		/*0030h*/
	u32 	outbound_intr_mask;		/*0034h*/

	u32 	reserved_1[2];			/*0038h*/

	u32 	inbound_queue_port;		/*0040h*/
	u32 	outbound_queue_port;		/*0044h*/

	u32 	reserved_2[22];			/*0048h*/

	u32 	outbound_doorbell_clear;	/*00A0h*/

	u32 	reserved_3[3];			/*00A4h*/

	u32 	outbound_scratch_pad ;		/*00B0h*/

	u32 	reserved_4[3];			/*00B4h*/

	u32 	inbound_low_queue_port ;	/*00C0h*/

	u32 	inbound_high_queue_port ;	/*00C4h*/

	u32 	reserved_5;			/*00C8h*/
	u32	res_6[11];			/*CCh*/
	u32	host_diag;
	u32	seq_offset;
	u32 	index_registers[807];		/*00CCh*/
} __attribute__ ((packed));

struct megasas_sge32 {

	u32 phys_addr;
	u32 length;

} __attribute__ ((packed));

struct megasas_sge64 {

	u64 phys_addr;
	u32 length;

} __attribute__ ((packed));

struct megasas_sge_skinny {
	u64 phys_addr;
	u32 length;
	u32 flag;
} __packed;

union megasas_sgl {

	struct megasas_sge32 sge32[1];
	struct megasas_sge64 sge64[1];
	struct megasas_sge_skinny sge_skinny[1];

} __attribute__ ((packed));

struct megasas_header {

	u8 cmd;			/*00h */
	u8 sense_len;		/*01h */
	u8 cmd_status;		/*02h */
	u8 scsi_status;		/*03h */

	u8 target_id;		/*04h */
	u8 lun;			/*05h */
	u8 cdb_len;		/*06h */
	u8 sge_count;		/*07h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 timeout;		/*12h */
	u32 data_xferlen;	/*14h */

} __attribute__ ((packed));

union megasas_sgl_frame {

	struct megasas_sge32 sge32[8];
	struct megasas_sge64 sge64[5];

} __attribute__ ((packed));

struct megasas_init_frame {

	u8 cmd;			/*00h */
	u8 reserved_0;		/*01h */
	u8 cmd_status;		/*02h */

	u8 reserved_1;		/*03h */
	u32 reserved_2;		/*04h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 reserved_3;		/*12h */
	u32 data_xfer_len;	/*14h */

	u32 queue_info_new_phys_addr_lo;	/*18h */
	u32 queue_info_new_phys_addr_hi;	/*1Ch */
	u32 queue_info_old_phys_addr_lo;	/*20h */
	u32 queue_info_old_phys_addr_hi;	/*24h */

	u32 reserved_4[6];	/*28h */

} __attribute__ ((packed));

struct megasas_init_queue_info {

	u32 init_flags;		/*00h */
	u32 reply_queue_entries;	/*04h */

	u32 reply_queue_start_phys_addr_lo;	/*08h */
	u32 reply_queue_start_phys_addr_hi;	/*0Ch */
	u32 producer_index_phys_addr_lo;	/*10h */
	u32 producer_index_phys_addr_hi;	/*14h */
	u32 consumer_index_phys_addr_lo;	/*18h */
	u32 consumer_index_phys_addr_hi;	/*1Ch */

} __attribute__ ((packed));

struct megasas_io_frame {

	u8 cmd;			/*00h */
	u8 sense_len;		/*01h */
	u8 cmd_status;		/*02h */
	u8 scsi_status;		/*03h */

	u8 target_id;		/*04h */
	u8 access_byte;		/*05h */
	u8 reserved_0;		/*06h */
	u8 sge_count;		/*07h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 timeout;		/*12h */
	u32 lba_count;		/*14h */

	u32 sense_buf_phys_addr_lo;	/*18h */
	u32 sense_buf_phys_addr_hi;	/*1Ch */

	u32 start_lba_lo;	/*20h */
	u32 start_lba_hi;	/*24h */

	union megasas_sgl sgl;	/*28h */

} __attribute__ ((packed));

struct megasas_pthru_frame {

	u8 cmd;			/*00h */
	u8 sense_len;		/*01h */
	u8 cmd_status;		/*02h */
	u8 scsi_status;		/*03h */

	u8 target_id;		/*04h */
	u8 lun;			/*05h */
	u8 cdb_len;		/*06h */
	u8 sge_count;		/*07h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 timeout;		/*12h */
	u32 data_xfer_len;	/*14h */

	u32 sense_buf_phys_addr_lo;	/*18h */
	u32 sense_buf_phys_addr_hi;	/*1Ch */

	u8 cdb[16];		/*20h */
	union megasas_sgl sgl;	/*30h */

} __attribute__ ((packed));

struct megasas_dcmd_frame {

	u8 cmd;			/*00h */
	u8 reserved_0;		/*01h */
	u8 cmd_status;		/*02h */
	u8 reserved_1[4];	/*03h */
	u8 sge_count;		/*07h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 timeout;		/*12h */

	u32 data_xfer_len;	/*14h */
	u32 opcode;		/*18h */

	union {			/*1Ch */
		u8 b[12];
		u16 s[6];
		u32 w[3];
	} mbox;

	union megasas_sgl sgl;	/*28h */

} __attribute__ ((packed));

struct megasas_abort_frame {

	u8 cmd;			/*00h */
	u8 reserved_0;		/*01h */
	u8 cmd_status;		/*02h */

	u8 reserved_1;		/*03h */
	u32 reserved_2;		/*04h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 reserved_3;		/*12h */
	u32 reserved_4;		/*14h */

	u32 abort_context;	/*18h */
	u32 pad_1;		/*1Ch */

	u32 abort_mfi_phys_addr_lo;	/*20h */
	u32 abort_mfi_phys_addr_hi;	/*24h */

	u32 reserved_5[6];	/*28h */

} __attribute__ ((packed));

struct megasas_smp_frame {

	u8 cmd;			/*00h */
	u8 reserved_1;		/*01h */
	u8 cmd_status;		/*02h */
	u8 connection_status;	/*03h */

	u8 reserved_2[3];	/*04h */
	u8 sge_count;		/*07h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 timeout;		/*12h */

	u32 data_xfer_len;	/*14h */
	u64 sas_addr;		/*18h */

	union {
		struct megasas_sge32 sge32[2];	/* [0]: resp [1]: req */
		struct megasas_sge64 sge64[2];	/* [0]: resp [1]: req */
	} sgl;

} __attribute__ ((packed));

struct megasas_stp_frame {

	u8 cmd;			/*00h */
	u8 reserved_1;		/*01h */
	u8 cmd_status;		/*02h */
	u8 reserved_2;		/*03h */

	u8 target_id;		/*04h */
	u8 reserved_3[2];	/*05h */
	u8 sge_count;		/*07h */

	u32 context;		/*08h */
	u32 pad_0;		/*0Ch */

	u16 flags;		/*10h */
	u16 timeout;		/*12h */

	u32 data_xfer_len;	/*14h */

	u16 fis[10];		/*18h */
	u32 stp_flags;

	union {
		struct megasas_sge32 sge32[2];	/* [0]: resp [1]: data */
		struct megasas_sge64 sge64[2];	/* [0]: resp [1]: data */
	} sgl;

} __attribute__ ((packed));

union megasas_frame {

	struct megasas_header hdr;
	struct megasas_init_frame init;
	struct megasas_io_frame io;
	struct megasas_pthru_frame pthru;
	struct megasas_dcmd_frame dcmd;
	struct megasas_abort_frame abort;
	struct megasas_smp_frame smp;
	struct megasas_stp_frame stp;

	u8 raw_bytes[64];
};

struct megasas_cmd;

union megasas_evt_class_locale {

	struct {
		u16 locale;
		u8 reserved;
		s8 class;
	} __attribute__ ((packed)) members;

	u32 word;

} __attribute__ ((packed));

struct megasas_evt_log_info {
	u32 newest_seq_num;
	u32 oldest_seq_num;
	u32 clear_seq_num;
	u32 shutdown_seq_num;
	u32 boot_seq_num;

} __attribute__ ((packed));

struct megasas_progress {

	u16 progress;
	u16 elapsed_seconds;

} __attribute__ ((packed));

struct megasas_evtarg_ld {

	u16 target_id;
	u8 ld_index;
	u8 reserved;

} __attribute__ ((packed));

struct megasas_evtarg_pd {
	u16 device_id;
	u8 encl_index;
	u8 slot_number;

} __attribute__ ((packed));

struct megasas_evt_detail {

	u32 seq_num;
	u32 time_stamp;
	u32 code;
	union megasas_evt_class_locale cl;
	u8 arg_type;
	u8 reserved1[15];

	union {
		struct {
			struct megasas_evtarg_pd pd;
			u8 cdb_length;
			u8 sense_length;
			u8 reserved[2];
			u8 cdb[16];
			u8 sense[64];
		} __attribute__ ((packed)) cdbSense;

		struct megasas_evtarg_ld ld;

		struct {
			struct megasas_evtarg_ld ld;
			u64 count;
		} __attribute__ ((packed)) ld_count;

		struct {
			u64 lba;
			struct megasas_evtarg_ld ld;
		} __attribute__ ((packed)) ld_lba;

		struct {
			struct megasas_evtarg_ld ld;
			u32 prevOwner;
			u32 newOwner;
		} __attribute__ ((packed)) ld_owner;

		struct {
			u64 ld_lba;
			u64 pd_lba;
			struct megasas_evtarg_ld ld;
			struct megasas_evtarg_pd pd;
		} __attribute__ ((packed)) ld_lba_pd_lba;

		struct {
			struct megasas_evtarg_ld ld;
			struct megasas_progress prog;
		} __attribute__ ((packed)) ld_prog;

		struct {
			struct megasas_evtarg_ld ld;
			u32 prev_state;
			u32 new_state;
		} __attribute__ ((packed)) ld_state;

		struct {
			u64 strip;
			struct megasas_evtarg_ld ld;
		} __attribute__ ((packed)) ld_strip;

		struct megasas_evtarg_pd pd;

		struct {
			struct megasas_evtarg_pd pd;
			u32 err;
		} __attribute__ ((packed)) pd_err;

		struct {
			u64 lba;
			struct megasas_evtarg_pd pd;
		} __attribute__ ((packed)) pd_lba;

		struct {
			u64 lba;
			struct megasas_evtarg_pd pd;
			struct megasas_evtarg_ld ld;
		} __attribute__ ((packed)) pd_lba_ld;

		struct {
			struct megasas_evtarg_pd pd;
			struct megasas_progress prog;
		} __attribute__ ((packed)) pd_prog;

		struct {
			struct megasas_evtarg_pd pd;
			u32 prevState;
			u32 newState;
		} __attribute__ ((packed)) pd_state;

		struct {
			u16 vendorId;
			u16 deviceId;
			u16 subVendorId;
			u16 subDeviceId;
		} __attribute__ ((packed)) pci;

		u32 rate;
		char str[96];

		struct {
			u32 rtc;
			u32 elapsedSeconds;
		} __attribute__ ((packed)) time;

		struct {
			u32 ecar;
			u32 elog;
			char str[64];
		} __attribute__ ((packed)) ecc;

		u8 b[96];
		u16 s[48];
		u32 w[24];
		u64 d[12];
	} args;

	char description[128];

} __attribute__ ((packed));

struct megasas_aen_event {
	struct work_struct hotplug_work;
	struct megasas_instance *instance;
};

struct megasas_instance {

	u32 *producer;
	dma_addr_t producer_h;
	u32 *consumer;
	dma_addr_t consumer_h;

	u32 *reply_queue;
	dma_addr_t reply_queue_h;

	unsigned long base_addr;
	struct megasas_register_set __iomem *reg_set;

	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
	u8     ld_ids[MEGASAS_MAX_LD_IDS];
	s8 init_id;

	u16 max_num_sge;
	u16 max_fw_cmds;
	u32 max_sectors_per_req;
	struct megasas_aen_event *ev;

	struct megasas_cmd **cmd_list;
	struct list_head cmd_pool;
	/* used to sync fire the cmd to fw */
	spinlock_t cmd_pool_lock;
	/* used to sync fire the cmd to fw */
	spinlock_t hba_lock;
	/* used to synch producer, consumer ptrs in dpc */
	spinlock_t completion_lock;
	struct dma_pool *frame_dma_pool;
	struct dma_pool *sense_dma_pool;

	struct megasas_evt_detail *evt_detail;
	dma_addr_t evt_detail_h;
	struct megasas_cmd *aen_cmd;
	struct mutex aen_mutex;
	struct semaphore ioctl_sem;

	struct Scsi_Host *host;

	wait_queue_head_t int_cmd_wait_q;
	wait_queue_head_t abort_cmd_wait_q;

	struct pci_dev *pdev;
	u32 unique_id;
	u32 fw_support_ieee;

	atomic_t fw_outstanding;
	atomic_t fw_reset_no_pci_access;

	struct megasas_instance_template *instancet;
	struct tasklet_struct isr_tasklet;
	struct work_struct work_init;

	u8 flag;
	u8 unload;
	u8 flag_ieee;
	u8 issuepend_done;
	u8 disableOnlineCtrlReset;
	u8 adprecovery;
	unsigned long last_time;
	u32 mfiStatus;
	u32 last_seq_num;

	struct timer_list io_completion_timer;
	struct list_head internal_reset_pending_q;
};

enum {
	MEGASAS_HBA_OPERATIONAL			= 0,
	MEGASAS_ADPRESET_SM_INFAULT		= 1,
	MEGASAS_ADPRESET_SM_FW_RESET_SUCCESS	= 2,
	MEGASAS_ADPRESET_SM_OPERATIONAL		= 3,
	MEGASAS_HW_CRITICAL_ERROR		= 4,
	MEGASAS_ADPRESET_INPROG_SIGN		= 0xDEADDEAD,
};

struct megasas_instance_template {
	void (*fire_cmd)(struct megasas_instance *, dma_addr_t, \
		u32, struct megasas_register_set __iomem *);

	void (*enable_intr)(struct megasas_register_set __iomem *) ;
	void (*disable_intr)(struct megasas_register_set __iomem *);

	int (*clear_intr)(struct megasas_register_set __iomem *);

	u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
	int (*adp_reset)(struct megasas_instance *, \
		struct megasas_register_set __iomem *);
	int (*check_reset)(struct megasas_instance *, \
		struct megasas_register_set __iomem *);
};

#define MEGASAS_IS_LOGICAL(scp)						\
	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1

#define MEGASAS_DEV_INDEX(inst, scp)					\
	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + 	\
	scp->device->id

struct megasas_cmd {

	union megasas_frame *frame;
	dma_addr_t frame_phys_addr;
	u8 *sense;
	dma_addr_t sense_phys_addr;

	u32 index;
	u8 sync_cmd;
	u8 cmd_status;
	u8 abort_aen;
	u8 retry_for_fw_reset;


	struct list_head list;
	struct scsi_cmnd *scmd;
	struct megasas_instance *instance;
	u32 frame_count;
};

#define MAX_MGMT_ADAPTERS		1024
#define MAX_IOCTL_SGE			16

struct megasas_iocpacket {

	u16 host_no;
	u16 __pad1;
	u32 sgl_off;
	u32 sge_count;
	u32 sense_off;
	u32 sense_len;
	union {
		u8 raw[128];
		struct megasas_header hdr;
	} frame;

	struct iovec sgl[MAX_IOCTL_SGE];

} __attribute__ ((packed));

struct megasas_aen {
	u16 host_no;
	u16 __pad1;
	u32 seq_num;
	u32 class_locale_word;
} __attribute__ ((packed));

#ifdef CONFIG_COMPAT
struct compat_megasas_iocpacket {
	u16 host_no;
	u16 __pad1;
	u32 sgl_off;
	u32 sge_count;
	u32 sense_off;
	u32 sense_len;
	union {
		u8 raw[128];
		struct megasas_header hdr;
	} frame;
	struct compat_iovec sgl[MAX_IOCTL_SGE];
} __attribute__ ((packed));

#define MEGASAS_IOC_FIRMWARE32	_IOWR('M', 1, struct compat_megasas_iocpacket)
#endif

#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
#define MEGASAS_IOC_GET_AEN	_IOW('M', 3, struct megasas_aen)

struct megasas_mgmt_info {

	u16 count;
	struct megasas_instance *instance[MAX_MGMT_ADAPTERS];
	int max_index;
};

#endif				/*LSI_MEGARAID_SAS_H */

--------------020409020608080801030505
Content-Type: text/plain;
 name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33.2
# Wed Jun 16 09:35:38 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
CONFIG_BNX2=m
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=m
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=0
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--------------020409020608080801030505--
