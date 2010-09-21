From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
Date: Tue, 21 Sep 2010 08:09:04 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C30100D3049A@cosmail02.lsi.com>
References: <4C690D09.70908@news-service.com>
 <4B6A08C587958942AA3002690DD4F8C3DBE62B40@cosmail02.lsi.com>
 <4C6A52AA.9040303@news-service.com> <4C710F55.3020302@news-service.com>
 <4B6A08C587958942AA3002690DD4F8C3DBEF4AD0@cosmail02.lsi.com>
 <4C85EF47.70006@news-service.com>
 <4B6A08C587958942AA3002690DD4F8C3DC054965@cosmail02.lsi.com>
 <4C8659C8.50905@news-service.com> <4C970D9E.3090706@news-service.com>
 <4C986069.1080202@news-service.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35524 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab0IUOJR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 10:09:17 -0400
In-Reply-To: <4C986069.1080202@news-service.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Reinier Haasjes' <reinier@news-service.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MegaRAID Linux <megaraidlinux@lsi.com>

Reinier,

I am looking at this issue will give you back soon.

Regards,

Bo Yang

-----Original Message-----
From: Reinier Haasjes [mailto:reinier@news-service.com]
Sent: Tuesday, September 21, 2010 3:36 AM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; DL-MegaRAID Linux
Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a

Bo,

got another OOPS:

Sep 21 09:21:17 sd43 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
Sep 21 09:21:17 sd43 kernel: IP: [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
Sep 21 09:21:17 sd43 kernel: PGD 0
Sep 21 09:21:17 sd43 kernel: Oops: 0000 [#1] SMP
Sep 21 09:21:17 sd43 kernel: last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Sep 21 09:21:17 sd43 kernel: CPU 7
Sep 21 09:21:17 sd43 kernel: Pid: 26, comm: events/7 Not tainted 2.6.33.2-mr431 #7 086HF8/PowerEdge R610
Sep 21 09:21:17 sd43 kernel: RIP: 0010:[<ffffffff811bb1d1>]  [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
Sep 21 09:21:17 sd43 kernel: RSP: 0018:ffff880c7cce1d80  EFLAGS: 00010286
Sep 21 09:21:17 sd43 kernel: RAX: 00000000ffffffff RBX: 0000000000000000 RCX: ffff880c7cda13e8
Sep 21 09:21:17 sd43 kernel: RDX: ffff88007f248400 RSI: 0000000000000282 RDI: ffff880c7cdb0400
Sep 21 09:21:17 sd43 kernel: RBP: ffff880c7cda13c0 R08: ffff880c7cce0000 R09: 0000000000000000
Sep 21 09:21:17 sd43 kernel: R10: 0000040100000000 R11: ffffffff811e9a98 R12: ffff880c7cdb0400
Sep 21 09:21:17 sd43 kernel: R13: 00000000fe00ffff R14: 0000000000000005 R15: ffff88067cc743c8
Sep 21 09:21:17 sd43 kernel: FS:  0000000000000000(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
Sep 21 09:21:17 sd43 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 21 09:21:17 sd43 kernel: CR2: 0000000000000020 CR3: 000000000134a000 CR4: 00000000000006e0
Sep 21 09:21:17 sd43 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep 21 09:21:17 sd43 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 21 09:21:17 sd43 kernel: Process events/7 (pid: 26, threadinfo ffff880c7cce0000, task ffff88067cc740a0)
Sep 21 09:21:17 sd43 kernel: Stack:
Sep 21 09:21:17 sd43 kernel: ffff880c7cce0000 ffff88007f21a800 00000000fe00ffff 0000000000000000
Sep 21 09:21:17 sd43 kernel: <0> 0000000000000005 ffff880c7cd9e420 ffffffffffffffae ffff880c7cdb09a8
Sep 21 09:21:17 sd43 kernel: <0> ffff880c7cdb0400 ffff88067cc740a0 00000000fe00ffff ffffffff811bb44c
Sep 21 09:21:17 sd43 kernel: Call Trace:
Sep 21 09:21:17 sd43 kernel: [<ffffffff811bb44c>] ? megasas_register_aen+0x7c/0x19c
Sep 21 09:21:17 sd43 kernel: [<ffffffff811bd320>] ? megasas_aen_polling+0x3ab/0x3ff
Sep 21 09:21:17 sd43 kernel: [<ffffffff811bcf75>] ? megasas_aen_polling+0x0/0x3ff
Sep 21 09:21:17 sd43 kernel: [<ffffffff81039fa2>] ? worker_thread+0xf5/0x179
Sep 21 09:21:17 sd43 kernel: [<ffffffff8103ce42>] ? autoremove_wake_function+0x0/0x2e
Sep 21 09:21:17 sd43 kernel: [<ffffffff81039ead>] ? worker_thread+0x0/0x179
Sep 21 09:21:17 sd43 kernel: [<ffffffff8103ca71>] ? kthread+0x79/0x81
Sep 21 09:21:17 sd43 kernel: [<ffffffff81002c14>] ? kernel_thread_helper+0x4/0x10
Sep 21 09:21:17 sd43 kernel: [<ffffffff8103c9f8>] ? kthread+0x0/0x81
Sep 21 09:21:17 sd43 kernel: [<ffffffff81002c10>] ? kernel_thread_helper+0x0/0x10
Sep 21 09:21:17 sd43 kernel: Code: 83 ec 38 e8 21 fb ff ff 48 89 c5 83 c8 ff 48 85 ed 0f 84 fd 00 00 00 48 8b 55 00 4c 89 e7 c6 02 06 c6 42 02 ff 66 c7 42 10 00 00 <8b> 43 20 89 42 18 48 8b 43 08 c7 42 24 00 00 00 00 89 42 20 c6
Sep 21 09:21:17 sd43 kernel: RIP  [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
Sep 21 09:21:17 sd43 kernel: RSP <ffff880c7cce1d80>
Sep 21 09:21:17 sd43 kernel: CR2: 0000000000000020
Sep 21 09:21:17 sd43 kernel: ---[ end trace 0cab3614adf6d9f6 ]---

Best regards,

Reinier

On 20-09-10 09:30, Reinier Haasjes wrote:
> Bo,
>
> Any news on this?
>
> Best Regards,
> Reinier
>
> On 07-09-10 17:27, Reinier Haasjes wrote:
>> Bo,
>>
>> I used the standard 2.6.33.2 kernel source from kernels.org and
>> overwrote these with the driver sources I got from you (attached again).
>> I also attached the config file I used.
>>
>> Best Regards,
>> Reinier
>>
>> On 09/07/2010 03:19 PM, Yang, Bo wrote:
>>> Reinier,
>>>
>>> Can you send me the src you used in this server?
>>>
>>> Thanks,
>>>
>>> Bo Yang
>>>
>>> -----Original Message-----
>>> From: Reinier Haasjes [mailto:reinier@news-service.com]
>>> Sent: Tuesday, September 07, 2010 3:53 AM
>>> To: Yang, Bo
>>> Cc: linux-scsi@vger.kernel.org; DL-MegaRAID Linux
>>> Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>
>>> Hi,
>>>
>>> I installed the driver on a production server and after 13 days we got an OOPS:
>>>
>>> Sep  6 21:19:00 sd43 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>>> Sep  6 21:19:00 sd43 kernel: IP: [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
>>> Sep  6 21:19:00 sd43 kernel: PGD 0
>>> Sep  6 21:19:00 sd43 kernel: Oops: 0000 [#1] SMP
>>> Sep  6 21:19:00 sd43 kernel: last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
>>> Sep  6 21:19:00 sd43 kernel: CPU 0
>>> Sep  6 21:19:00 sd43 kernel: Pid: 19, comm: events/0 Not tainted 2.6.33.2-mr431 #7 086HF8/PowerEdge R610
>>> Sep  6 21:19:00 sd43 kernel: RIP: 0010:[<ffffffff811bb1d1>]  [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
>>> Sep  6 21:19:00 sd43 kernel: RSP: 0000:ffff880c7ccbfd80  EFLAGS: 00010282
>>> Sep  6 21:19:00 sd43 kernel: RAX: 00000000ffffffff RBX: 0000000000000000 RCX: ffff88067cd1be68
>>> Sep  6 21:19:00 sd43 kernel: RDX: ffff88007f29f800 RSI: 0000000000000282 RDI: ffff880c7cdd8400
>>> Sep  6 21:19:00 sd43 kernel: RBP: ffff88067cd1be40 R08: ffff880c7ccbe000 R09: 00000000ffffffff
>>> Sep  6 21:19:00 sd43 kernel: R10: 0000040100000000 R11: ffffffff811e9a98 R12: ffff880c7cdd8400
>>> Sep  6 21:19:00 sd43 kernel: R13: 00000000fe00ffff R14: 0000000000000001 R15: ffff880c7ccb1aa8
>>> Sep  6 21:19:00 sd43 kernel: FS:  0000000000000000(0000) GS:ffff880695400000(0000) knlGS:0000000000000000
>>> Sep  6 21:19:00 sd43 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> Sep  6 21:19:00 sd43 kernel: CR2: 0000000000000020 CR3: 000000000134a000 CR4: 00000000000006f0
>>> Sep  6 21:19:00 sd43 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> Sep  6 21:19:00 sd43 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Sep  6 21:19:00 sd43 kernel: Process events/0 (pid: 19, threadinfo ffff880c7ccbe000, task ffff880c7ccb1780)
>>> Sep  6 21:19:00 sd43 kernel: Stack:
>>> Sep  6 21:19:00 sd43 kernel: ffff880c7ccbe000 ffff88007f28b000 00000000fe00ffff 0000000000000000
>>> Sep  6 21:19:00 sd43 kernel: <0> 0000000000000001 ffff88067cd1a900 ffffffffffffffae ffff880c7cdd89a8
>>> Sep  6 21:19:00 sd43 kernel: <0> ffff880c7cdd8400 ffff880c7ccb1780 00000000fe00ffff ffffffff811bb44c
>>> Sep  6 21:19:00 sd43 kernel: Call Trace:
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff811bb44c>] ? megasas_register_aen+0x7c/0x19c
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff811bd320>] ? megasas_aen_polling+0x3ab/0x3ff
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff811bcf75>] ? megasas_aen_polling+0x0/0x3ff
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff81039fa2>] ? worker_thread+0xf5/0x179
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff8103ce42>] ? autoremove_wake_function+0x0/0x2e
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff81039ead>] ? worker_thread+0x0/0x179
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff8103ca71>] ? kthread+0x79/0x81
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff81002c14>] ? kernel_thread_helper+0x4/0x10
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff8103c9f8>] ? kthread+0x0/0x81
>>> Sep  6 21:19:00 sd43 kernel: [<ffffffff81002c10>] ? kernel_thread_helper+0x0/0x10
>>> Sep  6 21:19:00 sd43 kernel: Code: 83 ec 38 e8 21 fb ff ff 48 89 c5 83 c8 ff 48 85 ed 0f 84 fd 00 00 00 48 8b 55 00 4c 89 e7 c6 02 06 c6 42 02 ff 66 c7 42 10 00 00 <8b> 43 20 89 42 18 48 8b 43 08 c7 42 24 00 00 00 00 89 42 20 c6
>>> Sep  6 21:19:00 sd43 kernel: RIP  [<ffffffff811bb1d1>] megasas_issue_blocked_abort_cmd+0x38/0x12c
>>> Sep  6 21:19:00 sd43 kernel: RSP <ffff880c7ccbfd80>
>>> Sep  6 21:19:00 sd43 kernel: CR2: 0000000000000020
>>> Sep  6 21:19:00 sd43 kernel: ---[ end trace 3a7c9ab197c0c797 ]---
>>>
>>> We only got one so far, if I get more I will post these too.
>>>
>>> Nothing changed on this server so all the info in the first post is the same.
>>> If you need some additional info please let me know.
>>>
>>> I hope we can find a solution for this problem.
>>>
>>> Thanks,
>>>
>>> Reinier
>>>
>>> On 23-08-10 15:26, Yang, Bo wrote:
>>>> Attached is the src.  Can you compile the driver test it again?
>>>>
>>>> Thanks,
>>>>
>>>> Bo Yang
>>>>
>>>> -----Original Message-----
>>>> From: Reinier Haasjes [mailto:reinier@news-service.com]
>>>> Sent: Sunday, August 22, 2010 7:52 AM
>>>> To: linux-scsi@vger.kernel.org
>>>> Cc: Yang, Bo; DL-MegaRAID Linux
>>>> Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>>
>>>> Hi,
>>>>
>>>> Anybody knows where I can find the 4.31 megaraid_sas driver?
>>>>
>>>> Thanks,
>>>>
>>>> Reinier
>>>>
>>>> On 08/17/2010 11:13 AM, Reinier Haasjes wrote:
>>>>> Bo,
>>>>>
>>>>> I'm currently using the version from kernel 2.6.33.2:
>>>>>   megasas: 00.00.04.12-rc1 Thu Sep. 17 11:41:51 PST 2009
>>>>>
>>>>> I already tried kernel 2.6.34 with contains version 4.17.1-rc1, same
>>>>> problem.
>>>>>
>>>>> Where can I find the 4.31 version? If I look at the mainline-kernel it
>>>>> still is version 4.17.1-rc1:
>>>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=blob_plain;f=drivers/scsi/megaraid/megaraid_sas.c;hb=HEAD
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Reinier
>>>>>
>>>>>
>>>>> On 16-08-10 15:53, Yang, Bo wrote:
>>>>>> Reinier,
>>>>>>
>>>>>> What is the driver version you are using?  Is there possible you can apply 4.31 driver (we already submitted the patches)?
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Bo Yang
>>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Reinier Haasjes [mailto:reinier@news-service.com]
>>>>>> Sent: Monday, August 16, 2010 6:04 AM
>>>>>> To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
>>>>>> Subject: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>>>>
>>>>>> [1.] One line summary of the problem:
>>>>>> Kernel OOPS 'megasas_issue_blocked_abort_cmd' after a few thousand "scanning ..." lines
>>>>>>
>>>>>> [2.] Full description of the problem/report:
>>>>>> If something on the scsi bus happens (or the kernel things that something happens) we get a few thousand "scanning ..." lines. After some time (between 30 min. and 5 hours) the 'scanning ...' stops with an kernel OOPS
>>>>>>
>>>>>> [3.] Keywords (i.e., modules, networking, kernel):
>>>>>> megaraid, megasas, scanning, kernel, scsi
>>>>>>
>>>>>> [4.] Kernel version (from /proc/version):
>>>>>> Linux version 2.6.33.2 (root@sd53) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #3 SMP Fri Apr 9 20:28:13 CEST 2010
>>>>>>
>>>>>> [5.] Output of Oops.. message (if applicable) with symbolic information
>>>>>>      resolved (see Documentation/oops-tracing.txt)
>>>>>> Aug 14 04:54:27 sd53 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>>>>>> Aug 14 04:54:27 sd53 kernel: IP: [<ffffffff811baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>>>> Aug 14 04:54:27 sd53 kernel: PGD 67ba88067 PUD 67ba89067 PMD 0
>>>>>> Aug 14 04:54:27 sd53 kernel: Oops: 0000 [#1] SMP
>>>>>> Aug 14 04:54:27 sd53 kernel: last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
>>>>>> Aug 14 04:54:27 sd53 kernel: CPU 7
>>>>>> Aug 14 04:54:27 sd53 kernel: Pid: 26, comm: events/7 Not tainted 2.6.33.2 #3 086HF8/PowerEdge R610
>>>>>> Aug 14 04:54:27 sd53 kernel: RIP: 0010:[<ffffffff811baffe>]  [<ffffffff811baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>>>> Aug 14 04:54:27 sd53 kernel: RSP: 0000:ffff880c7cccdd90  EFLAGS: 00010282
>>>>>> Aug 14 04:54:27 sd53 kernel: RAX: 00000000ffffffff RBX: 0000000000000000 RCX: ffff880c7bd74b08
>>>>>> Aug 14 04:54:27 sd53 kernel: RDX: ffff88007f28c800 RSI: 0000000000000286 RDI: ffff880c7cda8400
>>>>>> Aug 14 04:54:27 sd53 kernel: RBP: ffff880c7bd74ae0 R08: 0000000000000002 R09: 0000000000000001
>>>>>> Aug 14 04:54:27 sd53 kernel: R10: 0000000000000002 R11: ffffffffa000579f R12: ffff880c7cda8400
>>>>>> Aug 14 04:54:27 sd53 kernel: R13: 00000000fe00ffff R14: 0000000000000001 R15: 0000000000000080
>>>>>> Aug 14 04:54:27 sd53 kernel: FS:  0000000000000000(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
>>>>>> Aug 14 04:54:27 sd53 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>>> Aug 14 04:54:27 sd53 kernel: CR2: 0000000000000020 CR3: 000000067ce55000 CR4: 00000000000006e0
>>>>>> Aug 14 04:54:27 sd53 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>> Aug 14 04:54:27 sd53 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>>>> Aug 14 04:54:27 sd53 kernel: Process events/7 (pid: 26, threadinfo ffff880c7cccc000, task ffff880c7ccb40a0)
>>>>>> Aug 14 04:54:27 sd53 kernel: Stack:
>>>>>> Aug 14 04:54:27 sd53 kernel: 0000000000000002 ffff88007f1f3400 00000000fe00ffff 00000000fe00ffff
>>>>>> Aug 14 04:54:27 sd53 kernel: <0> 0000000000000001 ffff880c7bd6aa80 ffff880c7cda88a8 ffff880c7cda8400
>>>>>> Aug 14 04:54:27 sd53 kernel: <0> 0000000000000001 00000000fe00ffff 0000000000000001 ffffffff811bb272
>>>>>> Aug 14 04:54:27 sd53 kernel: Call Trace:
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bb272>] ? megasas_register_aen+0x7e/0x18e
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bc51f>] ? megasas_aen_polling+0x121/0x171
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bc3fe>] ? megasas_aen_polling+0x0/0x171
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81039fa2>] ? worker_thread+0xf5/0x179
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103ce42>] ? autoremove_wake_function+0x0/0x2e
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81039ead>] ? worker_thread+0x0/0x179
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103ca71>] ? kthread+0x79/0x81
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81002c14>] ? kernel_thread_helper+0x4/0x10
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103c9f8>] ? kthread+0x0/0x81
>>>>>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81002c10>] ? kernel_thread_helper+0x0/0x10
>>>>>> Aug 14 04:54:27 sd53 kernel: Code: 83 ec 30 e8 fa fc ff ff 48 89 c5 83 c8 ff 48 85 ed 0f 84 07 01 00 00 48 8b 55 00 4c 89 e7 c6 02 06 c6 42 02 ff 66 c7 42 10 00 00 <8b> 43 20 89 42 18 48 8b 43 08 c7 42 24 00 00 00 00 89 42 20 c6
>>>>>> Aug 14 04:54:27 sd53 kernel: RIP  [<ffffffff811baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>>>>> Aug 14 04:54:27 sd53 kernel: RSP <ffff880c7cccdd90>
>>>>>> Aug 14 04:54:27 sd53 kernel: CR2: 0000000000000020
>>>>>> Aug 14 04:54:27 sd53 kernel: ---[ end trace 2472a972a600883c ]---
>>>>>>
>>>>>> [6.] A small shell script or example program which triggers the
>>>>>>      problem (if possible)
>>>>>> If you hot-swap a disk (eject of insert) the scanning loop starts, no software trigger found.
>>>>>>
>>>>>> [7.] Environment
>>>>>> [7.1.] Software (add the output of the ver_linux script here)
>>>>>> Linux sd53 2.6.33.2 #3 SMP Fri Apr 9 20:28:13 CEST 2010 x86_64 GNU/Linux
>>>>>>
>>>>>> Gnu C                  4.3.2
>>>>>> Gnu make               3.81
>>>>>> binutils               2.18.0.20080103
>>>>>> util-linux             2.13.1.1
>>>>>> mount                  2.13.1.1
>>>>>> module-init-tools      3.4
>>>>>> e2fsprogs              1.41.3
>>>>>> xfsprogs               3.1.2
>>>>>> Linux C Library        2.7
>>>>>> Dynamic linker (ldd)   2.7
>>>>>> Procps                 3.2.7
>>>>>> Net-tools              1.60
>>>>>> Console-tools          0.2.3
>>>>>> Sh-utils               6.10
>>>>>> udev                   125
>>>>>> Modules Loaded         acpi_cpufreq cpufreq_ondemand ipmi_si ipmi_devintf ipmi_msghandler dcdbas processor bnx2 thermal fan thermal_sys
>>>>>>
>>>>>> [7.2.] Processor information (from /proc/cpuinfo):
>>>>>> processor       : 0
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 1
>>>>>> siblings        : 4
>>>>>> core id         : 0
>>>>>> cpu cores       : 4
>>>>>> apicid          : 16
>>>>>> initial apicid  : 16
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.16
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 1
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 0
>>>>>> siblings        : 4
>>>>>> core id         : 0
>>>>>> cpu cores       : 4
>>>>>> apicid          : 0
>>>>>> initial apicid  : 0
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.83
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 2
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 1
>>>>>> siblings        : 4
>>>>>> core id         : 1
>>>>>> cpu cores       : 4
>>>>>> apicid          : 18
>>>>>> initial apicid  : 18
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.83
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 3
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 0
>>>>>> siblings        : 4
>>>>>> core id         : 1
>>>>>> cpu cores       : 4
>>>>>> apicid          : 2
>>>>>> initial apicid  : 2
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.84
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 4
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 1
>>>>>> siblings        : 4
>>>>>> core id         : 2
>>>>>> cpu cores       : 4
>>>>>> apicid          : 20
>>>>>> initial apicid  : 20
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.84
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 5
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 0
>>>>>> siblings        : 4
>>>>>> core id         : 2
>>>>>> cpu cores       : 4
>>>>>> apicid          : 4
>>>>>> initial apicid  : 4
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.86
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 6
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 1
>>>>>> siblings        : 4
>>>>>> core id         : 3
>>>>>> cpu cores       : 4
>>>>>> apicid          : 22
>>>>>> initial apicid  : 22
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.84
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> processor       : 7
>>>>>> vendor_id       : GenuineIntel
>>>>>> cpu family      : 6
>>>>>> model           : 26
>>>>>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>>>>>> stepping        : 5
>>>>>> cpu MHz         : 1596.000
>>>>>> cache size      : 8192 KB
>>>>>> physical id     : 0
>>>>>> siblings        : 4
>>>>>> core id         : 3
>>>>>> cpu cores       : 4
>>>>>> apicid          : 6
>>>>>> initial apicid  : 6
>>>>>> fpu             : yes
>>>>>> fpu_exception   : yes
>>>>>> cpuid level     : 11
>>>>>> wp              : yes
>>>>>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>>>>>> bogomips        : 4521.87
>>>>>> clflush size    : 64
>>>>>> cache_alignment : 64
>>>>>> address sizes   : 40 bits physical, 48 bits virtual
>>>>>> power management:
>>>>>>
>>>>>> [7.3.] Module information (from /proc/modules):
>>>>>> acpi_cpufreq 5107 1 - Live 0xffffffffa0014000
>>>>>> cpufreq_ondemand 7021 8 - Live 0xffffffffa0005000
>>>>>> ipmi_si 32442 2 - Live 0xffffffffa0053000
>>>>>> ipmi_devintf 6371 4 - Live 0xffffffffa004c000
>>>>>> ipmi_msghandler 25956 2 ipmi_si,ipmi_devintf, Live 0xffffffffa003e000
>>>>>> dcdbas 4832 0 - Live 0xffffffffa0036000
>>>>>> processor 22897 9 acpi_cpufreq, Live 0xffffffffa002e000
>>>>>> bnx2 60164 0 - Live 0xffffffffa0018000
>>>>>> thermal 11634 0 - Live 0xffffffffa000f000
>>>>>> fan 2314 0 - Live 0xffffffffa0009000
>>>>>> thermal_sys 10549 3 processor,thermal,fan, Live 0xffffffffa0000000
>>>>>>
>>>>>> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
>>>>>> /proc/ioports
>>>>>> 0000-001f : dma1
>>>>>> 0020-0021 : pic1
>>>>>> 0040-0043 : timer0
>>>>>> 0050-0053 : timer1
>>>>>> 0060-0060 : keyboard
>>>>>> 0064-0064 : keyboard
>>>>>> 0070-0077 : rtc
>>>>>> 0080-008f : dma page reg
>>>>>> 00a0-00a1 : pic2
>>>>>> 00c0-00df : dma2
>>>>>> 00f0-00ff : fpu
>>>>>> 02f8-02ff : serial
>>>>>> 03c0-03df : vga+
>>>>>> 03f8-03ff : serial
>>>>>> 0800-087f : 0000:00:1f.0
>>>>>>   0800-087f : pnp 00:07
>>>>>>     0800-0803 : ACPI PM1a_EVT_BLK
>>>>>>     0804-0805 : ACPI PM1a_CNT_BLK
>>>>>>     0808-080b : ACPI PM_TMR
>>>>>>     0810-0815 : ACPI CPU throttle
>>>>>>     0820-082f : ACPI GPE0_BLK
>>>>>>     0850-0850 : ACPI PM2_CNT_BLK
>>>>>> 0880-08bf : 0000:00:1f.0
>>>>>> 0900-091f : pnp 00:07
>>>>>> 0920-0923 : pnp 00:07
>>>>>> 0924-0924 : pnp 00:07
>>>>>> 0c00-0c7f : pnp 00:07
>>>>>> 0ca0-0ca7 : pnp 00:07
>>>>>> 0ca8-0ca8 : pnp 00:08
>>>>>>   0ca8-0ca8 : ipmi_si
>>>>>> 0ca9-0cab : pnp 00:07
>>>>>> 0cac-0cac : pnp 00:08
>>>>>>   0cac-0cac : ipmi_si
>>>>>> 0cad-0caf : pnp 00:07
>>>>>> 0cf8-0cff : PCI conf1
>>>>>> dc40-dc5f : 0000:00:1a.0
>>>>>>   dc40-dc5f : uhci_hcd
>>>>>> dc60-dc7f : 0000:00:1a.1
>>>>>>   dc60-dc7f : uhci_hcd
>>>>>> dc80-dc9f : 0000:00:1d.0
>>>>>>   dc80-dc9f : uhci_hcd
>>>>>> dca0-dcbf : 0000:00:1d.1
>>>>>>   dca0-dcbf : uhci_hcd
>>>>>> e000-efff : PCI Bus 0000:04
>>>>>>   ec00-ecff : 0000:04:00.0
>>>>>> f000-ffff : PCI Bus 0000:03
>>>>>>   fc00-fcff : 0000:03:00.0
>>>>>>
>>>>>> /proc/iomem
>>>>>> 00000000-0009ffff : System RAM
>>>>>> 00100000-7f678fff : System RAM
>>>>>>   01000000-0125ac0f : Kernel code
>>>>>>   0125ac10-0137aa97 : Kernel data
>>>>>>   0140d000-01440d27 : Kernel bss
>>>>>> 7f679000-7f68efff : reserved
>>>>>> 7f68f000-7f6cdfff : ACPI Tables
>>>>>> 7f6ce000-7fffffff : reserved
>>>>>> d9800000-d9ffffff : PCI Bus 0000:06
>>>>>>   d9800000-d9ffffff : 0000:06:03.0
>>>>>> da000000-ddffffff : PCI Bus 0000:01
>>>>>>   da000000-dbffffff : 0000:01:00.0
>>>>>>     da000000-dbffffff : bnx2
>>>>>>   dc000000-ddffffff : 0000:01:00.1
>>>>>>     dc000000-ddffffff : bnx2
>>>>>> de000000-deffffff : PCI Bus 0000:06
>>>>>>   de000000-de00ffff : 0000:06:03.0
>>>>>>   de7fc000-de7fffff : 0000:06:03.0
>>>>>>   de800000-deffffff : 0000:06:03.0
>>>>>> df0ff800-df0ffbff : 0000:00:1a.7
>>>>>>   df0ff800-df0ffbff : ehci_hcd
>>>>>> df0ffc00-df0fffff : 0000:00:1d.7
>>>>>>   df0ffc00-df0fffff : ehci_hcd
>>>>>> df100000-df1fffff : PCI Bus 0000:04
>>>>>>   df100000-df107fff : 0000:04:00.0
>>>>>>   df180000-df1bffff : 0000:04:00.0
>>>>>>     df180000-df1bffff : megasas: LSI
>>>>>>   df1c0000-df1fffff : 0000:04:00.0
>>>>>>     df1c0000-df1fffff : megasas: LSI
>>>>>> df200000-df2fffff : PCI Bus 0000:03
>>>>>>   df200000-df23ffff : 0000:03:00.0
>>>>>>   df2bc000-df2bffff : 0000:03:00.0
>>>>>>     df2bc000-df2bffff : megasas: LSI
>>>>>>   df2c0000-df2fffff : 0000:03:00.0
>>>>>>     df2c0000-df2fffff : megasas: LSI
>>>>>> e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>>>>>>   e0000000-efffffff : reserved
>>>>>>     e0000000-efffffff : pnp 00:0a
>>>>>> fe000000-ffffffff : reserved
>>>>>>   fec00000-fec003ff : IOAPIC 0
>>>>>>   fec80000-fec803ff : IOAPIC 1
>>>>>>   fed00000-fed003ff : HPET 0
>>>>>>   fed90000-fed91fff : pnp 00:0c
>>>>>>   fee00000-fee00fff : Local APIC
>>>>>> 100000000-c7fffffff : System RAM
>>>>>> sd53:~#
>>>>>>
>>>>>> [7.5.] PCI information ('lspci -vvv' as root)
>>>>>> 00:00.0 Host bridge: Intel Corporation QuickPath Architecture I/O Hub to ESI Port (rev 13)
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Interrupt: pin A routed to IRQ 15
>>>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable-
>>>>>>                 Address: 00000000  Data: 0000
>>>>>>                 Masking: 00000000  Pending: 00000000
>>>>>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag+ RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna- CRSVisible-
>>>>>>                 RootCap: CRSVisible-
>>>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>>>         Capabilities: [e0] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Access Controls <?>
>>>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>>>
>>>>>> 00:01.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>>>>>         I/O behind bridge: 0000f000-00000fff
>>>>>>         Memory behind bridge: da000000-ddffffff
>>>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>>>                 Address: feeff00c  Data: 4159
>>>>>>                 Masking: 00000003  Pending: 00000000
>>>>>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag+ RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #1, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>>>                 RootCap: CRSVisible-
>>>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>>>         Capabilities: [e0] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Access Controls <?>
>>>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>>>         Kernel driver in use: pcieport
>>>>>>
>>>>>> 00:03.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>>>>>         I/O behind bridge: 0000f000-00000fff
>>>>>>         Memory behind bridge: fff00000-000fffff
>>>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>>>                 Address: feeff00c  Data: 4161
>>>>>>                 Masking: 00000003  Pending: 00000000
>>>>>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag+ RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #3, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>>>                 RootCap: CRSVisible-
>>>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>>>         Capabilities: [e0] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Access Controls <?>
>>>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>>>         Kernel driver in use: pcieport
>>>>>>
>>>>>> 00:07.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>>>>>>         I/O behind bridge: 0000e000-0000efff
>>>>>>         Memory behind bridge: df100000-df1fffff
>>>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>>>                 Address: feeff00c  Data: 4169
>>>>>>                 Masking: 00000003  Pending: 00000000
>>>>>>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>>>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag+ RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #7, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
>>>>>>                         Slot #  1, PowerLimit 25.000000; Interlock- NoCompl-
>>>>>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>>>>>                         Control: AttnInd Off, PwrInd Off, Power- Interlock-
>>>>>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>>>>>                         Changed: MRL- PresDet+ LinkState+
>>>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>>>                 RootCap: CRSVisible-
>>>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>>>         Capabilities: [e0] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Access Controls <?>
>>>>>>         Capabilities: [160] Vendor Specific Information <?>
>>>>>>         Kernel driver in use: pcieport
>>>>>>
>>>>>> 00:09.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI Express Root Port 9 (rev 13) (prog-if 00 [Normal decode])
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>>>>>>         I/O behind bridge: 0000f000-00000fff
>>>>>>         Memory behind bridge: fff00000-000fffff
>>>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>>>         Capabilities: [40] Subsystem: Dell Device 0236
>>>>>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Queue=0/1 Enable+
>>>>>>                 Address: feeff00c  Data: 4171
>>>>>>                 Masking: 00000003  Pending: 00000000
>>>>>>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>>>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag+ RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #9, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
>>>>>>                         Slot #  2, PowerLimit 25.000000; Interlock- NoCompl-
>>>>>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>>>>>>                         Control: AttnInd Off, PwrInd Off, Power- Interlock-
>>>>>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
>>>>>>                         Changed: MRL- PresDet+ LinkState-
>>>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna+ CRSVisible-
>>>>>>                 RootCap: CRSVisible-
>>>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>>>         Capabilities: [e0] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Access Controls <?>
>>>>>>         Kernel driver in use: pcieport
>>>>>>
>>>>>> 00:14.0 PIC: Intel Corporation QuickPath Architecture I/O Hub System Management Registers (rev 13) (prog-if 00 [8259])
>>>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag- RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>
>>>>>> 00:14.1 PIC: Intel Corporation QuickPath Architecture I/O Hub GPIO and Scratch Pad Registers (rev 13) (prog-if 00 [8259])
>>>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag- RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>
>>>>>> 00:14.2 PIC: Intel Corporation QuickPath Architecture I/O Hub Control Status and RAS Registers (rev 13) (prog-if 00 [8259])
>>>>>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag- RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0 unlimited, L1 unlimited
>>>>>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>>>>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>
>>>>>> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Interrupt: pin A routed to IRQ 17
>>>>>>         Region 4: I/O ports at dc40 [size=32]
>>>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>>>         Kernel driver in use: uhci_hcd
>>>>>>
>>>>>> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02) (prog-if 00 [UHCI])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Interrupt: pin B routed to IRQ 18
>>>>>>         Region 4: I/O ports at dc60 [size=32]
>>>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>>>         Kernel driver in use: uhci_hcd
>>>>>>
>>>>>> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20 [EHCI])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Interrupt: pin C routed to IRQ 19
>>>>>>         Region 0: Memory at df0ff800 (32-bit, non-prefetchable) [size=1K]
>>>>>>         Capabilities: [50] Power Management version 2
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>>>>>         Capabilities: [98] PCIe advanced features <?>
>>>>>>         Kernel driver in use: ehci_hcd
>>>>>>
>>>>>> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>>>>>>         I/O behind bridge: 0000f000-0000ffff
>>>>>>         Memory behind bridge: df200000-df2fffff
>>>>>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>>>>>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>>>>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>>>         Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
>>>>>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag- RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>>>>>>                 LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <256ns, L1 <4us
>>>>>>                         ClockPM- Suprise- LLActRep+ BwNot-
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>>>>>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntEna- CRSVisible-
>>>>>>                 RootCap: CRSVisible-
>>>>>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>>>>>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
>>>>>>                 Address: feeff00c  Data: 4179
>>>>>>         Capabilities: [90] Subsystem: Dell Device 0236
>>>>>>         Capabilities: [a0] Power Management version 2
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [100] Virtual Channel <?>
>>>>>>         Capabilities: [180] Root Complex Link <?>
>>>>>>         Kernel driver in use: pcieport
>>>>>>
>>>>>> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Interrupt: pin A routed to IRQ 21
>>>>>>         Region 4: I/O ports at dc80 [size=32]
>>>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>>>         Kernel driver in use: uhci_hcd
>>>>>>
>>>>>> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Interrupt: pin B routed to IRQ 20
>>>>>>         Region 4: I/O ports at dca0 [size=32]
>>>>>>         Capabilities: [50] PCIe advanced features <?>
>>>>>>         Kernel driver in use: uhci_hcd
>>>>>>
>>>>>> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20 [EHCI])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Interrupt: pin A routed to IRQ 21
>>>>>>         Region 0: Memory at df0ffc00 (32-bit, non-prefetchable) [size=1K]
>>>>>>         Capabilities: [50] Power Management version 2
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>>>>>>         Capabilities: [98] PCIe advanced features <?>
>>>>>>         Kernel driver in use: ehci_hcd
>>>>>>
>>>>>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01 [Subtractive decode])
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
>>>>>>         I/O behind bridge: 0000f000-00000fff
>>>>>>         Memory behind bridge: de000000-deffffff
>>>>>>         Prefetchable memory behind bridge: 00000000d9800000-00000000d9ffffff
>>>>>>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>>>>>>         BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>>>>>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>>>>>         Capabilities: [50] Subsystem: Dell Device 0236
>>>>>>
>>>>>> 00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface Controller (rev 02)
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0
>>>>>>         Capabilities: [e0] Vendor Specific Information <?>
>>>>>>
>>>>>> 01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Interrupt: pin A routed to IRQ 36
>>>>>>         Region 0: Memory at da000000 (64-bit, non-prefetchable) [size=32M]
>>>>>>         Capabilities: [48] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>>>>>         Capabilities: [50] Vital Product Data <?>
>>>>>>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable-
>>>>>>                 Address: 0000000000000000  Data: 0000
>>>>>>         Capabilities: [a0] MSI-X: Enable+ Mask- TabSize=9
>>>>>>                 Vector table: BAR=0 offset=0000c000
>>>>>>                 PBA: BAR=0 offset=0000e000
>>>>>>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
>>>>>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>>>>>>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>>>>>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>>>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <2us
>>>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>         Capabilities: [100] Device Serial Number e1-66-6a-fe-ff-19-22-00
>>>>>>         Capabilities: [110] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Power Budgeting <?>
>>>>>>         Capabilities: [160] Virtual Channel <?>
>>>>>>         Kernel driver in use: bnx2
>>>>>>         Kernel modules: bnx2
>>>>>>
>>>>>> 01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Interrupt: pin B routed to IRQ 48
>>>>>>         Region 0: Memory at dc000000 (64-bit, non-prefetchable) [size=32M]
>>>>>>         Capabilities: [48] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>>>>>         Capabilities: [50] Vital Product Data <?>
>>>>>>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/4 Enable-
>>>>>>                 Address: 0000000000000000  Data: 0000
>>>>>>         Capabilities: [a0] MSI-X: Enable- Mask- TabSize=9
>>>>>>                 Vector table: BAR=0 offset=0000c000
>>>>>>                 PBA: BAR=0 offset=0000e000
>>>>>>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
>>>>>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>>>>>>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>>>>>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>>>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <2us, L1 <2us
>>>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>         Capabilities: [100] Device Serial Number e3-66-6a-fe-ff-19-22-00
>>>>>>         Capabilities: [110] Advanced Error Reporting <?>
>>>>>>         Capabilities: [150] Power Budgeting <?>
>>>>>>         Capabilities: [160] Virtual Channel <?>
>>>>>>         Kernel driver in use: bnx2
>>>>>>         Kernel modules: bnx2
>>>>>>
>>>>>> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic Device 0079 (rev 04)
>>>>>>         Subsystem: Dell Device 1f17
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Interrupt: pin A routed to IRQ 16
>>>>>>         Region 0: I/O ports at fc00 [size=256]
>>>>>>         Region 1: Memory at df2bc000 (64-bit, non-prefetchable) [size=16K]
>>>>>>         Region 3: Memory at df2c0000 (64-bit, non-prefetchable) [size=256K]
>>>>>>         Expansion ROM at df200000 [disabled] [size=256K]
>>>>>>         Capabilities: [50] Power Management version 3
>>>>>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [68] Express (v2) Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>>>>>>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported+
>>>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>>>>>>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latency L0 <64ns, L1 <1us
>>>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>>>         Capabilities: [d0] Vital Product Data <?>
>>>>>>         Capabilities: [a8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>>>>>>                 Address: 0000000000000000  Data: 0000
>>>>>>         Capabilities: [c0] MSI-X: Enable- Mask- TabSize=15
>>>>>>                 Vector table: BAR=1 offset=00002000
>>>>>>                 PBA: BAR=1 offset=00003800
>>>>>>         Capabilities: [100] Advanced Error Reporting <?>
>>>>>>         Capabilities: [138] Power Budgeting <?>
>>>>>>         Kernel driver in use: megaraid_sas
>>>>>>
>>>>>> 04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
>>>>>>         Subsystem: Dell PERC 6/E Adapter RAID Controller
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>>>         Interrupt: pin A routed to IRQ 38
>>>>>>         Region 0: Memory at df180000 (64-bit, non-prefetchable) [size=256K]
>>>>>>         Region 2: I/O ports at ec00 [size=256]
>>>>>>         Region 3: Memory at df1c0000 (64-bit, non-prefetchable) [size=256K]
>>>>>>         Expansion ROM at df100000 [disabled] [size=32K]
>>>>>>         Capabilities: [b0] Express (v1) Endpoint, MSI 00
>>>>>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
>>>>>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>>>>>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Unsupported-
>>>>>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>>>                         MaxPayload 256 bytes, MaxReadReq 2048 bytes
>>>>>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>>>>>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 unlimited
>>>>>>                         ClockPM- Suprise- LLActRep- BwNot-
>>>>>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>>>>>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>>>>>>         Capabilities: [c4] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
>>>>>>                 Address: 0000000000000000  Data: 0000
>>>>>>         Capabilities: [d4] MSI-X: Enable- Mask- TabSize=4
>>>>>>                 Vector table: BAR=0 offset=0003e000
>>>>>>                 PBA: BAR=0 offset=00fff000
>>>>>>         Capabilities: [e0] Power Management version 2
>>>>>>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>         Capabilities: [ec] Vital Product Data <?>
>>>>>>         Capabilities: [100] Power Budgeting <?>
>>>>>>         Kernel driver in use: megaraid_sas
>>>>>>
>>>>>> 06:03.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW WPCM450 [Hermon] - Winbond/Nuvoton (rev 0a) (prog-if 00 [VGA controller])
>>>>>>         Subsystem: Dell Device 0236
>>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>         Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
>>>>>>         Interrupt: pin A routed to IRQ 10
>>>>>>         Region 0: Memory at d9800000 (32-bit, prefetchable) [size=8M]
>>>>>>         Region 1: Memory at de7fc000 (32-bit, non-prefetchable) [size=16K]
>>>>>>         Region 2: Memory at de800000 (32-bit, non-prefetchable) [size=8M]
>>>>>>         [virtual] Expansion ROM at de000000 [disabled] [size=64K]
>>>>>>         Capabilities: [dc] Power Management version 1
>>>>>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>>>>
>>>>>> [7.6.] SCSI information (from /proc/scsi/scsi)
>>>>>> Attached devices:
>>>>>> Host: scsi0 Channel: 00 Id: 46 Lun: 00
>>>>>>   Vendor: Dell     Model: J23              Rev: R109
>>>>>>   Type:   Enclosure                        ANSI  SCSI revision: 05
>>>>>> Host: scsi0 Channel: 00 Id: 47 Lun: 00
>>>>>>   Vendor: Dell     Model: J23              Rev: R109
>>>>>>   Type:   Enclosure                        ANSI  SCSI revision: 05
>>>>>> Host: scsi0 Channel: 02 Id: 00 Lun: 00
>>>>>>   Vendor: DELL     Model: PERC 6/E Adapter Rev: 1.22
>>>>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>>>>> Host: scsi0 Channel: 02 Id: 01 Lun: 00
>>>>>>   Vendor: DELL     Model: PERC 6/E Adapter Rev: 1.22
>>>>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>>>>> Host: scsi1 Channel: 02 Id: 00 Lun: 00
>>>>>>   Vendor: DELL     Model: PERC H700        Rev: 2.0.
>>>>>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>>>>>
>>>>>> [7.7.] Other information that might be relevant to the problem
>>>>>>        (please look in /proc and include all information that you
>>>>>>        think to be relevant):
>>>>>> [X.] Other notes, patches, fixes, workarounds:
>>>>>> I think the problem is the H700 controller in combination with the megasas-driver.
>>>>>> We have a lot more systems running 2.6.33.2 and only the servers with the H700 controller are giving this problem.
>>>>>> Also after some sime (after the scanning and oops) we experience user space freezes.
>>>>>> I tried 2.6.34 and give the same problem, only not the 'scanning-loop', just 1 'scanning-line'.
>>>>>> It's on a production server so I didn't test 2.6.35, can't reproduce it on a test machine.
>>>>>>
>>>>>> Best Regards,
>>>>>>
>>>>>> Reinier
>>>>>> --
>>>>>> News-Service.com - European Usenet Provider
>>>>>> Luttenbergweg 4, 1101 EC Amsterdam
>>>>>> P.O BOX: 12026 1100 AA, Netherlands
>>>>>> http://www.news-service.com +31(0)20 398 1111
>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
