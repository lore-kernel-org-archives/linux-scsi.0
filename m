From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
Date: Mon, 23 Aug 2010 07:26:18 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3DBEF4AD0@cosmail02.lsi.com>
References: <4C690D09.70908@news-service.com>
 <4B6A08C587958942AA3002690DD4F8C3DBE62B40@cosmail02.lsi.com>
 <4C6A52AA.9040303@news-service.com> <4C710F55.3020302@news-service.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_003_4B6A08C587958942AA3002690DD4F8C3DBEF4AD0cosmail02lsicom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:49115 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480Ab0HWN0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 09:26:43 -0400
In-Reply-To: <4C710F55.3020302@news-service.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Reinier Haasjes <reinier@news-service.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>

--_003_4B6A08C587958942AA3002690DD4F8C3DBEF4AD0cosmail02lsicom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Attached is the src.  Can you compile the driver test it again?

Thanks,

Bo Yang

-----Original Message-----
From: Reinier Haasjes [mailto:reinier@news-service.com]
Sent: Sunday, August 22, 2010 7:52 AM
To: linux-scsi@vger.kernel.org
Cc: Yang, Bo; DL-MegaRAID Linux
Subject: Re: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a

Hi,

Anybody knows where I can find the 4.31 megaraid_sas driver?

Thanks,

Reinier

On 08/17/2010 11:13 AM, Reinier Haasjes wrote:
> Bo,
>
> I'm currently using the version from kernel 2.6.33.2:
>   megasas: 00.00.04.12-rc1 Thu Sep. 17 11:41:51 PST 2009
>
> I already tried kernel 2.6.34 with contains version 4.17.1-rc1, same
> problem.
>
> Where can I find the 4.31 version? If I look at the mainline-kernel it
> still is version 4.17.1-rc1:
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.35.y.git;a=
=3Dblob_plain;f=3Ddrivers/scsi/megaraid/megaraid_sas.c;hb=3DHEAD
>
> Thanks,
>
> Reinier
>
>
> On 16-08-10 15:53, Yang, Bo wrote:
>> Reinier,
>>
>> What is the driver version you are using?  Is there possible you can app=
ly 4.31 driver (we already submitted the patches)?
>>
>> Thanks,
>>
>> Bo Yang
>>
>> -----Original Message-----
>> From: Reinier Haasjes [mailto:reinier@news-service.com]
>> Sent: Monday, August 16, 2010 6:04 AM
>> To: DL-MegaRAID Linux; linux-scsi@vger.kernel.org
>> Subject: PROBLEM: megasas_issue_blocked_abort_cmd+0x3a/0x13a
>>
>> [1.] One line summary of the problem:
>> Kernel OOPS 'megasas_issue_blocked_abort_cmd' after a few thousand "scan=
ning ..." lines
>>
>> [2.] Full description of the problem/report:
>> If something on the scsi bus happens (or the kernel things that somethin=
g happens) we get a few thousand "scanning ..." lines. After some time (bet=
ween 30 min. and 5 hours) the 'scanning ...' stops with an kernel OOPS
>>
>> [3.] Keywords (i.e., modules, networking, kernel):
>> megaraid, megasas, scanning, kernel, scsi
>>
>> [4.] Kernel version (from /proc/version):
>> Linux version 2.6.33.2 (root@sd53) (gcc version 4.3.2 (Debian 4.3.2-1.1)=
 ) #3 SMP Fri Apr 9 20:28:13 CEST 2010
>>
>> [5.] Output of Oops.. message (if applicable) with symbolic information
>>      resolved (see Documentation/oops-tracing.txt)
>> Aug 14 04:54:27 sd53 kernel: BUG: unable to handle kernel NULL pointer d=
ereference at 0000000000000020
>> Aug 14 04:54:27 sd53 kernel: IP: [<ffffffff811baffe>] megasas_issue_bloc=
ked_abort_cmd+0x3a/0x13a
>> Aug 14 04:54:27 sd53 kernel: PGD 67ba88067 PUD 67ba89067 PMD 0
>> Aug 14 04:54:27 sd53 kernel: Oops: 0000 [#1] SMP
>> Aug 14 04:54:27 sd53 kernel: last sysfs file: /sys/devices/system/cpu/cp=
u7/cache/index2/shared_cpu_map
>> Aug 14 04:54:27 sd53 kernel: CPU 7
>> Aug 14 04:54:27 sd53 kernel: Pid: 26, comm: events/7 Not tainted 2.6.33.=
2 #3 086HF8/PowerEdge R610
>> Aug 14 04:54:27 sd53 kernel: RIP: 0010:[<ffffffff811baffe>]  [<ffffffff8=
11baffe>] megasas_issue_blocked_abort_cmd+0x3a/0x13a
>> Aug 14 04:54:27 sd53 kernel: RSP: 0000:ffff880c7cccdd90  EFLAGS: 0001028=
2
>> Aug 14 04:54:27 sd53 kernel: RAX: 00000000ffffffff RBX: 0000000000000000=
 RCX: ffff880c7bd74b08
>> Aug 14 04:54:27 sd53 kernel: RDX: ffff88007f28c800 RSI: 0000000000000286=
 RDI: ffff880c7cda8400
>> Aug 14 04:54:27 sd53 kernel: RBP: ffff880c7bd74ae0 R08: 0000000000000002=
 R09: 0000000000000001
>> Aug 14 04:54:27 sd53 kernel: R10: 0000000000000002 R11: ffffffffa000579f=
 R12: ffff880c7cda8400
>> Aug 14 04:54:27 sd53 kernel: R13: 00000000fe00ffff R14: 0000000000000001=
 R15: 0000000000000080
>> Aug 14 04:54:27 sd53 kernel: FS:  0000000000000000(0000) GS:ffff88002838=
0000(0000) knlGS:0000000000000000
>> Aug 14 04:54:27 sd53 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080=
05003b
>> Aug 14 04:54:27 sd53 kernel: CR2: 0000000000000020 CR3: 000000067ce55000=
 CR4: 00000000000006e0
>> Aug 14 04:54:27 sd53 kernel: DR0: 0000000000000000 DR1: 0000000000000000=
 DR2: 0000000000000000
>> Aug 14 04:54:27 sd53 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0=
 DR7: 0000000000000400
>> Aug 14 04:54:27 sd53 kernel: Process events/7 (pid: 26, threadinfo ffff8=
80c7cccc000, task ffff880c7ccb40a0)
>> Aug 14 04:54:27 sd53 kernel: Stack:
>> Aug 14 04:54:27 sd53 kernel: 0000000000000002 ffff88007f1f3400 00000000f=
e00ffff 00000000fe00ffff
>> Aug 14 04:54:27 sd53 kernel: <0> 0000000000000001 ffff880c7bd6aa80 ffff8=
80c7cda88a8 ffff880c7cda8400
>> Aug 14 04:54:27 sd53 kernel: <0> 0000000000000001 00000000fe00ffff 00000=
00000000001 ffffffff811bb272
>> Aug 14 04:54:27 sd53 kernel: Call Trace:
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bb272>] ? megasas_register_aen=
+0x7e/0x18e
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bc51f>] ? megasas_aen_polling+=
0x121/0x171
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff811bc3fe>] ? megasas_aen_polling+=
0x0/0x171
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81039fa2>] ? worker_thread+0xf5/0=
x179
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103ce42>] ? autoremove_wake_func=
tion+0x0/0x2e
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81039ead>] ? worker_thread+0x0/0x=
179
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103ca71>] ? kthread+0x79/0x81
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81002c14>] ? kernel_thread_helper=
+0x4/0x10
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff8103c9f8>] ? kthread+0x0/0x81
>> Aug 14 04:54:27 sd53 kernel: [<ffffffff81002c10>] ? kernel_thread_helper=
+0x0/0x10
>> Aug 14 04:54:27 sd53 kernel: Code: 83 ec 30 e8 fa fc ff ff 48 89 c5 83 c=
8 ff 48 85 ed 0f 84 07 01 00 00 48 8b 55 00 4c 89 e7 c6 02 06 c6 42 02 ff 6=
6 c7 42 10 00 00 <8b> 43 20 89 42 18 48 8b 43 08 c7 42 24 00 00 00 00 89 42=
 20 c6
>> Aug 14 04:54:27 sd53 kernel: RIP  [<ffffffff811baffe>] megasas_issue_blo=
cked_abort_cmd+0x3a/0x13a
>> Aug 14 04:54:27 sd53 kernel: RSP <ffff880c7cccdd90>
>> Aug 14 04:54:27 sd53 kernel: CR2: 0000000000000020
>> Aug 14 04:54:27 sd53 kernel: ---[ end trace 2472a972a600883c ]---
>>
>> [6.] A small shell script or example program which triggers the
>>      problem (if possible)
>> If you hot-swap a disk (eject of insert) the scanning loop starts, no so=
ftware trigger found.
>>
>> [7.] Environment
>> [7.1.] Software (add the output of the ver_linux script here)
>> Linux sd53 2.6.33.2 #3 SMP Fri Apr 9 20:28:13 CEST 2010 x86_64 GNU/Linux
>>
>> Gnu C                  4.3.2
>> Gnu make               3.81
>> binutils               2.18.0.20080103
>> util-linux             2.13.1.1
>> mount                  2.13.1.1
>> module-init-tools      3.4
>> e2fsprogs              1.41.3
>> xfsprogs               3.1.2
>> Linux C Library        2.7
>> Dynamic linker (ldd)   2.7
>> Procps                 3.2.7
>> Net-tools              1.60
>> Console-tools          0.2.3
>> Sh-utils               6.10
>> udev                   125
>> Modules Loaded         acpi_cpufreq cpufreq_ondemand ipmi_si ipmi_devint=
f ipmi_msghandler dcdbas processor bnx2 thermal fan thermal_sys
>>
>> [7.2.] Processor information (from /proc/cpuinfo):
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 1
>> siblings        : 4
>> core id         : 0
>> cpu cores       : 4
>> apicid          : 16
>> initial apicid  : 16
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.16
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 1
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 0
>> cpu cores       : 4
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.83
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 2
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 1
>> siblings        : 4
>> core id         : 1
>> cpu cores       : 4
>> apicid          : 18
>> initial apicid  : 18
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.83
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 3
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 1
>> cpu cores       : 4
>> apicid          : 2
>> initial apicid  : 2
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.84
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 4
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 1
>> siblings        : 4
>> core id         : 2
>> cpu cores       : 4
>> apicid          : 20
>> initial apicid  : 20
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.84
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 5
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 2
>> cpu cores       : 4
>> apicid          : 4
>> initial apicid  : 4
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.86
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 6
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 1
>> siblings        : 4
>> core id         : 3
>> cpu cores       : 4
>> apicid          : 22
>> initial apicid  : 22
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.84
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> processor       : 7
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 26
>> model name      : Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
>> stepping        : 5
>> cpu MHz         : 1596.000
>> cache size      : 8192 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 3
>> cpu cores       : 4
>> apicid          : 6
>> initial apicid  : 6
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 11
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n=
x rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_t=
sc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dc=
a sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 4521.87
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 40 bits physical, 48 bits virtual
>> power management:
>>
>> [7.3.] Module information (from /proc/modules):
>> acpi_cpufreq 5107 1 - Live 0xffffffffa0014000
>> cpufreq_ondemand 7021 8 - Live 0xffffffffa0005000
>> ipmi_si 32442 2 - Live 0xffffffffa0053000
>> ipmi_devintf 6371 4 - Live 0xffffffffa004c000
>> ipmi_msghandler 25956 2 ipmi_si,ipmi_devintf, Live 0xffffffffa003e000
>> dcdbas 4832 0 - Live 0xffffffffa0036000
>> processor 22897 9 acpi_cpufreq, Live 0xffffffffa002e000
>> bnx2 60164 0 - Live 0xffffffffa0018000
>> thermal 11634 0 - Live 0xffffffffa000f000
>> fan 2314 0 - Live 0xffffffffa0009000
>> thermal_sys 10549 3 processor,thermal,fan, Live 0xffffffffa0000000
>>
>> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iome=
m)
>> /proc/ioports
>> 0000-001f : dma1
>> 0020-0021 : pic1
>> 0040-0043 : timer0
>> 0050-0053 : timer1
>> 0060-0060 : keyboard
>> 0064-0064 : keyboard
>> 0070-0077 : rtc
>> 0080-008f : dma page reg
>> 00a0-00a1 : pic2
>> 00c0-00df : dma2
>> 00f0-00ff : fpu
>> 02f8-02ff : serial
>> 03c0-03df : vga+
>> 03f8-03ff : serial
>> 0800-087f : 0000:00:1f.0
>>   0800-087f : pnp 00:07
>>     0800-0803 : ACPI PM1a_EVT_BLK
>>     0804-0805 : ACPI PM1a_CNT_BLK
>>     0808-080b : ACPI PM_TMR
>>     0810-0815 : ACPI CPU throttle
>>     0820-082f : ACPI GPE0_BLK
>>     0850-0850 : ACPI PM2_CNT_BLK
>> 0880-08bf : 0000:00:1f.0
>> 0900-091f : pnp 00:07
>> 0920-0923 : pnp 00:07
>> 0924-0924 : pnp 00:07
>> 0c00-0c7f : pnp 00:07
>> 0ca0-0ca7 : pnp 00:07
>> 0ca8-0ca8 : pnp 00:08
>>   0ca8-0ca8 : ipmi_si
>> 0ca9-0cab : pnp 00:07
>> 0cac-0cac : pnp 00:08
>>   0cac-0cac : ipmi_si
>> 0cad-0caf : pnp 00:07
>> 0cf8-0cff : PCI conf1
>> dc40-dc5f : 0000:00:1a.0
>>   dc40-dc5f : uhci_hcd
>> dc60-dc7f : 0000:00:1a.1
>>   dc60-dc7f : uhci_hcd
>> dc80-dc9f : 0000:00:1d.0
>>   dc80-dc9f : uhci_hcd
>> dca0-dcbf : 0000:00:1d.1
>>   dca0-dcbf : uhci_hcd
>> e000-efff : PCI Bus 0000:04
>>   ec00-ecff : 0000:04:00.0
>> f000-ffff : PCI Bus 0000:03
>>   fc00-fcff : 0000:03:00.0
>>
>> /proc/iomem
>> 00000000-0009ffff : System RAM
>> 00100000-7f678fff : System RAM
>>   01000000-0125ac0f : Kernel code
>>   0125ac10-0137aa97 : Kernel data
>>   0140d000-01440d27 : Kernel bss
>> 7f679000-7f68efff : reserved
>> 7f68f000-7f6cdfff : ACPI Tables
>> 7f6ce000-7fffffff : reserved
>> d9800000-d9ffffff : PCI Bus 0000:06
>>   d9800000-d9ffffff : 0000:06:03.0
>> da000000-ddffffff : PCI Bus 0000:01
>>   da000000-dbffffff : 0000:01:00.0
>>     da000000-dbffffff : bnx2
>>   dc000000-ddffffff : 0000:01:00.1
>>     dc000000-ddffffff : bnx2
>> de000000-deffffff : PCI Bus 0000:06
>>   de000000-de00ffff : 0000:06:03.0
>>   de7fc000-de7fffff : 0000:06:03.0
>>   de800000-deffffff : 0000:06:03.0
>> df0ff800-df0ffbff : 0000:00:1a.7
>>   df0ff800-df0ffbff : ehci_hcd
>> df0ffc00-df0fffff : 0000:00:1d.7
>>   df0ffc00-df0fffff : ehci_hcd
>> df100000-df1fffff : PCI Bus 0000:04
>>   df100000-df107fff : 0000:04:00.0
>>   df180000-df1bffff : 0000:04:00.0
>>     df180000-df1bffff : megasas: LSI
>>   df1c0000-df1fffff : 0000:04:00.0
>>     df1c0000-df1fffff : megasas: LSI
>> df200000-df2fffff : PCI Bus 0000:03
>>   df200000-df23ffff : 0000:03:00.0
>>   df2bc000-df2bffff : 0000:03:00.0
>>     df2bc000-df2bffff : megasas: LSI
>>   df2c0000-df2fffff : 0000:03:00.0
>>     df2c0000-df2fffff : megasas: LSI
>> e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
>>   e0000000-efffffff : reserved
>>     e0000000-efffffff : pnp 00:0a
>> fe000000-ffffffff : reserved
>>   fec00000-fec003ff : IOAPIC 0
>>   fec80000-fec803ff : IOAPIC 1
>>   fed00000-fed003ff : HPET 0
>>   fed90000-fed91fff : pnp 00:0c
>>   fee00000-fee00fff : Local APIC
>> 100000000-c7fffffff : System RAM
>> sd53:~#
>>
>> [7.5.] PCI information ('lspci -vvv' as root)
>> 00:00.0 Host bridge: Intel Corporation QuickPath Architecture I/O Hub to=
 ESI Port (rev 13)
>>         Subsystem: Dell Device 0236
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Interrupt: pin A routed to IRQ 15
>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Qu=
eue=3D0/1 Enable-
>>                 Address: 00000000  Data: 0000
>>                 Masking: 00000000  Pending: 00000000
>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag+ RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, L=
atency L0 <512ns, L1 <64us
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntE=
na- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         Capabilities: [e0] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [100] Advanced Error Reporting <?>
>>         Capabilities: [150] Access Controls <?>
>>         Capabilities: [160] Vendor Specific Information <?>
>>
>> 00:01.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI=
 Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=
=3D0
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: da000000-ddffffff
>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000f=
ffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort+ <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Subsystem: Dell Device 0236
>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Qu=
eue=3D0/1 Enable+
>>                 Address: feeff00c  Data: 4159
>>                 Masking: 00000003  Pending: 00000000
>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag+ RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #1, Speed 5GT/s, Width x4, ASPM L0s L1, Lat=
ency L0 <512ns, L1 <64us
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntE=
na+ CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         Capabilities: [e0] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [100] Advanced Error Reporting <?>
>>         Capabilities: [150] Access Controls <?>
>>         Capabilities: [160] Vendor Specific Information <?>
>>         Kernel driver in use: pcieport
>>
>> 00:03.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI=
 Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=
=3D0
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: fff00000-000fffff
>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000f=
ffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Subsystem: Dell Device 0236
>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Qu=
eue=3D0/1 Enable+
>>                 Address: feeff00c  Data: 4161
>>                 Masking: 00000003  Pending: 00000000
>>         Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag+ RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #3, Speed 5GT/s, Width x4, ASPM L0s L1, Lat=
ency L0 <512ns, L1 <64us
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- C=
ommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntE=
na+ CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         Capabilities: [e0] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [100] Advanced Error Reporting <?>
>>         Capabilities: [150] Access Controls <?>
>>         Capabilities: [160] Vendor Specific Information <?>
>>         Kernel driver in use: pcieport
>>
>> 00:07.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI=
 Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=
=3D0
>>         I/O behind bridge: 0000e000-0000efff
>>         Memory behind bridge: df100000-df1fffff
>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000f=
ffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Subsystem: Dell Device 0236
>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Qu=
eue=3D0/1 Enable+
>>                 Address: feeff00c  Data: 4169
>>                 Masking: 00000003  Pending: 00000000
>>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag+ RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 256 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #7, Speed 5GT/s, Width x8, ASPM L0s L1, Lat=
ency L0 <512ns, L1 <64us
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-=
 Surpise-
>>                         Slot #  1, PowerLimit 25.000000; Interlock- NoCo=
mpl-
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- =
HPIrq- LinkChg-
>>                         Control: AttnInd Off, PwrInd Off, Power- Interlo=
ck-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet=
+ Interlock-
>>                         Changed: MRL- PresDet+ LinkState+
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntE=
na+ CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         Capabilities: [e0] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [100] Advanced Error Reporting <?>
>>         Capabilities: [150] Access Controls <?>
>>         Capabilities: [160] Vendor Specific Information <?>
>>         Kernel driver in use: pcieport
>>
>> 00:09.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI=
 Express Root Port 9 (rev 13) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=
=3D0
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: fff00000-000fffff
>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000f=
ffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Subsystem: Dell Device 0236
>>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit- Qu=
eue=3D0/1 Enable+
>>                 Address: feeff00c  Data: 4171
>>                 Masking: 00000003  Pending: 00000000
>>         Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag+ RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #9, Speed 5GT/s, Width x8, ASPM L0s L1, Lat=
ency L0 <512ns, L1 <64us
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled+ Retrain- C=
ommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-=
 Surpise-
>>                         Slot #  2, PowerLimit 25.000000; Interlock- NoCo=
mpl-
>>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- =
HPIrq- LinkChg-
>>                         Control: AttnInd Off, PwrInd Off, Power- Interlo=
ck-
>>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet=
- Interlock-
>>                         Changed: MRL- PresDet+ LinkState-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntE=
na+ CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         Capabilities: [e0] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [100] Advanced Error Reporting <?>
>>         Capabilities: [150] Access Controls <?>
>>         Kernel driver in use: pcieport
>>
>> 00:14.0 PIC: Intel Corporation QuickPath Architecture I/O Hub System Man=
agement Registers (rev 13) (prog-if 00 [8259])
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint=
, MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Un=
supported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Late=
ncy L0 unlimited, L1 unlimited
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>
>> 00:14.1 PIC: Intel Corporation QuickPath Architecture I/O Hub GPIO and S=
cratch Pad Registers (rev 13) (prog-if 00 [8259])
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint=
, MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Un=
supported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Late=
ncy L0 unlimited, L1 unlimited
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>
>> 00:14.2 PIC: Intel Corporation QuickPath Architecture I/O Hub Control St=
atus and RAS Registers (rev 13) (prog-if 00 [8259])
>>         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Capabilities: [40] Express (v2) Root Complex Integrated Endpoint=
, MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Un=
supported-
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Late=
ncy L0 unlimited, L1 unlimited
>>                         ClockPM- Suprise+ LLActRep+ BwNot+
>>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>
>> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI =
Controller #4 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Dell Device 0236
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 17
>>         Region 4: I/O ports at dc40 [size=3D32]
>>         Capabilities: [50] PCIe advanced features <?>
>>         Kernel driver in use: uhci_hcd
>>
>> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI =
Controller #5 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Dell Device 0236
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin B routed to IRQ 18
>>         Region 4: I/O ports at dc60 [size=3D32]
>>         Capabilities: [50] PCIe advanced features <?>
>>         Kernel driver in use: uhci_hcd
>>
>> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI=
 Controller #2 (rev 02) (prog-if 20 [EHCI])
>>         Subsystem: Dell Device 0236
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin C routed to IRQ 19
>>         Region 0: Memory at df0ff800 (32-bit, non-prefetchable) [size=3D=
1K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D=
1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
>>         Capabilities: [98] PCIe advanced features <?>
>>         Kernel driver in use: ehci_hcd
>>
>> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express P=
ort 1 (rev 02) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=
=3D0
>>         I/O behind bridge: 0000f000-0000ffff
>>         Memory behind bridge: df200000-df2fffff
>>         Prefetchable memory behind bridge: 00000000fff00000-00000000000f=
ffff
>>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
>>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <=
64ns, L1 <1us
>>                         ExtTag- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+=
 TransPend-
>>                 LnkCap: Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, L=
atency L0 <256ns, L1 <4us
>>                         ClockPM- Suprise- LLActRep+ BwNot-
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive+ BWMgmt- ABWMgmt-
>>                 RootCtl: ErrCorrectable- ErrNon-Fatal+ ErrFatal+ PMEIntE=
na- CRSVisible-
>>                 RootCap: CRSVisible-
>>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Qu=
eue=3D0/0 Enable+
>>                 Address: feeff00c  Data: 4179
>>         Capabilities: [90] Subsystem: Dell Device 0236
>>         Capabilities: [a0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [100] Virtual Channel <?>
>>         Capabilities: [180] Root Complex Link <?>
>>         Kernel driver in use: pcieport
>>
>> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI =
Controller #1 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Dell Device 0236
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 21
>>         Region 4: I/O ports at dc80 [size=3D32]
>>         Capabilities: [50] PCIe advanced features <?>
>>         Kernel driver in use: uhci_hcd
>>
>> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI =
Controller #2 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Dell Device 0236
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin B routed to IRQ 20
>>         Region 4: I/O ports at dca0 [size=3D32]
>>         Capabilities: [50] PCIe advanced features <?>
>>         Kernel driver in use: uhci_hcd
>>
>> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI=
 Controller #1 (rev 02) (prog-if 20 [EHCI])
>>         Subsystem: Dell Device 0236
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin A routed to IRQ 21
>>         Region 0: Memory at df0ffc00 (32-bit, non-prefetchable) [size=3D=
1K]
>>         Capabilities: [50] Power Management version 2
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D=
1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [58] Debug port: BAR=3D1 offset=3D00a0
>>         Capabilities: [98] PCIe advanced features <?>
>>         Kernel driver in use: ehci_hcd
>>
>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if=
 01 [Subtractive decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=
=3D32
>>         I/O behind bridge: 0000f000-00000fff
>>         Memory behind bridge: de000000-deffffff
>>         Prefetchable memory behind bridge: 00000000d9800000-00000000d9ff=
ffff
>>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort+ <SERR- <PERR-
>>         BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>         Capabilities: [50] Subsystem: Dell Device 0236
>>
>> 00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface Contr=
oller (rev 02)
>>         Subsystem: Dell Device 0236
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr+ Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Capabilities: [e0] Vendor Specific Information <?>
>>
>> 01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 G=
igabit Ethernet (rev 20)
>>         Subsystem: Dell Device 0236
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 36
>>         Region 0: Memory at da000000 (64-bit, non-prefetchable) [size=3D=
32M]
>>         Capabilities: [48] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
>>         Capabilities: [50] Vital Product Data <?>
>>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Qu=
eue=3D0/4 Enable-
>>                 Address: 0000000000000000  Data: 0000
>>         Capabilities: [a0] MSI-X: Enable+ Mask- TabSize=3D9
>>                 Vector table: BAR=3D0 offset=3D0000c000
>>                 PBA: BAR=3D0 offset=3D0000e000
>>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <=
4us, L1 <64us
>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+=
 TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, L=
atency L0 <2us, L1 <2us
>>                         ClockPM- Suprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>         Capabilities: [100] Device Serial Number e1-66-6a-fe-ff-19-22-00
>>         Capabilities: [110] Advanced Error Reporting <?>
>>         Capabilities: [150] Power Budgeting <?>
>>         Capabilities: [160] Virtual Channel <?>
>>         Kernel driver in use: bnx2
>>         Kernel modules: bnx2
>>
>> 01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 G=
igabit Ethernet (rev 20)
>>         Subsystem: Dell Device 0236
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin B routed to IRQ 48
>>         Region 0: Memory at dc000000 (64-bit, non-prefetchable) [size=3D=
32M]
>>         Capabilities: [48] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-=
,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
>>         Capabilities: [50] Vital Product Data <?>
>>         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Qu=
eue=3D0/4 Enable-
>>                 Address: 0000000000000000  Data: 0000
>>         Capabilities: [a0] MSI-X: Enable- Mask- TabSize=3D9
>>                 Vector table: BAR=3D0 offset=3D0000c000
>>                 PBA: BAR=3D0 offset=3D0000e000
>>         Capabilities: [ac] Express (v2) Endpoint, MSI 00
>>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <=
4us, L1 <64us
>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>>                         MaxPayload 256 bytes, MaxReadReq 512 bytes
>>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+=
 TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, L=
atency L0 <2us, L1 <2us
>>                         ClockPM- Suprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>         Capabilities: [100] Device Serial Number e3-66-6a-fe-ff-19-22-00
>>         Capabilities: [110] Advanced Error Reporting <?>
>>         Capabilities: [150] Power Budgeting <?>
>>         Capabilities: [160] Virtual Channel <?>
>>         Kernel driver in use: bnx2
>>         Kernel modules: bnx2
>>
>> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic Device 0079 (rev =
04)
>>         Subsystem: Dell Device 1f17
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: I/O ports at fc00 [size=3D256]
>>         Region 1: Memory at df2bc000 (64-bit, non-prefetchable) [size=3D=
16K]
>>         Region 3: Memory at df2c0000 (64-bit, non-prefetchable) [size=3D=
256K]
>>         Expansion ROM at df200000 [disabled] [size=3D256K]
>>         Capabilities: [50] Power Management version 3
>>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-=
,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [68] Express (v2) Endpoint, MSI 00
>>                 DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s =
<64ns, L1 <1us
>>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>>                 DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Un=
supported+
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLR=
eset-
>>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s, Latenc=
y L0 <64ns, L1 <1us
>>                         ClockPM- Suprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk+
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ =
DLActive- BWMgmt- ABWMgmt-
>>         Capabilities: [d0] Vital Product Data <?>
>>         Capabilities: [a8] Message Signalled Interrupts: Mask- 64bit+ Qu=
eue=3D0/0 Enable-
>>                 Address: 0000000000000000  Data: 0000
>>         Capabilities: [c0] MSI-X: Enable- Mask- TabSize=3D15
>>                 Vector table: BAR=3D1 offset=3D00002000
>>                 PBA: BAR=3D1 offset=3D00003800
>>         Capabilities: [100] Advanced Error Reporting <?>
>>         Capabilities: [138] Power Budgeting <?>
>>         Kernel driver in use: megaraid_sas
>>
>> 04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078=
 (rev 04)
>>         Subsystem: Dell PERC 6/E Adapter RAID Controller
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 38
>>         Region 0: Memory at df180000 (64-bit, non-prefetchable) [size=3D=
256K]
>>         Region 2: I/O ports at ec00 [size=3D256]
>>         Region 3: Memory at df1c0000 (64-bit, non-prefetchable) [size=3D=
256K]
>>         Expansion ROM at df100000 [disabled] [size=3D32K]
>>         Capabilities: [b0] Express (v1) Endpoint, MSI 00
>>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s u=
nlimited, L1 unlimited
>>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal+ Un=
supported-
>>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                         MaxPayload 256 bytes, MaxReadReq 2048 bytes
>>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-=
 TransPend-
>>                 LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s, Late=
ncy L0 <2us, L1 unlimited
>>                         ClockPM- Suprise- LLActRep- BwNot-
>>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- C=
ommClk-
>>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                 LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- =
DLActive- BWMgmt- ABWMgmt-
>>         Capabilities: [c4] Message Signalled Interrupts: Mask- 64bit+ Qu=
eue=3D0/2 Enable-
>>                 Address: 0000000000000000  Data: 0000
>>         Capabilities: [d4] MSI-X: Enable- Mask- TabSize=3D4
>>                 Vector table: BAR=3D0 offset=3D0003e000
>>                 PBA: BAR=3D0 offset=3D00fff000
>>         Capabilities: [e0] Power Management version 2
>>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA PME(D0-,D1-=
,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>         Capabilities: [ec] Vital Product Data <?>
>>         Capabilities: [100] Power Budgeting <?>
>>         Kernel driver in use: megaraid_sas
>>
>> 06:03.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW WPCM=
450 [Hermon] - Winbond/Nuvoton (rev 0a) (prog-if 00 [VGA controller])
>>         Subsystem: Dell Device 0236
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParE=
rr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbor=
t- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 10
>>         Region 0: Memory at d9800000 (32-bit, prefetchable) [size=3D8M]
>>         Region 1: Memory at de7fc000 (32-bit, non-prefetchable) [size=3D=
16K]
>>         Region 2: Memory at de800000 (32-bit, non-prefetchable) [size=3D=
8M]
>>         [virtual] Expansion ROM at de000000 [disabled] [size=3D64K]
>>         Capabilities: [dc] Power Management version 1
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-=
,D2-,D3hot-,D3cold-)
>>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>
>> [7.6.] SCSI information (from /proc/scsi/scsi)
>> Attached devices:
>> Host: scsi0 Channel: 00 Id: 46 Lun: 00
>>   Vendor: Dell     Model: J23              Rev: R109
>>   Type:   Enclosure                        ANSI  SCSI revision: 05
>> Host: scsi0 Channel: 00 Id: 47 Lun: 00
>>   Vendor: Dell     Model: J23              Rev: R109
>>   Type:   Enclosure                        ANSI  SCSI revision: 05
>> Host: scsi0 Channel: 02 Id: 00 Lun: 00
>>   Vendor: DELL     Model: PERC 6/E Adapter Rev: 1.22
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi0 Channel: 02 Id: 01 Lun: 00
>>   Vendor: DELL     Model: PERC 6/E Adapter Rev: 1.22
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>> Host: scsi1 Channel: 02 Id: 00 Lun: 00
>>   Vendor: DELL     Model: PERC H700        Rev: 2.0.
>>   Type:   Direct-Access                    ANSI  SCSI revision: 05
>>
>> [7.7.] Other information that might be relevant to the problem
>>        (please look in /proc and include all information that you
>>        think to be relevant):
>> [X.] Other notes, patches, fixes, workarounds:
>> I think the problem is the H700 controller in combination with the megas=
as-driver.
>> We have a lot more systems running 2.6.33.2 and only the servers with th=
e H700 controller are giving this problem.
>> Also after some sime (after the scanning and oops) we experience user sp=
ace freezes.
>> I tried 2.6.34 and give the same problem, only not the 'scanning-loop', =
just 1 'scanning-line'.
>> It's on a production server so I didn't test 2.6.35, can't reproduce it =
on a test machine.
>>
>> Best Regards,
>>
>> Reinier
>> --
>> News-Service.com - European Usenet Provider
>> Luttenbergweg 4, 1101 EC Amsterdam
>> P.O BOX: 12026 1100 AA, Netherlands
>> http://www.news-service.com +31(0)20 398 1111
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--_003_4B6A08C587958942AA3002690DD4F8C3DBEF4AD0cosmail02lsicom_
Content-Type: text/plain; name="megaraid_sas.h"
Content-Description: megaraid_sas.h
Content-Disposition: attachment; filename="megaraid_sas.h"; size=31754;
	creation-date="Wed, 11 Aug 2010 11:30:44 GMT";
	modification-date="Tue, 10 Aug 2010 02:36:15 GMT"
Content-Transfer-Encoding: base64

LyoKICoKICoJCUxpbnV4IE1lZ2FSQUlEIGRyaXZlciBmb3IgU0FTIGJhc2VkIFJBSUQgY29udHJv
bGxlcnMKICoKICogQ29weXJpZ2h0IChjKSAyMDAzLTIwMDUgIExTSSBDb3Jwb3JhdGlvbi4KICoK
ICoJCVRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBp
dCBhbmQvb3IKICoJCW1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlCiAqCQlhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91
bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24KICoJCTIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3Vy
IG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCiAqCiAqIEZJTEUJCTogbWVnYXJhaWRfc2FzLmgK
ICovCgojaWZuZGVmIExTSV9NRUdBUkFJRF9TQVNfSAojZGVmaW5lIExTSV9NRUdBUkFJRF9TQVNf
SAoKLyoKICogTWVnYVJBSUQgU0FTIERyaXZlciBtZXRhIGRhdGEKICovCiNkZWZpbmUgTUVHQVNB
U19WRVJTSU9OCQkJIjAwLjAwLjA0LjMxLXJjMSIKI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQki
TWF5IDMsIDIwMTAiCiNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJIk1vbi4gTWF5IDMsIDEx
OjQxOjUxIFBTVCAyMDEwIgoKLyoKICogRGV2aWNlIElEcwogKi8KI2RlZmluZQlQQ0lfREVWSUNF
X0lEX0xTSV9TQVMxMDc4UgkJMHgwMDYwCiNkZWZpbmUJUENJX0RFVklDRV9JRF9MU0lfU0FTMTA3
OERFCQkweDAwN0MKI2RlZmluZQlQQ0lfREVWSUNFX0lEX0xTSV9WRVJERV9aQ1IJCTB4MDQxMwoj
ZGVmaW5lCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhHRU4yCQkweDAwNzgKI2RlZmluZQlQQ0lf
REVWSUNFX0lEX0xTSV9TQVMwMDc5R0VOMgkJMHgwMDc5CiNkZWZpbmUJUENJX0RFVklDRV9JRF9M
U0lfU0FTMDA3M1NLSU5OWQkJMHgwMDczCiNkZWZpbmUJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3
MVNLSU5OWQkJMHgwMDcxCgovKgogKiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09CiAqIE1lZ2FSQUlEIFNBUyBNRkkgZmlybXdhcmUgZGVmaW5pdGlvbnMKICogPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQogKi8KCi8qCiAqIE1GSSBzdGFuZHMgZm9yICBN
ZWdhUkFJRCBTQVMgRlcgSW50ZXJmYWNlLiBUaGlzIGlzIGp1c3QgYSBtb25pa2VyIGZvciAKICog
cHJvdG9jb2wgYmV0d2VlbiB0aGUgc29mdHdhcmUgYW5kIGZpcm13YXJlLiBDb21tYW5kcyBhcmUg
aXNzdWVkIHVzaW5nCiAqICJtZXNzYWdlIGZyYW1lcyIKICovCgovKgogKiBGVyBwb3N0cyBpdHMg
c3RhdGUgaW4gdXBwZXIgNCBiaXRzIG9mIG91dGJvdW5kX21zZ18wIHJlZ2lzdGVyCiAqLwojZGVm
aW5lIE1GSV9TVEFURV9NQVNLCQkJCTB4RjAwMDAwMDAKI2RlZmluZSBNRklfU1RBVEVfVU5ERUZJ
TkVECQkJMHgwMDAwMDAwMAojZGVmaW5lIE1GSV9TVEFURV9CQl9JTklUCQkJMHgxMDAwMDAwMAoj
ZGVmaW5lIE1GSV9TVEFURV9GV19JTklUCQkJMHg0MDAwMDAwMAojZGVmaW5lIE1GSV9TVEFURV9X
QUlUX0hBTkRTSEFLRQkJMHg2MDAwMDAwMAojZGVmaW5lIE1GSV9TVEFURV9GV19JTklUXzIJCQkw
eDcwMDAwMDAwCiNkZWZpbmUgTUZJX1NUQVRFX0RFVklDRV9TQ0FOCQkJMHg4MDAwMDAwMAojZGVm
aW5lIE1GSV9TVEFURV9CT09UX01FU1NBR0VfUEVORElORwkJMHg5MDAwMDAwMAojZGVmaW5lIE1G
SV9TVEFURV9GTFVTSF9DQUNIRQkJCTB4QTAwMDAwMDAKI2RlZmluZSBNRklfU1RBVEVfUkVBRFkJ
CQkJMHhCMDAwMDAwMAojZGVmaW5lIE1GSV9TVEFURV9PUEVSQVRJT05BTAkJCTB4QzAwMDAwMDAK
I2RlZmluZSBNRklfU1RBVEVfRkFVTFQJCQkJMHhGMDAwMDAwMAojZGVmaW5lICBNRklfUkVTRVRf
UkVRVUlSRUQJCQkweDAwMDAwMDAxCgojZGVmaW5lIE1FR0FNRklfRlJBTUVfU0laRQkJCTY0Cgov
KgogKiBEdXJpbmcgRlcgaW5pdCwgY2xlYXIgcGVuZGluZyBjbWRzICYgcmVzZXQgc3RhdGUgdXNp
bmcgaW5ib3VuZF9tc2dfMAogKgogKiBBQk9SVAk6IEFib3J0IGFsbCBwZW5kaW5nIGNtZHMKICog
UkVBRFkJOiBNb3ZlIGZyb20gT1BFUkFUSU9OQUwgdG8gUkVBRFkgc3RhdGU7IGRpc2NhcmQgcXVl
dWUgaW5mbwogKiBNRklNT0RFCTogRGlzY2FyZCAocG9zc2libGUpIGxvdyBNRkEgcG9zdGVkIGlu
IDY0LWJpdCBtb2RlICg/PykKICogQ0xSX0hBTkRTSEFLRTogRlcgaXMgd2FpdGluZyBmb3IgSEFO
RFNIQUtFIGZyb20gQklPUyBvciBEcml2ZXIKICogSE9UUExVRwk6IFJlc3VtZSBmcm9tIEhvdHBs
dWcKICogTUZJX1NUT1BfQURQCTogU2VuZCBzaWduYWwgdG8gRlcgdG8gc3RvcCBwcm9jZXNzaW5n
CiAqLwojZGVmaW5lIFdSSVRFX1NFUVVFTkNFX09GRlNFVAkJKDB4MDAwMDAwMEZDKSAvKiBJMjAg
Ki8KI2RlZmluZSBIT1NUX0RJQUdOT1NUSUNfT0ZGU0VUCQkoMHgwMDAwMDBGOCkgIC8qIEkyMCAq
LwojZGVmaW5lIERJQUdfV1JJVEVfRU5BQkxFCQkJKDB4MDAwMDAwODApCiNkZWZpbmUgRElBR19S
RVNFVF9BREFQVEVSCQkJKDB4MDAwMDAwMDQpCgojZGVmaW5lIE1GSV9BRFBfUkVTRVQJCQkJMHgw
MDAwMDA0MAojZGVmaW5lIE1GSV9JTklUX0FCT1JUCQkJCTB4MDAwMDAwMDEKI2RlZmluZSBNRklf
SU5JVF9SRUFEWQkJCQkweDAwMDAwMDAyCiNkZWZpbmUgTUZJX0lOSVRfTUZJTU9ERQkJCTB4MDAw
MDAwMDQKI2RlZmluZSBNRklfSU5JVF9DTEVBUl9IQU5EU0hBS0UJCTB4MDAwMDAwMDgKI2RlZmlu
ZSBNRklfSU5JVF9IT1RQTFVHCQkJMHgwMDAwMDAxMAojZGVmaW5lIE1GSV9TVE9QX0FEUAkJCQkw
eDAwMDAwMDIwCiNkZWZpbmUgTUZJX1JFU0VUX0ZMQUdTCQkJCU1GSV9JTklUX1JFQURZfCBcCgkJ
CQkJCU1GSV9JTklUX01GSU1PREV8IFwKCQkJCQkJTUZJX0lOSVRfQUJPUlQKCi8qCiAqIE1GSSBm
cmFtZSBmbGFncwogKi8KI2RlZmluZSBNRklfRlJBTUVfUE9TVF9JTl9SRVBMWV9RVUVVRQkJMHgw
MDAwCiNkZWZpbmUgTUZJX0ZSQU1FX0RPTlRfUE9TVF9JTl9SRVBMWV9RVUVVRQkweDAwMDEKI2Rl
ZmluZSBNRklfRlJBTUVfU0dMMzIJCQkJMHgwMDAwCiNkZWZpbmUgTUZJX0ZSQU1FX1NHTDY0CQkJ
CTB4MDAwMgojZGVmaW5lIE1GSV9GUkFNRV9TRU5TRTMyCQkJMHgwMDAwCiNkZWZpbmUgTUZJX0ZS
QU1FX1NFTlNFNjQJCQkweDAwMDQKI2RlZmluZSBNRklfRlJBTUVfRElSX05PTkUJCQkweDAwMDAK
I2RlZmluZSBNRklfRlJBTUVfRElSX1dSSVRFCQkJMHgwMDA4CiNkZWZpbmUgTUZJX0ZSQU1FX0RJ
Ul9SRUFECQkJMHgwMDEwCiNkZWZpbmUgTUZJX0ZSQU1FX0RJUl9CT1RICQkJMHgwMDE4CiNkZWZp
bmUgTUZJX0ZSQU1FX0lFRUUgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDAyMAoKLyoKICog
RGVmaW5pdGlvbiBmb3IgY21kX3N0YXR1cwogKi8KI2RlZmluZSBNRklfQ01EX1NUQVRVU19QT0xM
X01PREUJCTB4RkYKCi8qCiAqIE1GSSBjb21tYW5kIG9wY29kZXMKICovCiNkZWZpbmUgTUZJX0NN
RF9JTklUCQkJCTB4MDAKI2RlZmluZSBNRklfQ01EX0xEX1JFQUQJCQkJMHgwMQojZGVmaW5lIE1G
SV9DTURfTERfV1JJVEUJCQkweDAyCiNkZWZpbmUgTUZJX0NNRF9MRF9TQ1NJX0lPCQkJMHgwMwoj
ZGVmaW5lIE1GSV9DTURfUERfU0NTSV9JTwkJCTB4MDQKI2RlZmluZSBNRklfQ01EX0RDTUQJCQkJ
MHgwNQojZGVmaW5lIE1GSV9DTURfQUJPUlQJCQkJMHgwNgojZGVmaW5lIE1GSV9DTURfU01QCQkJ
CTB4MDcKI2RlZmluZSBNRklfQ01EX1NUUAkJCQkweDA4CgojZGVmaW5lIE1SX0RDTURfQ1RSTF9H
RVRfSU5GTwkJCTB4MDEwMTAwMDAKI2RlZmluZSBNUl9EQ01EX0xEX0dFVF9MSVNUCQkJMHgwMzAx
MDAwMAoKI2RlZmluZSBNUl9EQ01EX0NUUkxfQ0FDSEVfRkxVU0gJCTB4MDExMDEwMDAKI2RlZmlu
ZSBNUl9GTFVTSF9DVFJMX0NBQ0hFCQkJMHgwMQojZGVmaW5lIE1SX0ZMVVNIX0RJU0tfQ0FDSEUJ
CQkweDAyCgojZGVmaW5lIE1SX0RDTURfQ1RSTF9TSFVURE9XTgkJCTB4MDEwNTAwMDAKI2RlZmlu
ZSBNUl9EQ01EX0hJQkVSTkFURV9TSFVURE9XTgkJMHgwMTA2MDAwMAojZGVmaW5lIE1SX0VOQUJM
RV9EUklWRV9TUElORE9XTgkJMHgwMQoKI2RlZmluZSBNUl9EQ01EX0NUUkxfRVZFTlRfR0VUX0lO
Rk8JCTB4MDEwNDAxMDAKI2RlZmluZSBNUl9EQ01EX0NUUkxfRVZFTlRfR0VUCQkJMHgwMTA0MDMw
MAojZGVmaW5lIE1SX0RDTURfQ1RSTF9FVkVOVF9XQUlUCQkJMHgwMTA0MDUwMAojZGVmaW5lIE1S
X0RDTURfTERfR0VUX1BST1BFUlRJRVMJCTB4MDMwMzAwMDAKCiNkZWZpbmUgTVJfRENNRF9DTFVT
VEVSCQkJCTB4MDgwMDAwMDAKI2RlZmluZSBNUl9EQ01EX0NMVVNURVJfUkVTRVRfQUxMCQkweDA4
MDEwMTAwCiNkZWZpbmUgTVJfRENNRF9DTFVTVEVSX1JFU0VUX0xECQkweDA4MDEwMjAwCiNkZWZp
bmUgTVJfRENNRF9QRF9MSVNUX1FVRVJZICAgICAgICAgICAgICAgICAgIDB4MDIwMTAxMDAKCi8q
CiAqIE1GSSBjb21tYW5kIGNvbXBsZXRpb24gY29kZXMKICovCmVudW0gTUZJX1NUQVQgewoJTUZJ
X1NUQVRfT0sgPSAweDAwLAoJTUZJX1NUQVRfSU5WQUxJRF9DTUQgPSAweDAxLAoJTUZJX1NUQVRf
SU5WQUxJRF9EQ01EID0gMHgwMiwKCU1GSV9TVEFUX0lOVkFMSURfUEFSQU1FVEVSID0gMHgwMywK
CU1GSV9TVEFUX0lOVkFMSURfU0VRVUVOQ0VfTlVNQkVSID0gMHgwNCwKCU1GSV9TVEFUX0FCT1JU
X05PVF9QT1NTSUJMRSA9IDB4MDUsCglNRklfU1RBVF9BUFBfSE9TVF9DT0RFX05PVF9GT1VORCA9
IDB4MDYsCglNRklfU1RBVF9BUFBfSU5fVVNFID0gMHgwNywKCU1GSV9TVEFUX0FQUF9OT1RfSU5J
VElBTElaRUQgPSAweDA4LAoJTUZJX1NUQVRfQVJSQVlfSU5ERVhfSU5WQUxJRCA9IDB4MDksCglN
RklfU1RBVF9BUlJBWV9ST1dfTk9UX0VNUFRZID0gMHgwYSwKCU1GSV9TVEFUX0NPTkZJR19SRVNP
VVJDRV9DT05GTElDVCA9IDB4MGIsCglNRklfU1RBVF9ERVZJQ0VfTk9UX0ZPVU5EID0gMHgwYywK
CU1GSV9TVEFUX0RSSVZFX1RPT19TTUFMTCA9IDB4MGQsCglNRklfU1RBVF9GTEFTSF9BTExPQ19G
QUlMID0gMHgwZSwKCU1GSV9TVEFUX0ZMQVNIX0JVU1kgPSAweDBmLAoJTUZJX1NUQVRfRkxBU0hf
RVJST1IgPSAweDEwLAoJTUZJX1NUQVRfRkxBU0hfSU1BR0VfQkFEID0gMHgxMSwKCU1GSV9TVEFU
X0ZMQVNIX0lNQUdFX0lOQ09NUExFVEUgPSAweDEyLAoJTUZJX1NUQVRfRkxBU0hfTk9UX09QRU4g
PSAweDEzLAoJTUZJX1NUQVRfRkxBU0hfTk9UX1NUQVJURUQgPSAweDE0LAoJTUZJX1NUQVRfRkxV
U0hfRkFJTEVEID0gMHgxNSwKCU1GSV9TVEFUX0hPU1RfQ09ERV9OT1RfRk9VTlQgPSAweDE2LAoJ
TUZJX1NUQVRfTERfQ0NfSU5fUFJPR1JFU1MgPSAweDE3LAoJTUZJX1NUQVRfTERfSU5JVF9JTl9Q
Uk9HUkVTUyA9IDB4MTgsCglNRklfU1RBVF9MRF9MQkFfT1VUX09GX1JBTkdFID0gMHgxOSwKCU1G
SV9TVEFUX0xEX01BWF9DT05GSUdVUkVEID0gMHgxYSwKCU1GSV9TVEFUX0xEX05PVF9PUFRJTUFM
ID0gMHgxYiwKCU1GSV9TVEFUX0xEX1JCTERfSU5fUFJPR1JFU1MgPSAweDFjLAoJTUZJX1NUQVRf
TERfUkVDT05fSU5fUFJPR1JFU1MgPSAweDFkLAoJTUZJX1NUQVRfTERfV1JPTkdfUkFJRF9MRVZF
TCA9IDB4MWUsCglNRklfU1RBVF9NQVhfU1BBUkVTX0VYQ0VFREVEID0gMHgxZiwKCU1GSV9TVEFU
X01FTU9SWV9OT1RfQVZBSUxBQkxFID0gMHgyMCwKCU1GSV9TVEFUX01GQ19IV19FUlJPUiA9IDB4
MjEsCglNRklfU1RBVF9OT19IV19QUkVTRU5UID0gMHgyMiwKCU1GSV9TVEFUX05PVF9GT1VORCA9
IDB4MjMsCglNRklfU1RBVF9OT1RfSU5fRU5DTCA9IDB4MjQsCglNRklfU1RBVF9QRF9DTEVBUl9J
Tl9QUk9HUkVTUyA9IDB4MjUsCglNRklfU1RBVF9QRF9UWVBFX1dST05HID0gMHgyNiwKCU1GSV9T
VEFUX1BSX0RJU0FCTEVEID0gMHgyNywKCU1GSV9TVEFUX1JPV19JTkRFWF9JTlZBTElEID0gMHgy
OCwKCU1GSV9TVEFUX1NBU19DT05GSUdfSU5WQUxJRF9BQ1RJT04gPSAweDI5LAoJTUZJX1NUQVRf
U0FTX0NPTkZJR19JTlZBTElEX0RBVEEgPSAweDJhLAoJTUZJX1NUQVRfU0FTX0NPTkZJR19JTlZB
TElEX1BBR0UgPSAweDJiLAoJTUZJX1NUQVRfU0FTX0NPTkZJR19JTlZBTElEX1RZUEUgPSAweDJj
LAoJTUZJX1NUQVRfU0NTSV9ET05FX1dJVEhfRVJST1IgPSAweDJkLAoJTUZJX1NUQVRfU0NTSV9J
T19GQUlMRUQgPSAweDJlLAoJTUZJX1NUQVRfU0NTSV9SRVNFUlZBVElPTl9DT05GTElDVCA9IDB4
MmYsCglNRklfU1RBVF9TSFVURE9XTl9GQUlMRUQgPSAweDMwLAoJTUZJX1NUQVRfVElNRV9OT1Rf
U0VUID0gMHgzMSwKCU1GSV9TVEFUX1dST05HX1NUQVRFID0gMHgzMiwKCU1GSV9TVEFUX0xEX09G
RkxJTkUgPSAweDMzLAoJTUZJX1NUQVRfUEVFUl9OT1RJRklDQVRJT05fUkVKRUNURUQgPSAweDM0
LAoJTUZJX1NUQVRfUEVFUl9OT1RJRklDQVRJT05fRkFJTEVEID0gMHgzNSwKCU1GSV9TVEFUX1JF
U0VSVkFUSU9OX0lOX1BST0dSRVNTID0gMHgzNiwKCU1GSV9TVEFUX0kyQ19FUlJPUlNfREVURUNU
RUQgPSAweDM3LAoJTUZJX1NUQVRfUENJX0VSUk9SU19ERVRFQ1RFRCA9IDB4MzgsCgoJTUZJX1NU
QVRfSU5WQUxJRF9TVEFUVVMgPSAweEZGCn07CgovKgogKiBOdW1iZXIgb2YgbWFpbGJveCBieXRl
cyBpbiBEQ01EIG1lc3NhZ2UgZnJhbWUKICovCiNkZWZpbmUgTUZJX01CT1hfU0laRQkJCQkxMgoK
ZW51bSBNUl9FVlRfQ0xBU1MgewoKCU1SX0VWVF9DTEFTU19ERUJVRyA9IC0yLAoJTVJfRVZUX0NM
QVNTX1BST0dSRVNTID0gLTEsCglNUl9FVlRfQ0xBU1NfSU5GTyA9IDAsCglNUl9FVlRfQ0xBU1Nf
V0FSTklORyA9IDEsCglNUl9FVlRfQ0xBU1NfQ1JJVElDQUwgPSAyLAoJTVJfRVZUX0NMQVNTX0ZB
VEFMID0gMywKCU1SX0VWVF9DTEFTU19ERUFEID0gNCwKCn07CgplbnVtIE1SX0VWVF9MT0NBTEUg
ewoKCU1SX0VWVF9MT0NBTEVfTEQgPSAweDAwMDEsCglNUl9FVlRfTE9DQUxFX1BEID0gMHgwMDAy
LAoJTVJfRVZUX0xPQ0FMRV9FTkNMID0gMHgwMDA0LAoJTVJfRVZUX0xPQ0FMRV9CQlUgPSAweDAw
MDgsCglNUl9FVlRfTE9DQUxFX1NBUyA9IDB4MDAxMCwKCU1SX0VWVF9MT0NBTEVfQ1RSTCA9IDB4
MDAyMCwKCU1SX0VWVF9MT0NBTEVfQ09ORklHID0gMHgwMDQwLAoJTVJfRVZUX0xPQ0FMRV9DTFVT
VEVSID0gMHgwMDgwLAoJTVJfRVZUX0xPQ0FMRV9BTEwgPSAweGZmZmYsCgp9OwoKZW51bSBNUl9F
VlRfQVJHUyB7CgoJTVJfRVZUX0FSR1NfTk9ORSwKCU1SX0VWVF9BUkdTX0NEQl9TRU5TRSwKCU1S
X0VWVF9BUkdTX0xELAoJTVJfRVZUX0FSR1NfTERfQ09VTlQsCglNUl9FVlRfQVJHU19MRF9MQkEs
CglNUl9FVlRfQVJHU19MRF9PV05FUiwKCU1SX0VWVF9BUkdTX0xEX0xCQV9QRF9MQkEsCglNUl9F
VlRfQVJHU19MRF9QUk9HLAoJTVJfRVZUX0FSR1NfTERfU1RBVEUsCglNUl9FVlRfQVJHU19MRF9T
VFJJUCwKCU1SX0VWVF9BUkdTX1BELAoJTVJfRVZUX0FSR1NfUERfRVJSLAoJTVJfRVZUX0FSR1Nf
UERfTEJBLAoJTVJfRVZUX0FSR1NfUERfTEJBX0xELAoJTVJfRVZUX0FSR1NfUERfUFJPRywKCU1S
X0VWVF9BUkdTX1BEX1NUQVRFLAoJTVJfRVZUX0FSR1NfUENJLAoJTVJfRVZUX0FSR1NfUkFURSwK
CU1SX0VWVF9BUkdTX1NUUiwKCU1SX0VWVF9BUkdTX1RJTUUsCglNUl9FVlRfQVJHU19FQ0MsCglN
Ul9FVlRfQVJHU19MRF9QUk9QLAoJTVJfRVZUX0FSR1NfUERfU1BBUkUsCglNUl9FVlRfQVJHU19Q
RF9JTkRFWCwKCU1SX0VWVF9BUkdTX0RJQUdfUEFTUywKCU1SX0VWVF9BUkdTX0RJQUdfRkFJTCwK
CU1SX0VWVF9BUkdTX1BEX0xCQV9MQkEsCglNUl9FVlRfQVJHU19QT1JUX1BIWSwKCU1SX0VWVF9B
UkdTX1BEX01JU1NJTkcsCglNUl9FVlRfQVJHU19QRF9BRERSRVNTLAoJTVJfRVZUX0FSR1NfQklU
TUFQLAoJTVJfRVZUX0FSR1NfQ09OTkVDVE9SLAoJTVJfRVZUX0FSR1NfUERfUEQsCglNUl9FVlRf
QVJHU19QRF9GUlUsCglNUl9FVlRfQVJHU19QRF9QQVRISU5GTywKCU1SX0VWVF9BUkdTX1BEX1BP
V0VSX1NUQVRFLAoJTVJfRVZUX0FSR1NfR0VORVJJQywKfTsKCi8qCiAqIGRlZmluZSBjb25zdGFu
dHMgZm9yIGRldmljZSBsaXN0IHF1ZXJ5IG9wdGlvbnMKICovCmVudW0gTVJfUERfUVVFUllfVFlQ
RSB7CglNUl9QRF9RVUVSWV9UWVBFX0FMTCAgICAgICAgICAgICAgICA9IDAsCglNUl9QRF9RVUVS
WV9UWVBFX1NUQVRFICAgICAgICAgICAgICA9IDEsCglNUl9QRF9RVUVSWV9UWVBFX1BPV0VSX1NU
QVRFICAgICAgICA9IDIsCglNUl9QRF9RVUVSWV9UWVBFX01FRElBX1RZUEUgICAgICAgICA9IDMs
CglNUl9QRF9RVUVSWV9UWVBFX1NQRUVEICAgICAgICAgICAgICA9IDQsCglNUl9QRF9RVUVSWV9U
WVBFX0VYUE9TRURfVE9fSE9TVCAgICA9IDUsCn07CgojZGVmaW5lIE1SX0VWVF9DRkdfQ0xFQVJF
RCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDAwNAojZGVmaW5lIE1SX0VWVF9MRF9T
VEFURV9DSEFOR0UgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDA1MQojZGVmaW5lIE1SX0VW
VF9QRF9JTlNFUlRFRCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDA1YgojZGVmaW5l
IE1SX0VWVF9QRF9SRU1PVkVEICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDA3MAoj
ZGVmaW5lIE1SX0VWVF9MRF9DUkVBVEVEICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4
MDA4YQojZGVmaW5lIE1SX0VWVF9MRF9ERUxFVEVEICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIDB4MDA4YgojZGVmaW5lIE1SX0VWVF9GT1JFSUdOX0NGR19JTVBPUlRFRCAgICAgICAgICAg
ICAgICAgICAgIDB4MDBkYgojZGVmaW5lIE1SX0VWVF9MRF9PRkZMSU5FICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIDB4MDBmYwojZGVmaW5lIE1SX0VWVF9DVFJMX0hPU1RfQlVTX1NDQU5f
UkVRVUVTVEVEICAgICAgICAgICAgIDB4MDE1MgojZGVmaW5lIE1BWF9MT0dJQ0FMX0RSSVZFUwkJ
CQk2NAoKZW51bSBNUl9QRF9TVEFURSB7CglNUl9QRF9TVEFURV9VTkNPTkZJR1VSRURfR09PRCAg
ID0gMHgwMCwKCU1SX1BEX1NUQVRFX1VOQ09ORklHVVJFRF9CQUQgICAgPSAweDAxLAoJTVJfUERf
U1RBVEVfSE9UX1NQQVJFICAgICAgICAgICA9IDB4MDIsCglNUl9QRF9TVEFURV9PRkZMSU5FICAg
ICAgICAgICAgID0gMHgxMCwKCU1SX1BEX1NUQVRFX0ZBSUxFRCAgICAgICAgICAgICAgPSAweDEx
LAoJTVJfUERfU1RBVEVfUkVCVUlMRCAgICAgICAgICAgICA9IDB4MTQsCglNUl9QRF9TVEFURV9P
TkxJTkUgICAgICAgICAgICAgID0gMHgxOCwKCU1SX1BEX1NUQVRFX0NPUFlCQUNLICAgICAgICAg
ICAgPSAweDIwLAoJTVJfUERfU1RBVEVfU1lTVEVNICAgICAgICAgICAgICA9IDB4NDAsCiB9OwoK
CiAvKgogKiBkZWZpbmVzIHRoZSBwaHlzaWNhbCBkcml2ZSBhZGRyZXNzIHN0cnVjdHVyZQogKi8K
c3RydWN0IE1SX1BEX0FERFJFU1MgewoJdTE2ICAgICBkZXZpY2VJZDsKCXUxNiAgICAgZW5jbERl
dmljZUlkOwoKCXVuaW9uIHsKCQlzdHJ1Y3QgewoJCQl1OCAgZW5jbEluZGV4OwoJCQl1OCAgc2xv
dE51bWJlcjsKCQl9IG1yUGRBZGRyZXNzOwoJCXN0cnVjdCB7CgkJCXU4ICBlbmNsUG9zaXRpb247
CgkJCXU4ICBlbmNsQ29ubmVjdG9ySW5kZXg7CgkJfSBtckVuY2xBZGRyZXNzOwoJfTsKCXU4ICAg
ICAgc2NzaURldlR5cGU7Cgl1bmlvbiB7CgkJdTggICAgICBjb25uZWN0ZWRQb3J0Qml0bWFwOwoJ
CXU4ICAgICAgY29ubmVjdGVkUG9ydE51bWJlcnM7Cgl9OwoJdTY0ICAgICBzYXNBZGRyWzJdOwp9
IF9fcGFja2VkOwoKLyoKICogZGVmaW5lcyB0aGUgcGh5c2ljYWwgZHJpdmUgbGlzdCBzdHJ1Y3R1
cmUKICovCnN0cnVjdCBNUl9QRF9MSVNUIHsKCXUzMiAgICAgICAgICAgICBzaXplOwoJdTMyICAg
ICAgICAgICAgIGNvdW50OwoJc3RydWN0IE1SX1BEX0FERFJFU1MgICBhZGRyWzFdOwp9IF9fcGFj
a2VkOwoKc3RydWN0IG1lZ2FzYXNfcGRfbGlzdCB7Cgl1MTYgICAgICAgICAgICAgdGlkOwoJdTgg
ICAgICAgICAgICAgZHJpdmVUeXBlOwoJdTggICAgICAgICAgICAgZHJpdmVTdGF0ZTsKfSBfX3Bh
Y2tlZDsKCiAvKgogKiBkZWZpbmVzIHRoZSBsb2dpY2FsIGRyaXZlIHJlZmVyZW5jZSBzdHJ1Y3R1
cmUKICovCnVuaW9uICBNUl9MRF9SRUYgewoJc3RydWN0IHsKCQl1OCAgICAgIHRhcmdldElkOwoJ
CXU4ICAgICAgcmVzZXJ2ZWQ7CgkJdTE2ICAgICBzZXFOdW07Cgl9OwoJdTMyICAgICByZWY7Cn0g
X19wYWNrZWQ7CgovKgogKiBkZWZpbmVzIHRoZSBsb2dpY2FsIGRyaXZlIGxpc3Qgc3RydWN0dXJl
CiAqLwpzdHJ1Y3QgTVJfTERfTElTVCB7Cgl1MzIgICAgIGxkQ291bnQ7Cgl1MzIgICAgIHJlc2Vy
dmVkOwoJc3RydWN0IHsKCQl1bmlvbiBNUl9MRF9SRUYgICByZWY7CgkJdTggICAgICAgICAgc3Rh
dGU7CgkJdTggICAgICAgICAgcmVzZXJ2ZWRbM107CgkJdTY0ICAgICAgICAgc2l6ZTsKCX0gbGRM
aXN0W01BWF9MT0dJQ0FMX0RSSVZFU107Cn0gX19wYWNrZWQ7CgovKgogKiBTQVMgY29udHJvbGxl
ciBwcm9wZXJ0aWVzCiAqLwpzdHJ1Y3QgbWVnYXNhc19jdHJsX3Byb3AgewoKCXUxNiBzZXFfbnVt
OwoJdTE2IHByZWRfZmFpbF9wb2xsX2ludGVydmFsOwoJdTE2IGludHJfdGhyb3R0bGVfY291bnQ7
Cgl1MTYgaW50cl90aHJvdHRsZV90aW1lb3V0czsKCXU4IHJlYnVpbGRfcmF0ZTsKCXU4IHBhdHJv
bF9yZWFkX3JhdGU7Cgl1OCBiZ2lfcmF0ZTsKCXU4IGNjX3JhdGU7Cgl1OCByZWNvbl9yYXRlOwoJ
dTggY2FjaGVfZmx1c2hfaW50ZXJ2YWw7Cgl1OCBzcGludXBfZHJ2X2NvdW50OwoJdTggc3BpbnVw
X2RlbGF5OwoJdTggY2x1c3Rlcl9lbmFibGU7Cgl1OCBjb2VyY2lvbl9tb2RlOwoJdTggYWxhcm1f
ZW5hYmxlOwoJdTggZGlzYWJsZV9hdXRvX3JlYnVpbGQ7Cgl1OCBkaXNhYmxlX2JhdHRlcnlfd2Fy
bjsKCXU4IGVjY19idWNrZXRfc2l6ZTsKCXUxNiBlY2NfYnVja2V0X2xlYWtfcmF0ZTsKCXU4IHJl
c3RvcmVfaG90c3BhcmVfb25faW5zZXJ0aW9uOwoJdTggZXhwb3NlX2VuY2xfZGV2aWNlczsKCXU4
IG1haW50YWluUGRGYWlsSGlzdG9yeTsKCXU4IGRpc2FsbG93SG9zdFJlcXVlc3RSZW9yZGVyaW5n
OwoJdTggYWJvcnRDQ09uRXJyb3I7Cgl1OCBsb2FkQmFsYW5jZU1vZGU7Cgl1OCBkaXNhYmxlQXV0
b0RldGVjdEJhY2twbGFuZTsKCgl1OCBzbmFwVkRTcGFjZTsKCgkvKgoJKiBBZGQgcHJvcGVydGll
cyB0aGF0IGNhbiBiZSBjb250cm9sbGVkIGJ5CgkqIGEgYml0IGluIHRoZSBmb2xsb3dpbmcgc3Ry
dWN0dXJlLgoJKi8KCglzdHJ1Y3QgewoJCXUzMiAgICAgY29weUJhY2tEaXNhYmxlZCAgICAgICAg
ICAgIDogMTsKCQl1MzIgICAgIFNNQVJUZXJFbmFibGVkICAgICAgICAgICAgICA6IDE7CgkJdTMy
ICAgICBwckNvcnJlY3RVbmNvbmZpZ3VyZWRBcmVhcyAgOiAxOwoJCXUzMiAgICAgdXNlRmRlT25s
eSAgICAgICAgICAgICAgICAgIDogMTsKCQl1MzIgICAgIGRpc2FibGVOQ1EgICAgICAgICAgICAg
ICAgICA6IDE7CgkJdTMyICAgICBTU0RTTUFSVGVyRW5hYmxlZCAgICAgICAgICAgOiAxOwoJCXUz
MiAgICAgU1NEUGF0cm9sUmVhZEVuYWJsZWQgICAgICAgIDogMTsKCQl1MzIgICAgIGVuYWJsZVNw
aW5Eb3duVW5jb25maWd1cmVkICA6IDE7CgkJdTMyICAgICBhdXRvRW5oYW5jZWRJbXBvcnQgICAg
ICAgICAgOiAxOwoJCXUzMiAgICAgZW5hYmxlU2VjcmV0S2V5Q29udHJvbCAgICAgIDogMTsKCQl1
MzIgICAgIGRpc2FibGVPbmxpbmVDdHJsUmVzZXQgICAgICA6IDE7CgkJdTMyICAgICBhbGxvd0Jv
b3RXaXRoUGlubmVkQ2FjaGUgICAgOiAxOwoJCXUzMiAgICAgZGlzYWJsZVNwaW5Eb3duSFMgICAg
ICAgICAgIDogMTsKCQl1MzIgICAgIGVuYWJsZUpCT0QgICAgICAgICAgICAgICAgICA6IDE7CgkJ
dTMyICAgICByZXNlcnZlZCAgICAgICAgICAgICAgICAgICAgOjE4OwoJfSBPbk9mZlByb3BlcnRp
ZXM7Cgl1OCBhdXRvU25hcFZEU3BhY2U7Cgl1OCB2aWV3U3BhY2U7Cgl1MTYgc3BpbkRvd25UaW1l
OwoJdTggIHJlc2VydmVkWzI0XTsKfSBfX3BhY2tlZDsKCi8qCiAqIFNBUyBjb250cm9sbGVyIGlu
Zm9ybWF0aW9uCiAqLwpzdHJ1Y3QgbWVnYXNhc19jdHJsX2luZm8gewoKCS8qCgkgKiBQQ0kgZGV2
aWNlIGluZm9ybWF0aW9uCgkgKi8KCXN0cnVjdCB7CgoJCXUxNiB2ZW5kb3JfaWQ7CgkJdTE2IGRl
dmljZV9pZDsKCQl1MTYgc3ViX3ZlbmRvcl9pZDsKCQl1MTYgc3ViX2RldmljZV9pZDsKCQl1OCBy
ZXNlcnZlZFsyNF07CgoJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgcGNpOwoKCS8qCgkgKiBI
b3N0IGludGVyZmFjZSBpbmZvcm1hdGlvbgoJICovCglzdHJ1Y3QgewoKCQl1OCBQQ0lYOjE7CgkJ
dTggUENJRToxOwoJCXU4IGlTQ1NJOjE7CgkJdTggU0FTXzNHOjE7CgkJdTggcmVzZXJ2ZWRfMDo0
OwoJCXU4IHJlc2VydmVkXzFbNl07CgkJdTggcG9ydF9jb3VudDsKCQl1NjQgcG9ydF9hZGRyWzhd
OwoKCX0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpIGhvc3RfaW50ZXJmYWNlOwoKCS8qCgkgKiBE
ZXZpY2UgKGJhY2tlbmQpIGludGVyZmFjZSBpbmZvcm1hdGlvbgoJICovCglzdHJ1Y3QgewoKCQl1
OCBTUEk6MTsKCQl1OCBTQVNfM0c6MTsKCQl1OCBTQVRBXzFfNUc6MTsKCQl1OCBTQVRBXzNHOjE7
CgkJdTggcmVzZXJ2ZWRfMDo0OwoJCXU4IHJlc2VydmVkXzFbNl07CgkJdTggcG9ydF9jb3VudDsK
CQl1NjQgcG9ydF9hZGRyWzhdOwoKCX0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpIGRldmljZV9p
bnRlcmZhY2U7CgoJLyoKCSAqIExpc3Qgb2YgY29tcG9uZW50cyByZXNpZGluZyBpbiBmbGFzaC4g
QWxsIHN0ciBhcmUgbnVsbCB0ZXJtaW5hdGVkCgkgKi8KCXUzMiBpbWFnZV9jaGVja193b3JkOwoJ
dTMyIGltYWdlX2NvbXBvbmVudF9jb3VudDsKCglzdHJ1Y3QgewoKCQljaGFyIG5hbWVbOF07CgkJ
Y2hhciB2ZXJzaW9uWzMyXTsKCQljaGFyIGJ1aWxkX2RhdGVbMTZdOwoJCWNoYXIgYnVpbHRfdGlt
ZVsxNl07CgoJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgaW1hZ2VfY29tcG9uZW50WzhdOwoK
CS8qCgkgKiBMaXN0IG9mIGZsYXNoIGNvbXBvbmVudHMgdGhhdCBoYXZlIGJlZW4gZmxhc2hlZCBv
biB0aGUgY2FyZCwgYnV0CgkgKiBhcmUgbm90IGluIHVzZSwgcGVuZGluZyByZXNldCBvZiB0aGUg
YWRhcHRlci4gVGhpcyBsaXN0IHdpbGwgYmUKCSAqIGVtcHR5IGlmIGEgZmxhc2ggb3BlcmF0aW9u
IGhhcyBub3Qgb2NjdXJyZWQuIEFsbCBzdGluZ3MgYXJlIG51bGwKCSAqIHRlcm1pbmF0ZWQKCSAq
LwoJdTMyIHBlbmRpbmdfaW1hZ2VfY29tcG9uZW50X2NvdW50OwoKCXN0cnVjdCB7CgoJCWNoYXIg
bmFtZVs4XTsKCQljaGFyIHZlcnNpb25bMzJdOwoJCWNoYXIgYnVpbGRfZGF0ZVsxNl07CgkJY2hh
ciBidWlsZF90aW1lWzE2XTsKCgl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSBwZW5kaW5nX2lt
YWdlX2NvbXBvbmVudFs4XTsKCgl1OCBtYXhfYXJtczsKCXU4IG1heF9zcGFuczsKCXU4IG1heF9h
cnJheXM7Cgl1OCBtYXhfbGRzOwoKCWNoYXIgcHJvZHVjdF9uYW1lWzgwXTsKCWNoYXIgc2VyaWFs
X25vWzMyXTsKCgkvKgoJICogT3RoZXIgcGh5c2ljYWwvY29udHJvbGxlci9vcGVyYXRpb24gaW5m
b3JtYXRpb24uIEluZGljYXRlcyB0aGUKCSAqIHByZXNlbmNlIG9mIHRoZSBoYXJkd2FyZQoJICov
CglzdHJ1Y3QgewoKCQl1MzIgYmJ1OjE7CgkJdTMyIGFsYXJtOjE7CgkJdTMyIG52cmFtOjE7CgkJ
dTMyIHVhcnQ6MTsKCQl1MzIgcmVzZXJ2ZWQ6Mjg7CgoJfSBfX2F0dHJpYnV0ZV9fICgocGFja2Vk
KSkgaHdfcHJlc2VudDsKCgl1MzIgY3VycmVudF9md190aW1lOwoKCS8qCgkgKiBNYXhpbXVtIGRh
dGEgdHJhbnNmZXIgc2l6ZXMKCSAqLwoJdTE2IG1heF9jb25jdXJyZW50X2NtZHM7Cgl1MTYgbWF4
X3NnZV9jb3VudDsKCXUzMiBtYXhfcmVxdWVzdF9zaXplOwoKCS8qCgkgKiBMb2dpY2FsIGFuZCBw
aHlzaWNhbCBkZXZpY2UgY291bnRzCgkgKi8KCXUxNiBsZF9wcmVzZW50X2NvdW50OwoJdTE2IGxk
X2RlZ3JhZGVkX2NvdW50OwoJdTE2IGxkX29mZmxpbmVfY291bnQ7CgoJdTE2IHBkX3ByZXNlbnRf
Y291bnQ7Cgl1MTYgcGRfZGlza19wcmVzZW50X2NvdW50OwoJdTE2IHBkX2Rpc2tfcHJlZF9mYWls
dXJlX2NvdW50OwoJdTE2IHBkX2Rpc2tfZmFpbGVkX2NvdW50OwoKCS8qCgkgKiBNZW1vcnkgc2l6
ZSBpbmZvcm1hdGlvbgoJICovCgl1MTYgbnZyYW1fc2l6ZTsKCXUxNiBtZW1vcnlfc2l6ZTsKCXUx
NiBmbGFzaF9zaXplOwoKCS8qCgkgKiBFcnJvciBjb3VudGVycwoJICovCgl1MTYgbWVtX2NvcnJl
Y3RhYmxlX2Vycm9yX2NvdW50OwoJdTE2IG1lbV91bmNvcnJlY3RhYmxlX2Vycm9yX2NvdW50OwoK
CS8qCgkgKiBDbHVzdGVyIGluZm9ybWF0aW9uCgkgKi8KCXU4IGNsdXN0ZXJfcGVybWl0dGVkOwoJ
dTggY2x1c3Rlcl9hY3RpdmU7CgoJLyoKCSAqIEFkZGl0aW9uYWwgbWF4IGRhdGEgdHJhbnNmZXIg
c2l6ZXMKCSAqLwoJdTE2IG1heF9zdHJpcHNfcGVyX2lvOwoKCS8qCgkgKiBDb250cm9sbGVyIGNh
cGFiaWxpdGllcyBzdHJ1Y3R1cmVzCgkgKi8KCXN0cnVjdCB7CgoJCXUzMiByYWlkX2xldmVsXzA6
MTsKCQl1MzIgcmFpZF9sZXZlbF8xOjE7CgkJdTMyIHJhaWRfbGV2ZWxfNToxOwoJCXUzMiByYWlk
X2xldmVsXzFFOjE7CgkJdTMyIHJhaWRfbGV2ZWxfNjoxOwoJCXUzMiByZXNlcnZlZDoyNzsKCgl9
IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSByYWlkX2xldmVsczsKCglzdHJ1Y3QgewoKCQl1MzIg
cmJsZF9yYXRlOjE7CgkJdTMyIGNjX3JhdGU6MTsKCQl1MzIgYmdpX3JhdGU6MTsKCQl1MzIgcmVj
b25fcmF0ZToxOwoJCXUzMiBwYXRyb2xfcmF0ZToxOwoJCXUzMiBhbGFybV9jb250cm9sOjE7CgkJ
dTMyIGNsdXN0ZXJfc3VwcG9ydGVkOjE7CgkJdTMyIGJidToxOwoJCXUzMiBzcGFubmluZ19hbGxv
d2VkOjE7CgkJdTMyIGRlZGljYXRlZF9ob3RzcGFyZXM6MTsKCQl1MzIgcmV2ZXJ0aWJsZV9ob3Rz
cGFyZXM6MTsKCQl1MzIgZm9yZWlnbl9jb25maWdfaW1wb3J0OjE7CgkJdTMyIHNlbGZfZGlhZ25v
c3RpYzoxOwoJCXUzMiBtaXhlZF9yZWR1bmRhbmN5X2FycjoxOwoJCXUzMiBnbG9iYWxfaG90X3Nw
YXJlczoxOwoJCXUzMiByZXNlcnZlZDoxNzsKCgl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSBh
ZGFwdGVyX29wZXJhdGlvbnM7CgoJc3RydWN0IHsKCgkJdTMyIHJlYWRfcG9saWN5OjE7CgkJdTMy
IHdyaXRlX3BvbGljeToxOwoJCXUzMiBpb19wb2xpY3k6MTsKCQl1MzIgYWNjZXNzX3BvbGljeTox
OwoJCXUzMiBkaXNrX2NhY2hlX3BvbGljeToxOwoJCXUzMiByZXNlcnZlZDoyNzsKCgl9IF9fYXR0
cmlidXRlX18gKChwYWNrZWQpKSBsZF9vcGVyYXRpb25zOwoKCXN0cnVjdCB7CgoJCXU4IG1pbjsK
CQl1OCBtYXg7CgkJdTggcmVzZXJ2ZWRbMl07CgoJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkg
c3RyaXBlX3N6X29wczsKCglzdHJ1Y3QgewoKCQl1MzIgZm9yY2Vfb25saW5lOjE7CgkJdTMyIGZv
cmNlX29mZmxpbmU6MTsKCQl1MzIgZm9yY2VfcmVidWlsZDoxOwoJCXUzMiByZXNlcnZlZDoyOTsK
Cgl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSBwZF9vcGVyYXRpb25zOwoKCXN0cnVjdCB7CgoJ
CXUzMiBjdHJsX3N1cHBvcnRzX3NhczoxOwoJCXUzMiBjdHJsX3N1cHBvcnRzX3NhdGE6MTsKCQl1
MzIgYWxsb3dfbWl4X2luX2VuY2w6MTsKCQl1MzIgYWxsb3dfbWl4X2luX2xkOjE7CgkJdTMyIGFs
bG93X3NhdGFfaW5fY2x1c3RlcjoxOwoJCXUzMiByZXNlcnZlZDoyNzsKCgl9IF9fYXR0cmlidXRl
X18gKChwYWNrZWQpKSBwZF9taXhfc3VwcG9ydDsKCgkvKgoJICogRGVmaW5lIEVDQyBzaW5nbGUt
Yml0LWVycm9yIGJ1Y2tldCBpbmZvcm1hdGlvbgoJICovCgl1OCBlY2NfYnVja2V0X2NvdW50OwoJ
dTggcmVzZXJ2ZWRfMlsxMV07CgoJLyoKCSAqIEluY2x1ZGUgdGhlIGNvbnRyb2xsZXIgcHJvcGVy
dGllcyAoY2hhbmdlYWJsZSBpdGVtcykKCSAqLwoJc3RydWN0IG1lZ2FzYXNfY3RybF9wcm9wIHBy
b3BlcnRpZXM7CgoJLyoKCSAqIERlZmluZSBGVyBwa2cgdmVyc2lvbiAoc2V0IGluIGVudnQgdidi
bGVzIG9uIE9FTSBiYXNpcykKCSAqLwoJY2hhciBwYWNrYWdlX3ZlcnNpb25bMHg2MF07CgoJdTgg
cGFkWzB4ODAwIC0gMHg2YTBdOwoKfSBfX3BhY2tlZDsKCi8qCiAqID09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KICogTWVnYVJBSUQgU0FTIGRyaXZlciBkZWZpbml0aW9ucwogKiA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09CiAqLwojZGVmaW5lIE1FR0FTQVNfTUFYX1BEX0NI
QU5ORUxTCQkJMgojZGVmaW5lIE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxTCQkJMgojZGVmaW5lIE1F
R0FTQVNfTUFYX0NIQU5ORUxTCQkJKE1FR0FTQVNfTUFYX1BEX0NIQU5ORUxTICsgXAoJCQkJCQlN
RUdBU0FTX01BWF9MRF9DSEFOTkVMUykKI2RlZmluZSBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5O
RUwJCTEyOAojZGVmaW5lIE1FR0FTQVNfREVGQVVMVF9JTklUX0lECQkJLTEKI2RlZmluZSBNRUdB
U0FTX01BWF9MVU4JCQkJOAojZGVmaW5lIE1FR0FTQVNfTUFYX0xECQkJCTY0CiNkZWZpbmUgTUVH
QVNBU19NQVhfUEQgICAgICAgICAgICAgICAgICAgICAgICAgIChNRUdBU0FTX01BWF9QRF9DSEFO
TkVMUyAqIFwKCQkJCQkJTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKQojZGVmaW5lIE1FR0FT
QVNfTUFYX0xEX0lEUwkJCShNRUdBU0FTX01BWF9MRF9DSEFOTkVMUyAqIFwKCQkJCQkJTUVHQVNB
U19NQVhfREVWX1BFUl9DSEFOTkVMKQoKI2RlZmluZSBNRUdBU0FTX01BWF9TRUNUT1JTICAgICAg
ICAgICAgICAgICAgICAoMioxMDI0KQojZGVmaW5lIE1FR0FTQVNfREJHX0xWTAkJCQkxCgojZGVm
aW5lIE1FR0FTQVNfRldfQlVTWQkJCQkxCgovKiBGcmFtZSBUeXBlICovCiNkZWZpbmUgSU9fRlJB
TUUJCQkJMAojZGVmaW5lIFBUSFJVX0ZSQU1FCQkJCTEKCi8qCiAqIFdoZW4gU0NTSSBtaWQtbGF5
ZXIgY2FsbHMgZHJpdmVyJ3MgcmVzZXQgcm91dGluZSwgZHJpdmVyIHdhaXRzIGZvcgogKiBNRUdB
U0FTX1JFU0VUX1dBSVRfVElNRSBzZWNvbmRzIGZvciBhbGwgb3V0c3RhbmRpbmcgSU8gdG8gY29t
cGxldGUuIE5vdGUKICogdGhhdCB0aGUgZHJpdmVyIGNhbm5vdCBfYWN0dWFsbHlfIGFib3J0IG9y
IHJlc2V0IHBlbmRpbmcgY29tbWFuZHMuIFdoaWxlCiAqIGl0IGlzIHdhaXRpbmcgZm9yIHRoZSBj
b21tYW5kcyB0byBjb21wbGV0ZSwgaXQgcHJpbnRzIGEgZGlhZ25vc3RpYyBtZXNzYWdlCiAqIGV2
ZXJ5IE1FR0FTQVNfUkVTRVRfTk9USUNFX0lOVEVSVkFMIHNlY29uZHMKICovCiNkZWZpbmUgTUVH
QVNBU19SRVNFVF9XQUlUX1RJTUUJCQkxODAKI2RlZmluZSBNRUdBU0FTX0lOVEVSTkFMX0NNRF9X
QUlUX1RJTUUJCTE4MAojZGVmaW5lCU1FR0FTQVNfUkVTRVRfTk9USUNFX0lOVEVSVkFMCQk1CiNk
ZWZpbmUgTUVHQVNBU19JT0NUTF9DTUQJCQkwCiNkZWZpbmUgTUVHQVNBU19ERUZBVUxUX0NNRF9U
SU1FT1VUCQk5MAoKLyoKICogRlcgcmVwb3J0cyB0aGUgbWF4aW11bSBvZiBudW1iZXIgb2YgY29t
bWFuZHMgdGhhdCBpdCBjYW4gYWNjZXB0IChtYXhpbXVtCiAqIGNvbW1hbmRzIHRoYXQgY2FuIGJl
IG91dHN0YW5kaW5nKSBhdCBhbnkgdGltZS4gVGhlIGRyaXZlciBtdXN0IHJlcG9ydCBhCiAqIGxv
d2VyIG51bWJlciB0byB0aGUgbWlkIGxheWVyIGJlY2F1c2UgaXQgY2FuIGlzc3VlIGEgZmV3IGlu
dGVybmFsIGNvbW1hbmRzCiAqIGl0c2VsZiAoRS5nLCBBRU4sIGFib3J0IGNtZCwgSU9DVExzIGV0
YykuIFRoZSBudW1iZXIgb2YgY29tbWFuZHMgaXQgbmVlZHMKICogaXMgc2hvd24gYmVsb3cKICov
CiNkZWZpbmUgTUVHQVNBU19JTlRfQ01EUwkJCTMyCiNkZWZpbmUgTUVHQVNBU19TS0lOTllfSU5U
X0NNRFMJCQk1CgovKgogKiBGVyBjYW4gYWNjZXB0IGJvdGggMzIgYW5kIDY0IGJpdCBTR0xzLiBX
ZSB3YW50IHRvIGFsbG9jYXRlIDMyLzY0IGJpdAogKiBTR0xzIGJhc2VkIG9uIHRoZSBzaXplIG9m
IGRtYV9hZGRyX3QKICovCiNkZWZpbmUgSVNfRE1BNjQJCQkJKHNpemVvZihkbWFfYWRkcl90KSA9
PSA4KQoKI2RlZmluZSBNRklfWFNDQUxFX09NUjBfQ0hBTkdFX0lOVEVSUlVQVAkJMHgwMDAwMDAw
MQoKI2RlZmluZSBNRklfSU5UUl9GTEFHX1JFUExZX01FU1NBR0UJCQkweDAwMDAwMDAxCiNkZWZp
bmUgTUZJX0lOVFJfRkxBR19GSVJNV0FSRV9TVEFURV9DSEFOR0UJCTB4MDAwMDAwMDIKI2RlZmlu
ZSBNRklfRzJfT1VUQk9VTkRfRE9PUkJFTExfQ0hBTkdFX0lOVEVSUlVQVAkweDAwMDAwMDA0Cgoj
ZGVmaW5lIE1GSV9PQl9JTlRSX1NUQVRVU19NQVNLCQkJMHgwMDAwMDAwMgojZGVmaW5lIE1GSV9Q
T0xMX1RJTUVPVVRfU0VDUwkJCTYwCiNkZWZpbmUgTUVHQVNBU19DT01QTEVUSU9OX1RJTUVSX0lO
VEVSVkFMICAgICAgKEhaLzEwKQoKI2RlZmluZSBNRklfUkVQTFlfMTA3OF9NRVNTQUdFX0lOVEVS
UlVQVAkweDgwMDAwMDAwCiNkZWZpbmUgTUZJX1JFUExZX0dFTjJfTUVTU0FHRV9JTlRFUlJVUFQJ
MHgwMDAwMDAwMQojZGVmaW5lIE1GSV9HRU4yX0VOQUJMRV9JTlRFUlJVUFRfTUFTSwkJKDB4MDAw
MDAwMDEgfCAweDAwMDAwMDA0KQojZGVmaW5lIE1GSV9SRVBMWV9TS0lOTllfTUVTU0FHRV9JTlRF
UlJVUFQJMHg0MDAwMDAwMAojZGVmaW5lIE1GSV9TS0lOTllfRU5BQkxFX0lOVEVSUlVQVF9NQVNL
CSgweDAwMDAwMDAxKQoKI2RlZmluZSBNRklfMTA2OF9QQ1NSX09GRlNFVAkJCTB4ODQKI2RlZmlu
ZSBNRklfMTA2OF9GV19IQU5EU0hBS0VfT0ZGU0VUCQkweDY0CiNkZWZpbmUgTUZJXzEwNjhfRldf
UkVBRFkJCQkweEREREQwMDAwCi8qCiogcmVnaXN0ZXIgc2V0IGZvciBib3RoIDEwNjggYW5kIDEw
NzggY29udHJvbGxlcnMKKiBzdHJ1Y3R1cmUgZXh0ZW5kZWQgZm9yIDEwNzggcmVnaXN0ZXJzCiov
CiAKc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IHsKCXUzMiAJcmVzZXJ2ZWRfMFs0XTsJCQkv
KjAwMDBoKi8KCgl1MzIgCWluYm91bmRfbXNnXzA7CQkJLyowMDEwaCovCgl1MzIgCWluYm91bmRf
bXNnXzE7CQkJLyowMDE0aCovCgl1MzIgCW91dGJvdW5kX21zZ18wOwkJCS8qMDAxOGgqLwoJdTMy
IAlvdXRib3VuZF9tc2dfMTsJCQkvKjAwMUNoKi8KCgl1MzIgCWluYm91bmRfZG9vcmJlbGw7CQkv
KjAwMjBoKi8KCXUzMiAJaW5ib3VuZF9pbnRyX3N0YXR1czsJCS8qMDAyNGgqLwoJdTMyIAlpbmJv
dW5kX2ludHJfbWFzazsJCS8qMDAyOGgqLwoKCXUzMiAJb3V0Ym91bmRfZG9vcmJlbGw7CQkvKjAw
MkNoKi8KCXUzMiAJb3V0Ym91bmRfaW50cl9zdGF0dXM7CQkvKjAwMzBoKi8KCXUzMiAJb3V0Ym91
bmRfaW50cl9tYXNrOwkJLyowMDM0aCovCgoJdTMyIAlyZXNlcnZlZF8xWzJdOwkJCS8qMDAzOGgq
LwoKCXUzMiAJaW5ib3VuZF9xdWV1ZV9wb3J0OwkJLyowMDQwaCovCgl1MzIgCW91dGJvdW5kX3F1
ZXVlX3BvcnQ7CQkvKjAwNDRoKi8KCgl1MzIgCXJlc2VydmVkXzJbMjJdOwkJCS8qMDA0OGgqLwoK
CXUzMiAJb3V0Ym91bmRfZG9vcmJlbGxfY2xlYXI7CS8qMDBBMGgqLwoKCXUzMiAJcmVzZXJ2ZWRf
M1szXTsJCQkvKjAwQTRoKi8KCgl1MzIgCW91dGJvdW5kX3NjcmF0Y2hfcGFkIDsJCS8qMDBCMGgq
LwoKCXUzMiAJcmVzZXJ2ZWRfNFszXTsJCQkvKjAwQjRoKi8KCgl1MzIgCWluYm91bmRfbG93X3F1
ZXVlX3BvcnQgOwkvKjAwQzBoKi8KCgl1MzIgCWluYm91bmRfaGlnaF9xdWV1ZV9wb3J0IDsJLyow
MEM0aCovCgoJdTMyIAlyZXNlcnZlZF81OwkJCS8qMDBDOGgqLwoJdTMyCXJlc182WzExXTsJCQkv
KkNDaCovCgl1MzIJaG9zdF9kaWFnOwoJdTMyCXNlcV9vZmZzZXQ7Cgl1MzIgCWluZGV4X3JlZ2lz
dGVyc1s4MDddOwkJLyowMENDaCovCn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoKc3RydWN0
IG1lZ2FzYXNfc2dlMzIgewoKCXUzMiBwaHlzX2FkZHI7Cgl1MzIgbGVuZ3RoOwoKfSBfX2F0dHJp
YnV0ZV9fICgocGFja2VkKSk7CgpzdHJ1Y3QgbWVnYXNhc19zZ2U2NCB7CgoJdTY0IHBoeXNfYWRk
cjsKCXUzMiBsZW5ndGg7Cgp9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKTsKCnN0cnVjdCBtZWdh
c2FzX3NnZV9za2lubnkgewoJdTY0IHBoeXNfYWRkcjsKCXUzMiBsZW5ndGg7Cgl1MzIgZmxhZzsK
fSBfX3BhY2tlZDsKCnVuaW9uIG1lZ2FzYXNfc2dsIHsKCglzdHJ1Y3QgbWVnYXNhc19zZ2UzMiBz
Z2UzMlsxXTsKCXN0cnVjdCBtZWdhc2FzX3NnZTY0IHNnZTY0WzFdOwoJc3RydWN0IG1lZ2FzYXNf
c2dlX3NraW5ueSBzZ2Vfc2tpbm55WzFdOwoKfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7Cgpz
dHJ1Y3QgbWVnYXNhc19oZWFkZXIgewoKCXU4IGNtZDsJCQkvKjAwaCAqLwoJdTggc2Vuc2VfbGVu
OwkJLyowMWggKi8KCXU4IGNtZF9zdGF0dXM7CQkvKjAyaCAqLwoJdTggc2NzaV9zdGF0dXM7CQkv
KjAzaCAqLwoKCXU4IHRhcmdldF9pZDsJCS8qMDRoICovCgl1OCBsdW47CQkJLyowNWggKi8KCXU4
IGNkYl9sZW47CQkvKjA2aCAqLwoJdTggc2dlX2NvdW50OwkJLyowN2ggKi8KCgl1MzIgY29udGV4
dDsJCS8qMDhoICovCgl1MzIgcGFkXzA7CQkvKjBDaCAqLwoKCXUxNiBmbGFnczsJCS8qMTBoICov
Cgl1MTYgdGltZW91dDsJCS8qMTJoICovCgl1MzIgZGF0YV94ZmVybGVuOwkvKjE0aCAqLwoKfSBf
X2F0dHJpYnV0ZV9fICgocGFja2VkKSk7Cgp1bmlvbiBtZWdhc2FzX3NnbF9mcmFtZSB7CgoJc3Ry
dWN0IG1lZ2FzYXNfc2dlMzIgc2dlMzJbOF07CglzdHJ1Y3QgbWVnYXNhc19zZ2U2NCBzZ2U2NFs1
XTsKCn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoKc3RydWN0IG1lZ2FzYXNfaW5pdF9mcmFt
ZSB7CgoJdTggY21kOwkJCS8qMDBoICovCgl1OCByZXNlcnZlZF8wOwkJLyowMWggKi8KCXU4IGNt
ZF9zdGF0dXM7CQkvKjAyaCAqLwoKCXU4IHJlc2VydmVkXzE7CQkvKjAzaCAqLwoJdTMyIHJlc2Vy
dmVkXzI7CQkvKjA0aCAqLwoKCXUzMiBjb250ZXh0OwkJLyowOGggKi8KCXUzMiBwYWRfMDsJCS8q
MENoICovCgoJdTE2IGZsYWdzOwkJLyoxMGggKi8KCXUxNiByZXNlcnZlZF8zOwkJLyoxMmggKi8K
CXUzMiBkYXRhX3hmZXJfbGVuOwkvKjE0aCAqLwoKCXUzMiBxdWV1ZV9pbmZvX25ld19waHlzX2Fk
ZHJfbG87CS8qMThoICovCgl1MzIgcXVldWVfaW5mb19uZXdfcGh5c19hZGRyX2hpOwkvKjFDaCAq
LwoJdTMyIHF1ZXVlX2luZm9fb2xkX3BoeXNfYWRkcl9sbzsJLyoyMGggKi8KCXUzMiBxdWV1ZV9p
bmZvX29sZF9waHlzX2FkZHJfaGk7CS8qMjRoICovCgoJdTMyIHJlc2VydmVkXzRbNl07CS8qMjho
ICovCgp9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKTsKCnN0cnVjdCBtZWdhc2FzX2luaXRfcXVl
dWVfaW5mbyB7CgoJdTMyIGluaXRfZmxhZ3M7CQkvKjAwaCAqLwoJdTMyIHJlcGx5X3F1ZXVlX2Vu
dHJpZXM7CS8qMDRoICovCgoJdTMyIHJlcGx5X3F1ZXVlX3N0YXJ0X3BoeXNfYWRkcl9sbzsJLyow
OGggKi8KCXUzMiByZXBseV9xdWV1ZV9zdGFydF9waHlzX2FkZHJfaGk7CS8qMENoICovCgl1MzIg
cHJvZHVjZXJfaW5kZXhfcGh5c19hZGRyX2xvOwkvKjEwaCAqLwoJdTMyIHByb2R1Y2VyX2luZGV4
X3BoeXNfYWRkcl9oaTsJLyoxNGggKi8KCXUzMiBjb25zdW1lcl9pbmRleF9waHlzX2FkZHJfbG87
CS8qMThoICovCgl1MzIgY29uc3VtZXJfaW5kZXhfcGh5c19hZGRyX2hpOwkvKjFDaCAqLwoKfSBf
X2F0dHJpYnV0ZV9fICgocGFja2VkKSk7CgpzdHJ1Y3QgbWVnYXNhc19pb19mcmFtZSB7CgoJdTgg
Y21kOwkJCS8qMDBoICovCgl1OCBzZW5zZV9sZW47CQkvKjAxaCAqLwoJdTggY21kX3N0YXR1czsJ
CS8qMDJoICovCgl1OCBzY3NpX3N0YXR1czsJCS8qMDNoICovCgoJdTggdGFyZ2V0X2lkOwkJLyow
NGggKi8KCXU4IGFjY2Vzc19ieXRlOwkJLyowNWggKi8KCXU4IHJlc2VydmVkXzA7CQkvKjA2aCAq
LwoJdTggc2dlX2NvdW50OwkJLyowN2ggKi8KCgl1MzIgY29udGV4dDsJCS8qMDhoICovCgl1MzIg
cGFkXzA7CQkvKjBDaCAqLwoKCXUxNiBmbGFnczsJCS8qMTBoICovCgl1MTYgdGltZW91dDsJCS8q
MTJoICovCgl1MzIgbGJhX2NvdW50OwkJLyoxNGggKi8KCgl1MzIgc2Vuc2VfYnVmX3BoeXNfYWRk
cl9sbzsJLyoxOGggKi8KCXUzMiBzZW5zZV9idWZfcGh5c19hZGRyX2hpOwkvKjFDaCAqLwoKCXUz
MiBzdGFydF9sYmFfbG87CS8qMjBoICovCgl1MzIgc3RhcnRfbGJhX2hpOwkvKjI0aCAqLwoKCXVu
aW9uIG1lZ2FzYXNfc2dsIHNnbDsJLyoyOGggKi8KCn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkp
OwoKc3RydWN0IG1lZ2FzYXNfcHRocnVfZnJhbWUgewoKCXU4IGNtZDsJCQkvKjAwaCAqLwoJdTgg
c2Vuc2VfbGVuOwkJLyowMWggKi8KCXU4IGNtZF9zdGF0dXM7CQkvKjAyaCAqLwoJdTggc2NzaV9z
dGF0dXM7CQkvKjAzaCAqLwoKCXU4IHRhcmdldF9pZDsJCS8qMDRoICovCgl1OCBsdW47CQkJLyow
NWggKi8KCXU4IGNkYl9sZW47CQkvKjA2aCAqLwoJdTggc2dlX2NvdW50OwkJLyowN2ggKi8KCgl1
MzIgY29udGV4dDsJCS8qMDhoICovCgl1MzIgcGFkXzA7CQkvKjBDaCAqLwoKCXUxNiBmbGFnczsJ
CS8qMTBoICovCgl1MTYgdGltZW91dDsJCS8qMTJoICovCgl1MzIgZGF0YV94ZmVyX2xlbjsJLyox
NGggKi8KCgl1MzIgc2Vuc2VfYnVmX3BoeXNfYWRkcl9sbzsJLyoxOGggKi8KCXUzMiBzZW5zZV9i
dWZfcGh5c19hZGRyX2hpOwkvKjFDaCAqLwoKCXU4IGNkYlsxNl07CQkvKjIwaCAqLwoJdW5pb24g
bWVnYXNhc19zZ2wgc2dsOwkvKjMwaCAqLwoKfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7Cgpz
dHJ1Y3QgbWVnYXNhc19kY21kX2ZyYW1lIHsKCgl1OCBjbWQ7CQkJLyowMGggKi8KCXU4IHJlc2Vy
dmVkXzA7CQkvKjAxaCAqLwoJdTggY21kX3N0YXR1czsJCS8qMDJoICovCgl1OCByZXNlcnZlZF8x
WzRdOwkvKjAzaCAqLwoJdTggc2dlX2NvdW50OwkJLyowN2ggKi8KCgl1MzIgY29udGV4dDsJCS8q
MDhoICovCgl1MzIgcGFkXzA7CQkvKjBDaCAqLwoKCXUxNiBmbGFnczsJCS8qMTBoICovCgl1MTYg
dGltZW91dDsJCS8qMTJoICovCgoJdTMyIGRhdGFfeGZlcl9sZW47CS8qMTRoICovCgl1MzIgb3Bj
b2RlOwkJLyoxOGggKi8KCgl1bmlvbiB7CQkJLyoxQ2ggKi8KCQl1OCBiWzEyXTsKCQl1MTYgc1s2
XTsKCQl1MzIgd1szXTsKCX0gbWJveDsKCgl1bmlvbiBtZWdhc2FzX3NnbCBzZ2w7CS8qMjhoICov
Cgp9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKTsKCnN0cnVjdCBtZWdhc2FzX2Fib3J0X2ZyYW1l
IHsKCgl1OCBjbWQ7CQkJLyowMGggKi8KCXU4IHJlc2VydmVkXzA7CQkvKjAxaCAqLwoJdTggY21k
X3N0YXR1czsJCS8qMDJoICovCgoJdTggcmVzZXJ2ZWRfMTsJCS8qMDNoICovCgl1MzIgcmVzZXJ2
ZWRfMjsJCS8qMDRoICovCgoJdTMyIGNvbnRleHQ7CQkvKjA4aCAqLwoJdTMyIHBhZF8wOwkJLyow
Q2ggKi8KCgl1MTYgZmxhZ3M7CQkvKjEwaCAqLwoJdTE2IHJlc2VydmVkXzM7CQkvKjEyaCAqLwoJ
dTMyIHJlc2VydmVkXzQ7CQkvKjE0aCAqLwoKCXUzMiBhYm9ydF9jb250ZXh0OwkvKjE4aCAqLwoJ
dTMyIHBhZF8xOwkJLyoxQ2ggKi8KCgl1MzIgYWJvcnRfbWZpX3BoeXNfYWRkcl9sbzsJLyoyMGgg
Ki8KCXUzMiBhYm9ydF9tZmlfcGh5c19hZGRyX2hpOwkvKjI0aCAqLwoKCXUzMiByZXNlcnZlZF81
WzZdOwkvKjI4aCAqLwoKfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7CgpzdHJ1Y3QgbWVnYXNh
c19zbXBfZnJhbWUgewoKCXU4IGNtZDsJCQkvKjAwaCAqLwoJdTggcmVzZXJ2ZWRfMTsJCS8qMDFo
ICovCgl1OCBjbWRfc3RhdHVzOwkJLyowMmggKi8KCXU4IGNvbm5lY3Rpb25fc3RhdHVzOwkvKjAz
aCAqLwoKCXU4IHJlc2VydmVkXzJbM107CS8qMDRoICovCgl1OCBzZ2VfY291bnQ7CQkvKjA3aCAq
LwoKCXUzMiBjb250ZXh0OwkJLyowOGggKi8KCXUzMiBwYWRfMDsJCS8qMENoICovCgoJdTE2IGZs
YWdzOwkJLyoxMGggKi8KCXUxNiB0aW1lb3V0OwkJLyoxMmggKi8KCgl1MzIgZGF0YV94ZmVyX2xl
bjsJLyoxNGggKi8KCXU2NCBzYXNfYWRkcjsJCS8qMThoICovCgoJdW5pb24gewoJCXN0cnVjdCBt
ZWdhc2FzX3NnZTMyIHNnZTMyWzJdOwkvKiBbMF06IHJlc3AgWzFdOiByZXEgKi8KCQlzdHJ1Y3Qg
bWVnYXNhc19zZ2U2NCBzZ2U2NFsyXTsJLyogWzBdOiByZXNwIFsxXTogcmVxICovCgl9IHNnbDsK
Cn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoKc3RydWN0IG1lZ2FzYXNfc3RwX2ZyYW1lIHsK
Cgl1OCBjbWQ7CQkJLyowMGggKi8KCXU4IHJlc2VydmVkXzE7CQkvKjAxaCAqLwoJdTggY21kX3N0
YXR1czsJCS8qMDJoICovCgl1OCByZXNlcnZlZF8yOwkJLyowM2ggKi8KCgl1OCB0YXJnZXRfaWQ7
CQkvKjA0aCAqLwoJdTggcmVzZXJ2ZWRfM1syXTsJLyowNWggKi8KCXU4IHNnZV9jb3VudDsJCS8q
MDdoICovCgoJdTMyIGNvbnRleHQ7CQkvKjA4aCAqLwoJdTMyIHBhZF8wOwkJLyowQ2ggKi8KCgl1
MTYgZmxhZ3M7CQkvKjEwaCAqLwoJdTE2IHRpbWVvdXQ7CQkvKjEyaCAqLwoKCXUzMiBkYXRhX3hm
ZXJfbGVuOwkvKjE0aCAqLwoKCXUxNiBmaXNbMTBdOwkJLyoxOGggKi8KCXUzMiBzdHBfZmxhZ3M7
CgoJdW5pb24gewoJCXN0cnVjdCBtZWdhc2FzX3NnZTMyIHNnZTMyWzJdOwkvKiBbMF06IHJlc3Ag
WzFdOiBkYXRhICovCgkJc3RydWN0IG1lZ2FzYXNfc2dlNjQgc2dlNjRbMl07CS8qIFswXTogcmVz
cCBbMV06IGRhdGEgKi8KCX0gc2dsOwoKfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7Cgp1bmlv
biBtZWdhc2FzX2ZyYW1lIHsKCglzdHJ1Y3QgbWVnYXNhc19oZWFkZXIgaGRyOwoJc3RydWN0IG1l
Z2FzYXNfaW5pdF9mcmFtZSBpbml0OwoJc3RydWN0IG1lZ2FzYXNfaW9fZnJhbWUgaW87CglzdHJ1
Y3QgbWVnYXNhc19wdGhydV9mcmFtZSBwdGhydTsKCXN0cnVjdCBtZWdhc2FzX2RjbWRfZnJhbWUg
ZGNtZDsKCXN0cnVjdCBtZWdhc2FzX2Fib3J0X2ZyYW1lIGFib3J0OwoJc3RydWN0IG1lZ2FzYXNf
c21wX2ZyYW1lIHNtcDsKCXN0cnVjdCBtZWdhc2FzX3N0cF9mcmFtZSBzdHA7CgoJdTggcmF3X2J5
dGVzWzY0XTsKfTsKCnN0cnVjdCBtZWdhc2FzX2NtZDsKCnVuaW9uIG1lZ2FzYXNfZXZ0X2NsYXNz
X2xvY2FsZSB7CgoJc3RydWN0IHsKCQl1MTYgbG9jYWxlOwoJCXU4IHJlc2VydmVkOwoJCXM4IGNs
YXNzOwoJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgbWVtYmVyczsKCgl1MzIgd29yZDsKCn0g
X19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoKc3RydWN0IG1lZ2FzYXNfZXZ0X2xvZ19pbmZvIHsK
CXUzMiBuZXdlc3Rfc2VxX251bTsKCXUzMiBvbGRlc3Rfc2VxX251bTsKCXUzMiBjbGVhcl9zZXFf
bnVtOwoJdTMyIHNodXRkb3duX3NlcV9udW07Cgl1MzIgYm9vdF9zZXFfbnVtOwoKfSBfX2F0dHJp
YnV0ZV9fICgocGFja2VkKSk7CgpzdHJ1Y3QgbWVnYXNhc19wcm9ncmVzcyB7CgoJdTE2IHByb2dy
ZXNzOwoJdTE2IGVsYXBzZWRfc2Vjb25kczsKCn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoK
c3RydWN0IG1lZ2FzYXNfZXZ0YXJnX2xkIHsKCgl1MTYgdGFyZ2V0X2lkOwoJdTggbGRfaW5kZXg7
Cgl1OCByZXNlcnZlZDsKCn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoKc3RydWN0IG1lZ2Fz
YXNfZXZ0YXJnX3BkIHsKCXUxNiBkZXZpY2VfaWQ7Cgl1OCBlbmNsX2luZGV4OwoJdTggc2xvdF9u
dW1iZXI7Cgp9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKTsKCnN0cnVjdCBtZWdhc2FzX2V2dF9k
ZXRhaWwgewoKCXUzMiBzZXFfbnVtOwoJdTMyIHRpbWVfc3RhbXA7Cgl1MzIgY29kZTsKCXVuaW9u
IG1lZ2FzYXNfZXZ0X2NsYXNzX2xvY2FsZSBjbDsKCXU4IGFyZ190eXBlOwoJdTggcmVzZXJ2ZWQx
WzE1XTsKCgl1bmlvbiB7CgkJc3RydWN0IHsKCQkJc3RydWN0IG1lZ2FzYXNfZXZ0YXJnX3BkIHBk
OwoJCQl1OCBjZGJfbGVuZ3RoOwoJCQl1OCBzZW5zZV9sZW5ndGg7CgkJCXU4IHJlc2VydmVkWzJd
OwoJCQl1OCBjZGJbMTZdOwoJCQl1OCBzZW5zZVs2NF07CgkJfSBfX2F0dHJpYnV0ZV9fICgocGFj
a2VkKSkgY2RiU2Vuc2U7CgoJCXN0cnVjdCBtZWdhc2FzX2V2dGFyZ19sZCBsZDsKCgkJc3RydWN0
IHsKCQkJc3RydWN0IG1lZ2FzYXNfZXZ0YXJnX2xkIGxkOwoJCQl1NjQgY291bnQ7CgkJfSBfX2F0
dHJpYnV0ZV9fICgocGFja2VkKSkgbGRfY291bnQ7CgoJCXN0cnVjdCB7CgkJCXU2NCBsYmE7CgkJ
CXN0cnVjdCBtZWdhc2FzX2V2dGFyZ19sZCBsZDsKCQl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQp
KSBsZF9sYmE7CgoJCXN0cnVjdCB7CgkJCXN0cnVjdCBtZWdhc2FzX2V2dGFyZ19sZCBsZDsKCQkJ
dTMyIHByZXZPd25lcjsKCQkJdTMyIG5ld093bmVyOwoJCX0gX19hdHRyaWJ1dGVfXyAoKHBhY2tl
ZCkpIGxkX293bmVyOwoKCQlzdHJ1Y3QgewoJCQl1NjQgbGRfbGJhOwoJCQl1NjQgcGRfbGJhOwoJ
CQlzdHJ1Y3QgbWVnYXNhc19ldnRhcmdfbGQgbGQ7CgkJCXN0cnVjdCBtZWdhc2FzX2V2dGFyZ19w
ZCBwZDsKCQl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSBsZF9sYmFfcGRfbGJhOwoKCQlzdHJ1
Y3QgewoJCQlzdHJ1Y3QgbWVnYXNhc19ldnRhcmdfbGQgbGQ7CgkJCXN0cnVjdCBtZWdhc2FzX3By
b2dyZXNzIHByb2c7CgkJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgbGRfcHJvZzsKCgkJc3Ry
dWN0IHsKCQkJc3RydWN0IG1lZ2FzYXNfZXZ0YXJnX2xkIGxkOwoJCQl1MzIgcHJldl9zdGF0ZTsK
CQkJdTMyIG5ld19zdGF0ZTsKCQl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSBsZF9zdGF0ZTsK
CgkJc3RydWN0IHsKCQkJdTY0IHN0cmlwOwoJCQlzdHJ1Y3QgbWVnYXNhc19ldnRhcmdfbGQgbGQ7
CgkJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgbGRfc3RyaXA7CgoJCXN0cnVjdCBtZWdhc2Fz
X2V2dGFyZ19wZCBwZDsKCgkJc3RydWN0IHsKCQkJc3RydWN0IG1lZ2FzYXNfZXZ0YXJnX3BkIHBk
OwoJCQl1MzIgZXJyOwoJCX0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpIHBkX2VycjsKCgkJc3Ry
dWN0IHsKCQkJdTY0IGxiYTsKCQkJc3RydWN0IG1lZ2FzYXNfZXZ0YXJnX3BkIHBkOwoJCX0gX19h
dHRyaWJ1dGVfXyAoKHBhY2tlZCkpIHBkX2xiYTsKCgkJc3RydWN0IHsKCQkJdTY0IGxiYTsKCQkJ
c3RydWN0IG1lZ2FzYXNfZXZ0YXJnX3BkIHBkOwoJCQlzdHJ1Y3QgbWVnYXNhc19ldnRhcmdfbGQg
bGQ7CgkJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgcGRfbGJhX2xkOwoKCQlzdHJ1Y3QgewoJ
CQlzdHJ1Y3QgbWVnYXNhc19ldnRhcmdfcGQgcGQ7CgkJCXN0cnVjdCBtZWdhc2FzX3Byb2dyZXNz
IHByb2c7CgkJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgcGRfcHJvZzsKCgkJc3RydWN0IHsK
CQkJc3RydWN0IG1lZ2FzYXNfZXZ0YXJnX3BkIHBkOwoJCQl1MzIgcHJldlN0YXRlOwoJCQl1MzIg
bmV3U3RhdGU7CgkJfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSkgcGRfc3RhdGU7CgoJCXN0cnVj
dCB7CgkJCXUxNiB2ZW5kb3JJZDsKCQkJdTE2IGRldmljZUlkOwoJCQl1MTYgc3ViVmVuZG9ySWQ7
CgkJCXUxNiBzdWJEZXZpY2VJZDsKCQl9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKSBwY2k7CgoJ
CXUzMiByYXRlOwoJCWNoYXIgc3RyWzk2XTsKCgkJc3RydWN0IHsKCQkJdTMyIHJ0YzsKCQkJdTMy
IGVsYXBzZWRTZWNvbmRzOwoJCX0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpIHRpbWU7CgoJCXN0
cnVjdCB7CgkJCXUzMiBlY2FyOwoJCQl1MzIgZWxvZzsKCQkJY2hhciBzdHJbNjRdOwoJCX0gX19h
dHRyaWJ1dGVfXyAoKHBhY2tlZCkpIGVjYzsKCgkJdTggYls5Nl07CgkJdTE2IHNbNDhdOwoJCXUz
MiB3WzI0XTsKCQl1NjQgZFsxMl07Cgl9IGFyZ3M7CgoJY2hhciBkZXNjcmlwdGlvblsxMjhdOwoK
fSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7CgpzdHJ1Y3QgbWVnYXNhc19hZW5fZXZlbnQgewoJ
c3RydWN0IHdvcmtfc3RydWN0IGhvdHBsdWdfd29yazsKCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZTsKfTsKCnN0cnVjdCBtZWdhc2FzX2luc3RhbmNlIHsKCgl1MzIgKnByb2R1Y2Vy
OwoJZG1hX2FkZHJfdCBwcm9kdWNlcl9oOwoJdTMyICpjb25zdW1lcjsKCWRtYV9hZGRyX3QgY29u
c3VtZXJfaDsKCgl1MzIgKnJlcGx5X3F1ZXVlOwoJZG1hX2FkZHJfdCByZXBseV9xdWV1ZV9oOwoK
CXVuc2lnbmVkIGxvbmcgYmFzZV9hZGRyOwoJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9f
aW9tZW0gKnJlZ19zZXQ7CgoJc3RydWN0IG1lZ2FzYXNfcGRfbGlzdCAgICAgICAgICBwZF9saXN0
W01FR0FTQVNfTUFYX1BEXTsKCXU4ICAgICBsZF9pZHNbTUVHQVNBU19NQVhfTERfSURTXTsKCXM4
IGluaXRfaWQ7CgoJdTE2IG1heF9udW1fc2dlOwoJdTE2IG1heF9md19jbWRzOwoJdTMyIG1heF9z
ZWN0b3JzX3Blcl9yZXE7CglzdHJ1Y3QgbWVnYXNhc19hZW5fZXZlbnQgKmV2OwoKCXN0cnVjdCBt
ZWdhc2FzX2NtZCAqKmNtZF9saXN0OwoJc3RydWN0IGxpc3RfaGVhZCBjbWRfcG9vbDsKCS8qIHVz
ZWQgdG8gc3luYyBmaXJlIHRoZSBjbWQgdG8gZncgKi8KCXNwaW5sb2NrX3QgY21kX3Bvb2xfbG9j
azsKCS8qIHVzZWQgdG8gc3luYyBmaXJlIHRoZSBjbWQgdG8gZncgKi8KCXNwaW5sb2NrX3QgaGJh
X2xvY2s7CgkvKiB1c2VkIHRvIHN5bmNoIHByb2R1Y2VyLCBjb25zdW1lciBwdHJzIGluIGRwYyAq
LwoJc3BpbmxvY2tfdCBjb21wbGV0aW9uX2xvY2s7CglzdHJ1Y3QgZG1hX3Bvb2wgKmZyYW1lX2Rt
YV9wb29sOwoJc3RydWN0IGRtYV9wb29sICpzZW5zZV9kbWFfcG9vbDsKCglzdHJ1Y3QgbWVnYXNh
c19ldnRfZGV0YWlsICpldnRfZGV0YWlsOwoJZG1hX2FkZHJfdCBldnRfZGV0YWlsX2g7CglzdHJ1
Y3QgbWVnYXNhc19jbWQgKmFlbl9jbWQ7CglzdHJ1Y3QgbXV0ZXggYWVuX211dGV4OwoJc3RydWN0
IHNlbWFwaG9yZSBpb2N0bF9zZW07CgoJc3RydWN0IFNjc2lfSG9zdCAqaG9zdDsKCgl3YWl0X3F1
ZXVlX2hlYWRfdCBpbnRfY21kX3dhaXRfcTsKCXdhaXRfcXVldWVfaGVhZF90IGFib3J0X2NtZF93
YWl0X3E7CgoJc3RydWN0IHBjaV9kZXYgKnBkZXY7Cgl1MzIgdW5pcXVlX2lkOwoJdTMyIGZ3X3N1
cHBvcnRfaWVlZTsKCglhdG9taWNfdCBmd19vdXRzdGFuZGluZzsKCWF0b21pY190IGZ3X3Jlc2V0
X25vX3BjaV9hY2Nlc3M7CgoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGUgKmluc3Rh
bmNldDsKCXN0cnVjdCB0YXNrbGV0X3N0cnVjdCBpc3JfdGFza2xldDsKCXN0cnVjdCB3b3JrX3N0
cnVjdCB3b3JrX2luaXQ7CgoJdTggZmxhZzsKCXU4IHVubG9hZDsKCXU4IGZsYWdfaWVlZTsKCXU4
IGlzc3VlcGVuZF9kb25lOwoJdTggZGlzYWJsZU9ubGluZUN0cmxSZXNldDsKCXU4IGFkcHJlY292
ZXJ5OwoJdW5zaWduZWQgbG9uZyBsYXN0X3RpbWU7Cgl1MzIgbWZpU3RhdHVzOwoJdTMyIGxhc3Rf
c2VxX251bTsKCglzdHJ1Y3QgdGltZXJfbGlzdCBpb19jb21wbGV0aW9uX3RpbWVyOwoJc3RydWN0
IGxpc3RfaGVhZCBpbnRlcm5hbF9yZXNldF9wZW5kaW5nX3E7Cn07CgplbnVtIHsKCU1FR0FTQVNf
SEJBX09QRVJBVElPTkFMCQkJPSAwLAoJTUVHQVNBU19BRFBSRVNFVF9TTV9JTkZBVUxUCQk9IDEs
CglNRUdBU0FTX0FEUFJFU0VUX1NNX0ZXX1JFU0VUX1NVQ0NFU1MJPSAyLAoJTUVHQVNBU19BRFBS
RVNFVF9TTV9PUEVSQVRJT05BTAkJPSAzLAoJTUVHQVNBU19IV19DUklUSUNBTF9FUlJPUgkJPSA0
LAoJTUVHQVNBU19BRFBSRVNFVF9JTlBST0dfU0lHTgkJPSAweERFQURERUFELAp9OwoKc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGUgewoJdm9pZCAoKmZpcmVfY21kKShzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqLCBkbWFfYWRkcl90LCBcCgkJdTMyLCBzdHJ1Y3QgbWVnYXNhc19yZWdp
c3Rlcl9zZXQgX19pb21lbSAqKTsKCgl2b2lkICgqZW5hYmxlX2ludHIpKHN0cnVjdCBtZWdhc2Fz
X3JlZ2lzdGVyX3NldCBfX2lvbWVtICopIDsKCXZvaWQgKCpkaXNhYmxlX2ludHIpKHN0cnVjdCBt
ZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICopOwoKCWludCAoKmNsZWFyX2ludHIpKHN0cnVj
dCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICopOwoKCXUzMiAoKnJlYWRfZndfc3RhdHVz
X3JlZykoc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKik7CglpbnQgKCphZHBf
cmVzZXQpKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICosIFwKCQlzdHJ1Y3QgbWVnYXNhc19yZWdp
c3Rlcl9zZXQgX19pb21lbSAqKTsKCWludCAoKmNoZWNrX3Jlc2V0KShzdHJ1Y3QgbWVnYXNhc19p
bnN0YW5jZSAqLCBcCgkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKik7Cn07
CgojZGVmaW5lIE1FR0FTQVNfSVNfTE9HSUNBTChzY3ApCQkJCQkJXAoJKHNjcC0+ZGV2aWNlLT5j
aGFubmVsIDwgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMpID8gMCA6IDEKCiNkZWZpbmUgTUVHQVNB
U19ERVZfSU5ERVgoaW5zdCwgc2NwKQkJCQkJXAoJKChzY3AtPmRldmljZS0+Y2hhbm5lbCAlIDIp
ICogTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKSArIAlcCglzY3AtPmRldmljZS0+aWQKCnN0
cnVjdCBtZWdhc2FzX2NtZCB7CgoJdW5pb24gbWVnYXNhc19mcmFtZSAqZnJhbWU7CglkbWFfYWRk
cl90IGZyYW1lX3BoeXNfYWRkcjsKCXU4ICpzZW5zZTsKCWRtYV9hZGRyX3Qgc2Vuc2VfcGh5c19h
ZGRyOwoKCXUzMiBpbmRleDsKCXU4IHN5bmNfY21kOwoJdTggY21kX3N0YXR1czsKCXU4IGFib3J0
X2FlbjsKCXU4IHJldHJ5X2Zvcl9md19yZXNldDsKCgoJc3RydWN0IGxpc3RfaGVhZCBsaXN0OwoJ
c3RydWN0IHNjc2lfY21uZCAqc2NtZDsKCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZTsKCXUzMiBmcmFtZV9jb3VudDsKfTsKCiNkZWZpbmUgTUFYX01HTVRfQURBUFRFUlMJCTEwMjQK
I2RlZmluZSBNQVhfSU9DVExfU0dFCQkJMTYKCnN0cnVjdCBtZWdhc2FzX2lvY3BhY2tldCB7CgoJ
dTE2IGhvc3Rfbm87Cgl1MTYgX19wYWQxOwoJdTMyIHNnbF9vZmY7Cgl1MzIgc2dlX2NvdW50OwoJ
dTMyIHNlbnNlX29mZjsKCXUzMiBzZW5zZV9sZW47Cgl1bmlvbiB7CgkJdTggcmF3WzEyOF07CgkJ
c3RydWN0IG1lZ2FzYXNfaGVhZGVyIGhkcjsKCX0gZnJhbWU7CgoJc3RydWN0IGlvdmVjIHNnbFtN
QVhfSU9DVExfU0dFXTsKCn0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwoKc3RydWN0IG1lZ2Fz
YXNfYWVuIHsKCXUxNiBob3N0X25vOwoJdTE2IF9fcGFkMTsKCXUzMiBzZXFfbnVtOwoJdTMyIGNs
YXNzX2xvY2FsZV93b3JkOwp9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKTsKCiNpZmRlZiBDT05G
SUdfQ09NUEFUCnN0cnVjdCBjb21wYXRfbWVnYXNhc19pb2NwYWNrZXQgewoJdTE2IGhvc3Rfbm87
Cgl1MTYgX19wYWQxOwoJdTMyIHNnbF9vZmY7Cgl1MzIgc2dlX2NvdW50OwoJdTMyIHNlbnNlX29m
ZjsKCXUzMiBzZW5zZV9sZW47Cgl1bmlvbiB7CgkJdTggcmF3WzEyOF07CgkJc3RydWN0IG1lZ2Fz
YXNfaGVhZGVyIGhkcjsKCX0gZnJhbWU7CglzdHJ1Y3QgY29tcGF0X2lvdmVjIHNnbFtNQVhfSU9D
VExfU0dFXTsKfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7CgojZGVmaW5lIE1FR0FTQVNfSU9D
X0ZJUk1XQVJFMzIJX0lPV1IoJ00nLCAxLCBzdHJ1Y3QgY29tcGF0X21lZ2FzYXNfaW9jcGFja2V0
KQojZW5kaWYKCiNkZWZpbmUgTUVHQVNBU19JT0NfRklSTVdBUkUJX0lPV1IoJ00nLCAxLCBzdHJ1
Y3QgbWVnYXNhc19pb2NwYWNrZXQpCiNkZWZpbmUgTUVHQVNBU19JT0NfR0VUX0FFTglfSU9XKCdN
JywgMywgc3RydWN0IG1lZ2FzYXNfYWVuKQoKc3RydWN0IG1lZ2FzYXNfbWdtdF9pbmZvIHsKCgl1
MTYgY291bnQ7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2VbTUFYX01HTVRfQURB
UFRFUlNdOwoJaW50IG1heF9pbmRleDsKfTsKCiNlbmRpZgkJCQkvKkxTSV9NRUdBUkFJRF9TQVNf
SCAqLwo=

--_003_4B6A08C587958942AA3002690DD4F8C3DBEF4AD0cosmail02lsicom_
Content-Type: text/plain; name="megaraid_sas.c"
Content-Description: megaraid_sas.c
Content-Disposition: attachment; filename="megaraid_sas.c"; size=133439;
	creation-date="Wed, 11 Aug 2010 11:30:44 GMT";
	modification-date="Tue, 10 Aug 2010 02:52:23 GMT"
Content-Transfer-Encoding: base64

LyoKICoKICoJCUxpbnV4IE1lZ2FSQUlEIGRyaXZlciBmb3IgU0FTIGJhc2VkIFJBSUQgY29udHJv
bGxlcnMKICoKICogQ29weXJpZ2h0IChjKSAyMDAzLTIwMDUgIExTSSBDb3Jwb3JhdGlvbi4KICoK
ICoJICAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRl
IGl0IGFuZC9vcgogKgkgICBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZQogKgkgICBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdh
cmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24KICoJICAgMiBvZiB0aGUgTGljZW5zZSwgb3Ig
KGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KICoKICogRklMRQkJOiBtZWdhcmFp
ZF9zYXMuYwogKiBWZXJzaW9uICAgICA6IHYwMC4wMC4wNC4xNy4xLXJjMQogKgogKiBBdXRob3Jz
OgogKgkoZW1haWwtaWQgOiBtZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAqIAlTcmVlbml2YXMgQmFn
YWxrb3RlCiAqIAlTdW1hbnQgUGF0cm8KICoJQm8gWWFuZwogKgogKiBMaXN0IG9mIHN1cHBvcnRl
ZCBjb250cm9sbGVycwogKgogKiBPRU0JUHJvZHVjdCBOYW1lCQkJVklECURJRAlTU1ZJRAlTU0lE
CiAqIC0tLQktLS0tLS0tLS0tLS0JCQktLS0JLS0tCS0tLS0JLS0tLQogKi8KCiNpbmNsdWRlIDxs
aW51eC9rZXJuZWwuaD4KI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CiNpbmNsdWRlIDxsaW51eC9w
Y2kuaD4KI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4KI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFt
Lmg+CiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+
CiNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+CiNp
bmNsdWRlIDxsaW51eC9zbXBfbG9jay5oPgojaW5jbHVkZSA8bGludXgvdWlvLmg+CiNpbmNsdWRl
IDxsaW51eC9zbGFiLmg+CiNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgojaW5jbHVkZSA8bGludXgv
ZnMuaD4KI2luY2x1ZGUgPGxpbnV4L2NvbXBhdC5oPgojaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+
CiNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgojaW5jbHVkZSA8bGludXgvcG9sbC5oPgoKI2luY2x1
ZGUgPHNjc2kvc2NzaS5oPgojaW5jbHVkZSA8c2NzaS9zY3NpX2NtbmQuaD4KI2luY2x1ZGUgPHNj
c2kvc2NzaV9kZXZpY2UuaD4KI2luY2x1ZGUgPHNjc2kvc2NzaV9ob3N0Lmg+CiNpbmNsdWRlICJt
ZWdhcmFpZF9zYXMuaCIKCi8qCiAqIHBvbGxfbW9kZV9pbzoxLSBzY2hlZHVsZSBjb21wbGV0ZSBj
b21wbGV0aW9uIGZyb20gcSBjbWQKICovCnN0YXRpYyB1bnNpZ25lZCBpbnQgcG9sbF9tb2RlX2lv
Owptb2R1bGVfcGFyYW1fbmFtZWQocG9sbF9tb2RlX2lvLCBwb2xsX21vZGVfaW8sIGludCwgMCk7
Ck1PRFVMRV9QQVJNX0RFU0MocG9sbF9tb2RlX2lvLAoJIkNvbXBsZXRlIGNtZHMgZnJvbSBJTyBw
YXRoLCAoZGVmYXVsdD0wKSIpOwoKLyoKICogTnVtYmVyIG9mIHNlY3RvcnMgcGVyIElPIGNvbW1h
bmQKICogV2lsbCBiZSBzZXQgaW4gbWVnYXNhc19pbml0X21maSBpZiB1c2VyIGRvZXMgbm90IHBy
b3ZpZGUKICovCnN0YXRpYyB1bnNpZ25lZCBpbnQgbWF4X3NlY3RvcnM7Cm1vZHVsZV9wYXJhbV9u
YW1lZChtYXhfc2VjdG9ycywgbWF4X3NlY3RvcnMsIGludCwgMCk7Ck1PRFVMRV9QQVJNX0RFU0Mo
bWF4X3NlY3RvcnMsCgkiTWF4aW11bSBudW1iZXIgb2Ygc2VjdG9ycyBwZXIgSU8gY29tbWFuZCIp
OwoKTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwpNT0RVTEVfVkVSU0lPTihNRUdBU0FTX1ZFUlNJT04p
OwpNT0RVTEVfQVVUSE9SKCJtZWdhcmFpZGxpbnV4QGxzaS5jb20iKTsKTU9EVUxFX0RFU0NSSVBU
SU9OKCJMU0kgTWVnYVJBSUQgU0FTIERyaXZlciIpOwoKLyoKICogUENJIElEIHRhYmxlIGZvciBh
bGwgc3VwcG9ydGVkIGNvbnRyb2xsZXJzCiAqLwpzdGF0aWMgc3RydWN0IHBjaV9kZXZpY2VfaWQg
bWVnYXNhc19wY2lfdGFibGVbXSA9IHsKCgl7UENJX0RFVklDRShQQ0lfVkVORE9SX0lEX0xTSV9M
T0dJQywgUENJX0RFVklDRV9JRF9MU0lfU0FTMTA2NFIpfSwKCS8qIHhzY2FsZSBJT1AgKi8KCXtQ
Q0lfREVWSUNFKFBDSV9WRU5ET1JfSURfTFNJX0xPR0lDLCBQQ0lfREVWSUNFX0lEX0xTSV9TQVMx
MDc4Uil9LAoJLyogcHBjIElPUCAqLwoJe1BDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9MU0lfTE9H
SUMsIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhERSl9LAoJLyogcHBjIElPUCAqLwoJe1BDSV9E
RVZJQ0UoUENJX1ZFTkRPUl9JRF9MU0lfTE9HSUMsIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhH
RU4yKX0sCgkvKiBnZW4yKi8KCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfTFNJX0xPR0lDLCBQ
Q0lfREVWSUNFX0lEX0xTSV9TQVMwMDc5R0VOMil9LAoJLyogZ2VuMiovCgl7UENJX0RFVklDRShQ
Q0lfVkVORE9SX0lEX0xTSV9MT0dJQywgUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSl9
LAoJLyogc2tpbm55Ki8KCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfTFNJX0xPR0lDLCBQQ0lf
REVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKX0sCgkvKiBza2lubnkqLwoJe1BDSV9ERVZJQ0Uo
UENJX1ZFTkRPUl9JRF9MU0lfTE9HSUMsIFBDSV9ERVZJQ0VfSURfTFNJX1ZFUkRFX1pDUil9LAoJ
LyogeHNjYWxlIElPUCwgdmVnYSAqLwoJe1BDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9ERUxMLCBQ
Q0lfREVWSUNFX0lEX0RFTExfUEVSQzUpfSwKCS8qIHhzY2FsZSBJT1AgKi8KCXt9Cn07CgpNT0RV
TEVfREVWSUNFX1RBQkxFKHBjaSwgbWVnYXNhc19wY2lfdGFibGUpOwoKc3RhdGljIGludCBtZWdh
c2FzX21nbXRfbWFqb3JubzsKc3RhdGljIHN0cnVjdCBtZWdhc2FzX21nbXRfaW5mbyBtZWdhc2Fz
X21nbXRfaW5mbzsKc3RhdGljIHN0cnVjdCBmYXN5bmNfc3RydWN0ICptZWdhc2FzX2FzeW5jX3F1
ZXVlOwpzdGF0aWMgREVGSU5FX01VVEVYKG1lZ2FzYXNfYXN5bmNfcXVldWVfbXV0ZXgpOwoKc3Rh
dGljIGludCBtZWdhc2FzX3BvbGxfd2FpdF9hZW47CnN0YXRpYyBERUNMQVJFX1dBSVRfUVVFVUVf
SEVBRChtZWdhc2FzX3BvbGxfd2FpdCk7CnN0YXRpYyB1MzIgc3VwcG9ydF9wb2xsX2Zvcl9ldmVu
dDsKc3RhdGljIHUzMiBtZWdhc2FzX2RiZ19sdmw7CnN0YXRpYyB1MzIgc3VwcG9ydF9kZXZpY2Vf
Y2hhbmdlOwoKLyogZGVmaW5lIGxvY2sgZm9yIGFlbiBwb2xsICovCnNwaW5sb2NrX3QgcG9sbF9h
ZW5fbG9jazsKCnN0YXRpYyB2b2lkCm1lZ2FzYXNfY29tcGxldGVfY21kKHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQsCgkJICAgICB1OCBh
bHRfc3RhdHVzKTsKCnN0YXRpYyBpbnQgbWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CnN0YXRpYyBpbnQgbWVnYXNhc19nZXRfcGRf
bGlzdChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwpzdGF0aWMgaW50IG1lZ2Fz
YXNfaXNzdWVfaW5pdF9tZmkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKc3Rh
dGljIGludCBtZWdhc2FzX3JlZ2lzdGVyX2FlbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UsCgkJCQl1MzIgc2VxX251bSwgdTMyIGNsYXNzX2xvY2FsZV93b3JkKTsKCi8qKgogKiBt
ZWdhc2FzX2dldF9jbWQgLQlHZXQgYSBjb21tYW5kIGZyb20gdGhlIGZyZWUgcG9vbAogKiBAaW5z
dGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKICoKICogUmV0dXJucyBhIGZyZWUgY29tbWFuZCBm
cm9tIHRoZSBwb29sCiAqLwpzdGF0aWMgc3RydWN0IG1lZ2FzYXNfY21kICptZWdhc2FzX2dldF9j
bWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UKCQkJCQkJICAqaW5zdGFuY2UpCnsKCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7CglzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCA9IE5VTEw7CgoJc3Bpbl9sb2Nr
X2lycXNhdmUoJmluc3RhbmNlLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7CgoJaWYgKCFsaXN0X2Vt
cHR5KCZpbnN0YW5jZS0+Y21kX3Bvb2wpKSB7CgkJY21kID0gbGlzdF9lbnRyeSgoJmluc3RhbmNl
LT5jbWRfcG9vbCktPm5leHQsCgkJCQkgc3RydWN0IG1lZ2FzYXNfY21kLCBsaXN0KTsKCQlsaXN0
X2RlbF9pbml0KCZjbWQtPmxpc3QpOwoJfSBlbHNlIHsKCQlwcmludGsoS0VSTl9FUlIgIm1lZ2Fz
YXM6IENvbW1hbmQgcG9vbCBlbXB0eSFcbiIpOwoJfQoKCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
Jmluc3RhbmNlLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7CglyZXR1cm4gY21kOwp9CgovKioKICog
bWVnYXNhc19yZXR1cm5fY21kIC0JUmV0dXJuIGEgY21kIHRvIGZyZWUgY29tbWFuZCBwb29sCiAq
IEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogKiBAY21kOgkJQ29tbWFuZCBwYWNrZXQg
dG8gYmUgcmV0dXJuZWQgdG8gZnJlZSBjb21tYW5kIHBvb2wKICovCnN0YXRpYyBpbmxpbmUgdm9p
ZAptZWdhc2FzX3JldHVybl9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBz
dHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCkKewoJdW5zaWduZWQgbG9uZyBmbGFnczsKCglzcGluX2xv
Y2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsKCgljbWQtPnNjbWQg
PSBOVUxMOwoJbGlzdF9hZGRfdGFpbCgmY21kLT5saXN0LCAmaW5zdGFuY2UtPmNtZF9wb29sKTsK
CglzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+Y21kX3Bvb2xfbG9jaywgZmxhZ3Mp
Owp9CgoKLyoqCioJVGhlIGZvbGxvd2luZyBmdW5jdGlvbnMgYXJlIGRlZmluZWQgZm9yIHhzY2Fs
ZSAKKgkoZGV2aWNlaWQgOiAxMDY0UiwgUEVSQzUpIGNvbnRyb2xsZXJzCiovCgovKioKICogbWVn
YXNhc19lbmFibGVfaW50cl94c2NhbGUgLQlFbmFibGVzIGludGVycnVwdHMKICogQHJlZ3M6CQkJ
TUZJIHJlZ2lzdGVyIHNldAogKi8Kc3RhdGljIGlubGluZSB2b2lkCm1lZ2FzYXNfZW5hYmxlX2lu
dHJfeHNjYWxlKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICogcmVncykKewoJ
d3JpdGVsKDAsICYocmVncyktPm91dGJvdW5kX2ludHJfbWFzayk7CgoJLyogRHVtbXkgcmVhZGwg
dG8gZm9yY2UgcGNpIGZsdXNoICovCglyZWFkbCgmcmVncy0+b3V0Ym91bmRfaW50cl9tYXNrKTsK
fQoKLyoqCiAqIG1lZ2FzYXNfZGlzYWJsZV9pbnRyX3hzY2FsZSAtRGlzYWJsZXMgaW50ZXJydXB0
CiAqIEByZWdzOgkJCU1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbmxpbmUgdm9pZAptZWdh
c2FzX2Rpc2FibGVfaW50cl94c2NhbGUoc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9t
ZW0gKiByZWdzKQp7Cgl1MzIgbWFzayA9IDB4MWY7Cgl3cml0ZWwobWFzaywgJnJlZ3MtPm91dGJv
dW5kX2ludHJfbWFzayk7CgkvKiBEdW1teSByZWFkbCB0byBmb3JjZSBwY2kgZmx1c2ggKi8KCXJl
YWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX21hc2spOwp9CgovKioKICogbWVnYXNhc19yZWFkX2Z3
X3N0YXR1c19yZWdfeHNjYWxlIC0gcmV0dXJucyB0aGUgY3VycmVudCBGVyBzdGF0dXMgdmFsdWUK
ICogQHJlZ3M6CQkJTUZJIHJlZ2lzdGVyIHNldAogKi8Kc3RhdGljIHUzMgptZWdhc2FzX3JlYWRf
Zndfc3RhdHVzX3JlZ194c2NhbGUoc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0g
KiByZWdzKQp7CglyZXR1cm4gcmVhZGwoJihyZWdzKS0+b3V0Ym91bmRfbXNnXzApOwp9Ci8qKgog
KiBtZWdhc2FzX2NsZWFyX2ludGVycnVwdF94c2NhbGUgLQlDaGVjayAmIGNsZWFyIGludGVycnVw
dAogKiBAcmVnczoJCQkJTUZJIHJlZ2lzdGVyIHNldAogKi8Kc3RhdGljIGludCAKbWVnYXNhc19j
bGVhcl9pbnRyX3hzY2FsZShzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqIHJl
Z3MpCnsKCXUzMiBzdGF0dXM7Cgl1MzIgbWZpU3RhdHVzID0gMDsKCS8qCgkgKiBDaGVjayBpZiBp
dCBpcyBvdXIgaW50ZXJydXB0CgkgKi8KCXN0YXR1cyA9IHJlYWRsKCZyZWdzLT5vdXRib3VuZF9p
bnRyX3N0YXR1cyk7CgoJaWYgKHN0YXR1cyAmIE1GSV9PQl9JTlRSX1NUQVRVU19NQVNLKQoJCW1m
aVN0YXR1cyA9IE1GSV9JTlRSX0ZMQUdfUkVQTFlfTUVTU0FHRTsKCWlmIChzdGF0dXMgJiBNRklf
WFNDQUxFX09NUjBfQ0hBTkdFX0lOVEVSUlVQVCkKCQltZmlTdGF0dXMgfD0gTUZJX0lOVFJfRkxB
R19GSVJNV0FSRV9TVEFURV9DSEFOR0U7CgoJLyoKCSAqIENsZWFyIHRoZSBpbnRlcnJ1cHQgYnkg
d3JpdGluZyBiYWNrIHRoZSBzYW1lIHZhbHVlCgkgKi8KCWlmIChtZmlTdGF0dXMpCgkJd3JpdGVs
KHN0YXR1cywgJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKCgkvKiBEdW1teSByZWFkbCB0
byBmb3JjZSBwY2kgZmx1c2ggKi8KCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX3N0YXR1cyk7
CgoJcmV0dXJuIG1maVN0YXR1czsKfQoKLyoqCiAqIG1lZ2FzYXNfZmlyZV9jbWRfeHNjYWxlIC0J
U2VuZHMgY29tbWFuZCB0byB0aGUgRlcKICogQGZyYW1lX3BoeXNfYWRkciA6CQlQaHlzaWNhbCBh
ZGRyZXNzIG9mIGNtZAogKiBAZnJhbWVfY291bnQgOgkJTnVtYmVyIG9mIGZyYW1lcyBmb3IgdGhl
IGNvbW1hbmQKICogQHJlZ3MgOgkJCU1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbmxpbmUg
dm9pZCAKbWVnYXNhc19maXJlX2NtZF94c2NhbGUoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlLAoJCWRtYV9hZGRyX3QgZnJhbWVfcGh5c19hZGRyLAoJCXUzMiBmcmFtZV9jb3VudCwK
CQlzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJdW5zaWduZWQg
bG9uZyBmbGFnczsKCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdz
KTsKCXdyaXRlbCgoZnJhbWVfcGh5c19hZGRyID4+IDMpfChmcmFtZV9jb3VudCksCgkgICAgICAg
JihyZWdzKS0+aW5ib3VuZF9xdWV1ZV9wb3J0KTsKCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmlu
c3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwp9CgovKioKICogbWVnYXNhc19hZHBfcmVzZXRfeHNj
YWxlIC0gIEZvciBjb250cm9sbGVyIHJlc2V0CiAqIEByZWdzOiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIE1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbnQKbWVnYXNhc19hZHBfcmVz
ZXRfeHNjYWxlKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCXN0cnVjdCBtZWdh
c2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQp7Cgl1MzIgaTsKCXUzMiBwY2lkYXRhOwoJ
d3JpdGVsKE1GSV9BRFBfUkVTRVQsICZyZWdzLT5pbmJvdW5kX2Rvb3JiZWxsKTsKCglmb3IgKGkg
PSAwOyBpIDwgMzsgaSsrKQoJCW1zbGVlcCgxMDAwKTsgLyogc2xlZXAgZm9yIDMgc2VjcyAqLwoJ
cGNpZGF0YSAgPSAwOwoJcGNpX3JlYWRfY29uZmlnX2R3b3JkKGluc3RhbmNlLT5wZGV2LCBNRklf
MTA2OF9QQ1NSX09GRlNFVCwgJnBjaWRhdGEpOwoJcHJpbnRrKEtFUk5fTk9USUNFICJwY2lkYXRh
ID0gJXhcbiIsIHBjaWRhdGEpOwoJaWYgKHBjaWRhdGEgJiAweDIpIHsKCQlwcmludGsoS0VSTl9O
T1RJQ0UgIm1maSAxMDY4IG9mZnNldCByZWFkPSV4XG4iLCBwY2lkYXRhKTsKCQlwY2lkYXRhICY9
IH4weDI7CgkJcGNpX3dyaXRlX2NvbmZpZ19kd29yZChpbnN0YW5jZS0+cGRldiwKCQkJCU1GSV8x
MDY4X1BDU1JfT0ZGU0VULCBwY2lkYXRhKTsKCgkJZm9yIChpID0gMDsgaSA8IDI7IGkrKykKCQkJ
bXNsZWVwKDEwMDApOyAvKiBuZWVkIHRvIHdhaXQgMiBzZWNzIGFnYWluICovCgoJCXBjaWRhdGEg
ID0gMDsKCQlwY2lfcmVhZF9jb25maWdfZHdvcmQoaW5zdGFuY2UtPnBkZXYsCgkJCQlNRklfMTA2
OF9GV19IQU5EU0hBS0VfT0ZGU0VULCAmcGNpZGF0YSk7CgkJcHJpbnRrKEtFUk5fTk9USUNFICIx
MDY4IG9mZnNldCBoYW5kc2hha2UgcmVhZD0leFxuIiwgcGNpZGF0YSk7CgkJaWYgKChwY2lkYXRh
ICYgMHhmZmZmMDAwMCkgPT0gTUZJXzEwNjhfRldfUkVBRFkpIHsKCQkJcHJpbnRrKEtFUk5fTk9U
SUNFICIxMDY4IG9mZnNldCBwY2lkdD0leFxuIiwgcGNpZGF0YSk7CgkJCXBjaWRhdGEgPSAwOwoJ
CQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKGluc3RhbmNlLT5wZGV2LAoJCQkJTUZJXzEwNjhfRldf
SEFORFNIQUtFX09GRlNFVCwgcGNpZGF0YSk7CgkJfQoJfQoJcmV0dXJuIDA7Cn0KCi8qKgogKiBt
ZWdhc2FzX2NoZWNrX3Jlc2V0X3hzY2FsZSAtCUZvciBjb250cm9sbGVyIHJlc2V0IGNoZWNrCiAq
IEByZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfY2hlY2tf
cmVzZXRfeHNjYWxlKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCQlzdHJ1Y3Qg
bWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJdTMyIGNvbnN1bWVyOwoJY29u
c3VtZXIgPSAqaW5zdGFuY2UtPmNvbnN1bWVyOwoKCWlmICgoaW5zdGFuY2UtPmFkcHJlY292ZXJ5
ICE9IE1FR0FTQVNfSEJBX09QRVJBVElPTkFMKSAmJgoJCSgqaW5zdGFuY2UtPmNvbnN1bWVyID09
IE1FR0FTQVNfQURQUkVTRVRfSU5QUk9HX1NJR04pKSB7CgkJcmV0dXJuIDE7Cgl9CglyZXR1cm4g
MDsKfQoKc3RhdGljIHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlIG1lZ2FzYXNfaW5z
dGFuY2VfdGVtcGxhdGVfeHNjYWxlID0gewoKCS5maXJlX2NtZCA9IG1lZ2FzYXNfZmlyZV9jbWRf
eHNjYWxlLAoJLmVuYWJsZV9pbnRyID0gbWVnYXNhc19lbmFibGVfaW50cl94c2NhbGUsCgkuZGlz
YWJsZV9pbnRyID0gbWVnYXNhc19kaXNhYmxlX2ludHJfeHNjYWxlLAoJLmNsZWFyX2ludHIgPSBt
ZWdhc2FzX2NsZWFyX2ludHJfeHNjYWxlLAoJLnJlYWRfZndfc3RhdHVzX3JlZyA9IG1lZ2FzYXNf
cmVhZF9md19zdGF0dXNfcmVnX3hzY2FsZSwKCS5hZHBfcmVzZXQgPSBtZWdhc2FzX2FkcF9yZXNl
dF94c2NhbGUsCgkuY2hlY2tfcmVzZXQgPSBtZWdhc2FzX2NoZWNrX3Jlc2V0X3hzY2FsZSwKfTsK
Ci8qKgoqCVRoaXMgaXMgdGhlIGVuZCBvZiBzZXQgb2YgZnVuY3Rpb25zICYgZGVmaW5pdGlvbnMg
c3BlY2lmaWMgCioJdG8geHNjYWxlIChkZXZpY2VpZCA6IDEwNjRSLCBQRVJDNSkgY29udHJvbGxl
cnMKKi8KCi8qKgoqCVRoZSBmb2xsb3dpbmcgZnVuY3Rpb25zIGFyZSBkZWZpbmVkIGZvciBwcGMg
KGRldmljZWlkIDogMHg2MCkgCiogCWNvbnRyb2xsZXJzCiovCgovKioKICogbWVnYXNhc19lbmFi
bGVfaW50cl9wcGMgLQlFbmFibGVzIGludGVycnVwdHMKICogQHJlZ3M6CQkJTUZJIHJlZ2lzdGVy
IHNldAogKi8Kc3RhdGljIGlubGluZSB2b2lkCm1lZ2FzYXNfZW5hYmxlX2ludHJfcHBjKHN0cnVj
dCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICogcmVncykKewoJd3JpdGVsKDB4RkZGRkZG
RkYsICYocmVncyktPm91dGJvdW5kX2Rvb3JiZWxsX2NsZWFyKTsKICAgIAoJd3JpdGVsKH4weDgw
MDAwMDAwLCAmKHJlZ3MpLT5vdXRib3VuZF9pbnRyX21hc2spOwoKCS8qIER1bW15IHJlYWRsIHRv
IGZvcmNlIHBjaSBmbHVzaCAqLwoJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2ludHJfbWFzayk7Cn0K
Ci8qKgogKiBtZWdhc2FzX2Rpc2FibGVfaW50cl9wcGMgLQlEaXNhYmxlIGludGVycnVwdAogKiBA
cmVnczoJCQlNRkkgcmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMgaW5saW5lIHZvaWQKbWVnYXNhc19k
aXNhYmxlX2ludHJfcHBjKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICogcmVn
cykKewoJdTMyIG1hc2sgPSAweEZGRkZGRkZGOwoJd3JpdGVsKG1hc2ssICZyZWdzLT5vdXRib3Vu
ZF9pbnRyX21hc2spOwoJLyogRHVtbXkgcmVhZGwgdG8gZm9yY2UgcGNpIGZsdXNoICovCglyZWFk
bCgmcmVncy0+b3V0Ym91bmRfaW50cl9tYXNrKTsKfQoKLyoqCiAqIG1lZ2FzYXNfcmVhZF9md19z
dGF0dXNfcmVnX3BwYyAtIHJldHVybnMgdGhlIGN1cnJlbnQgRlcgc3RhdHVzIHZhbHVlCiAqIEBy
ZWdzOgkJCU1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyB1MzIKbWVnYXNhc19yZWFkX2Z3X3N0
YXR1c19yZWdfcHBjKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICogcmVncykK
ewoJcmV0dXJuIHJlYWRsKCYocmVncyktPm91dGJvdW5kX3NjcmF0Y2hfcGFkKTsKfQoKLyoqCiAq
IG1lZ2FzYXNfY2xlYXJfaW50ZXJydXB0X3BwYyAtCUNoZWNrICYgY2xlYXIgaW50ZXJydXB0CiAq
IEByZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMgaW50IAptZWdhc2FzX2NsZWFy
X2ludHJfcHBjKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICogcmVncykKewoJ
dTMyIHN0YXR1czsKCS8qCgkgKiBDaGVjayBpZiBpdCBpcyBvdXIgaW50ZXJydXB0CgkgKi8KCXN0
YXR1cyA9IHJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX3N0YXR1cyk7CgoJaWYgKCEoc3RhdHVz
ICYgTUZJX1JFUExZXzEwNzhfTUVTU0FHRV9JTlRFUlJVUFQpKSB7CgkJcmV0dXJuIDA7Cgl9CgoJ
LyoKCSAqIENsZWFyIHRoZSBpbnRlcnJ1cHQgYnkgd3JpdGluZyBiYWNrIHRoZSBzYW1lIHZhbHVl
CgkgKi8KCXdyaXRlbChzdGF0dXMsICZyZWdzLT5vdXRib3VuZF9kb29yYmVsbF9jbGVhcik7CgoJ
LyogRHVtbXkgcmVhZGwgdG8gZm9yY2UgcGNpIGZsdXNoICovCglyZWFkbCgmcmVncy0+b3V0Ym91
bmRfZG9vcmJlbGxfY2xlYXIpOwoKCXJldHVybiAxOwp9Ci8qKgogKiBtZWdhc2FzX2ZpcmVfY21k
X3BwYyAtCVNlbmRzIGNvbW1hbmQgdG8gdGhlIEZXCiAqIEBmcmFtZV9waHlzX2FkZHIgOgkJUGh5
c2ljYWwgYWRkcmVzcyBvZiBjbWQKICogQGZyYW1lX2NvdW50IDoJCU51bWJlciBvZiBmcmFtZXMg
Zm9yIHRoZSBjb21tYW5kCiAqIEByZWdzIDoJCQlNRkkgcmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMg
aW5saW5lIHZvaWQgCm1lZ2FzYXNfZmlyZV9jbWRfcHBjKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZSwKCQlkbWFfYWRkcl90IGZyYW1lX3BoeXNfYWRkciwKCQl1MzIgZnJhbWVfY291
bnQsCgkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCnsKCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CglzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBm
bGFncyk7Cgl3cml0ZWwoKGZyYW1lX3BoeXNfYWRkciB8IChmcmFtZV9jb3VudDw8MSkpfDEsIAoJ
CQkmKHJlZ3MpLT5pbmJvdW5kX3F1ZXVlX3BvcnQpOwoJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
aW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7Cn0KCi8qKgogKiBtZWdhc2FzX2FkcF9yZXNldF9w
cGMgLQlGb3IgY29udHJvbGxlciByZXNldAogKiBAcmVnczoJCQkJTUZJIHJlZ2lzdGVyIHNldAog
Ki8Kc3RhdGljIGludAptZWdhc2FzX2FkcF9yZXNldF9wcGMoc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlLAoJCQlzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVn
cykKewoJcmV0dXJuIDA7Cn0KCi8qKgogKiBtZWdhc2FzX2NoZWNrX3Jlc2V0X3BwYyAtCUZvciBj
b250cm9sbGVyIHJlc2V0IGNoZWNrCiAqIEByZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CiAqLwpz
dGF0aWMgaW50Cm1lZ2FzYXNfY2hlY2tfcmVzZXRfcHBjKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZSwKCQkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3Mp
CnsKCXJldHVybiAwOwp9CnN0YXRpYyBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZSBt
ZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlX3BwYyA9IHsKCQoJLmZpcmVfY21kID0gbWVnYXNhc19m
aXJlX2NtZF9wcGMsCgkuZW5hYmxlX2ludHIgPSBtZWdhc2FzX2VuYWJsZV9pbnRyX3BwYywKCS5k
aXNhYmxlX2ludHIgPSBtZWdhc2FzX2Rpc2FibGVfaW50cl9wcGMsCgkuY2xlYXJfaW50ciA9IG1l
Z2FzYXNfY2xlYXJfaW50cl9wcGMsCgkucmVhZF9md19zdGF0dXNfcmVnID0gbWVnYXNhc19yZWFk
X2Z3X3N0YXR1c19yZWdfcHBjLAoJLmFkcF9yZXNldCA9IG1lZ2FzYXNfYWRwX3Jlc2V0X3BwYywK
CS5jaGVja19yZXNldCA9IG1lZ2FzYXNfY2hlY2tfcmVzZXRfcHBjLAp9OwoKLyoqCiAqIG1lZ2Fz
YXNfZW5hYmxlX2ludHJfc2tpbm55IC0JRW5hYmxlcyBpbnRlcnJ1cHRzCiAqIEByZWdzOgkJCU1G
SSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbmxpbmUgdm9pZAptZWdhc2FzX2VuYWJsZV9pbnRy
X3NraW5ueShzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJd3Jp
dGVsKDB4RkZGRkZGRkYsICYocmVncyktPm91dGJvdW5kX2ludHJfbWFzayk7CgoJd3JpdGVsKH5N
RklfU0tJTk5ZX0VOQUJMRV9JTlRFUlJVUFRfTUFTSywgJihyZWdzKS0+b3V0Ym91bmRfaW50cl9t
YXNrKTsKCgkvKiBEdW1teSByZWFkbCB0byBmb3JjZSBwY2kgZmx1c2ggKi8KCXJlYWRsKCZyZWdz
LT5vdXRib3VuZF9pbnRyX21hc2spOwp9CgovKioKICogbWVnYXNhc19kaXNhYmxlX2ludHJfc2tp
bm55IC0JRGlzYWJsZXMgaW50ZXJydXB0CiAqIEByZWdzOgkJCU1GSSByZWdpc3RlciBzZXQKICov
CnN0YXRpYyBpbmxpbmUgdm9pZAptZWdhc2FzX2Rpc2FibGVfaW50cl9za2lubnkoc3RydWN0IG1l
Z2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCnsKCXUzMiBtYXNrID0gMHhGRkZGRkZG
RjsKCXdyaXRlbChtYXNrLCAmcmVncy0+b3V0Ym91bmRfaW50cl9tYXNrKTsKCS8qIER1bW15IHJl
YWRsIHRvIGZvcmNlIHBjaSBmbHVzaCAqLwoJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2ludHJfbWFz
ayk7Cn0KCi8qKgogKiBtZWdhc2FzX3JlYWRfZndfc3RhdHVzX3JlZ19za2lubnkgLSByZXR1cm5z
IHRoZSBjdXJyZW50IEZXIHN0YXR1cyB2YWx1ZQogKiBAcmVnczoJCQlNRkkgcmVnaXN0ZXIgc2V0
CiAqLwpzdGF0aWMgdTMyCm1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX3NraW5ueShzdHJ1Y3Qg
bWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJcmV0dXJuIHJlYWRsKCYocmVn
cyktPm91dGJvdW5kX3NjcmF0Y2hfcGFkKTsKfQoKLyoqCiAqIG1lZ2FzYXNfY2xlYXJfaW50ZXJy
dXB0X3NraW5ueSAtCUNoZWNrICYgY2xlYXIgaW50ZXJydXB0CiAqIEByZWdzOgkJCQlNRkkgcmVn
aXN0ZXIgc2V0CiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfY2xlYXJfaW50cl9za2lubnkoc3RydWN0
IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCnsKCXUzMiBzdGF0dXM7CgkvKgoJ
ICogQ2hlY2sgaWYgaXQgaXMgb3VyIGludGVycnVwdAoJICovCglzdGF0dXMgPSByZWFkbCgmcmVn
cy0+b3V0Ym91bmRfaW50cl9zdGF0dXMpOwoKCWlmICghKHN0YXR1cyAmIE1GSV9TS0lOTllfRU5B
QkxFX0lOVEVSUlVQVF9NQVNLKSkgewoJCXJldHVybiAwOwoJfQoKCS8qCgkgKiBDbGVhciB0aGUg
aW50ZXJydXB0IGJ5IHdyaXRpbmcgYmFjayB0aGUgc2FtZSB2YWx1ZQoJICovCgl3cml0ZWwoc3Rh
dHVzLCAmcmVncy0+b3V0Ym91bmRfaW50cl9zdGF0dXMpOwoKCS8qCgkqIGR1bW15IHJlYWQgdG8g
Zmx1c2ggUENJCgkqLwoJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKCglyZXR1
cm4gMTsKfQoKLyoqCiAqIG1lZ2FzYXNfZmlyZV9jbWRfc2tpbm55IC0JU2VuZHMgY29tbWFuZCB0
byB0aGUgRlcKICogQGZyYW1lX3BoeXNfYWRkciA6CQlQaHlzaWNhbCBhZGRyZXNzIG9mIGNtZAog
KiBAZnJhbWVfY291bnQgOgkJTnVtYmVyIG9mIGZyYW1lcyBmb3IgdGhlIGNvbW1hbmQKICogQHJl
Z3MgOgkJCU1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbmxpbmUgdm9pZAptZWdhc2FzX2Zp
cmVfY21kX3NraW5ueShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCgkJCWRtYV9h
ZGRyX3QgZnJhbWVfcGh5c19hZGRyLAoJCQl1MzIgZnJhbWVfY291bnQsCgkJCXN0cnVjdCBtZWdh
c2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQp7Cgl1bnNpZ25lZCBsb25nIGZsYWdzOwoJ
c3Bpbl9sb2NrX2lycXNhdmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoJd3JpdGVsKDAs
ICYocmVncyktPmluYm91bmRfaGlnaF9xdWV1ZV9wb3J0KTsKCXdyaXRlbCgoZnJhbWVfcGh5c19h
ZGRyIHwgKGZyYW1lX2NvdW50PDwxKSl8MSwKCQkmKHJlZ3MpLT5pbmJvdW5kX2xvd19xdWV1ZV9w
b3J0KTsKCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3Mp
Owp9CgovKioKICogbWVnYXNhc19hZHBfcmVzZXRfc2tpbm55IC0JRm9yIGNvbnRyb2xsZXIgcmVz
ZXQKICogQHJlZ3M6CQkJCU1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbnQKbWVnYXNhc19h
ZHBfcmVzZXRfc2tpbm55KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCQkJc3Ry
dWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCnsKCXJldHVybiAwOwp9Cgov
KioKICogbWVnYXNhc19jaGVja19yZXNldF9za2lubnkgLQlGb3IgY29udHJvbGxlciByZXNldCBj
aGVjawogKiBAcmVnczoJCQkJTUZJIHJlZ2lzdGVyIHNldAogKi8Kc3RhdGljIGludAptZWdhc2Fz
X2NoZWNrX3Jlc2V0X3NraW5ueShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCgkJ
CQlzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJcmV0dXJuIDA7
Cn0KCnN0YXRpYyBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZSBtZWdhc2FzX2luc3Rh
bmNlX3RlbXBsYXRlX3NraW5ueSA9IHsKCgkuZmlyZV9jbWQgPSBtZWdhc2FzX2ZpcmVfY21kX3Nr
aW5ueSwKCS5lbmFibGVfaW50ciA9IG1lZ2FzYXNfZW5hYmxlX2ludHJfc2tpbm55LAoJLmRpc2Fi
bGVfaW50ciA9IG1lZ2FzYXNfZGlzYWJsZV9pbnRyX3NraW5ueSwKCS5jbGVhcl9pbnRyID0gbWVn
YXNhc19jbGVhcl9pbnRyX3NraW5ueSwKCS5yZWFkX2Z3X3N0YXR1c19yZWcgPSBtZWdhc2FzX3Jl
YWRfZndfc3RhdHVzX3JlZ19za2lubnksCgkuYWRwX3Jlc2V0ID0gbWVnYXNhc19hZHBfcmVzZXRf
c2tpbm55LAoJLmNoZWNrX3Jlc2V0ID0gbWVnYXNhc19jaGVja19yZXNldF9za2lubnksCn07CgoK
LyoqCioJVGhlIGZvbGxvd2luZyBmdW5jdGlvbnMgYXJlIGRlZmluZWQgZm9yIGdlbjIgKGRldmlj
ZWlkIDogMHg3OCAweDc5KQoqCWNvbnRyb2xsZXJzCiovCgovKioKICogbWVnYXNhc19lbmFibGVf
aW50cl9nZW4yIC0gIEVuYWJsZXMgaW50ZXJydXB0cwogKiBAcmVnczogICAgICAgICAgICAgICAg
ICAgICAgTUZJIHJlZ2lzdGVyIHNldAogKi8Kc3RhdGljIGlubGluZSB2b2lkCm1lZ2FzYXNfZW5h
YmxlX2ludHJfZ2VuMihzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykK
ewoJd3JpdGVsKDB4RkZGRkZGRkYsICYocmVncyktPm91dGJvdW5kX2Rvb3JiZWxsX2NsZWFyKTsK
CgkvKiB3cml0ZSB+MHgwMDAwMDAwNSAoNCAmIDEpIHRvIHRoZSBpbnRyIG1hc2sqLwoJd3JpdGVs
KH5NRklfR0VOMl9FTkFCTEVfSU5URVJSVVBUX01BU0ssICYocmVncyktPm91dGJvdW5kX2ludHJf
bWFzayk7CgoJLyogRHVtbXkgcmVhZGwgdG8gZm9yY2UgcGNpIGZsdXNoICovCglyZWFkbCgmcmVn
cy0+b3V0Ym91bmRfaW50cl9tYXNrKTsKfQoKLyoqCiAqIG1lZ2FzYXNfZGlzYWJsZV9pbnRyX2dl
bjIgLSBEaXNhYmxlcyBpbnRlcnJ1cHQKICogQHJlZ3M6ICAgICAgICAgICAgICAgICAgICAgIE1G
SSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbmxpbmUgdm9pZAptZWdhc2FzX2Rpc2FibGVfaW50
cl9nZW4yKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQp7Cgl1MzIg
bWFzayA9IDB4RkZGRkZGRkY7Cgl3cml0ZWwobWFzaywgJnJlZ3MtPm91dGJvdW5kX2ludHJfbWFz
ayk7CgkvKiBEdW1teSByZWFkbCB0byBmb3JjZSBwY2kgZmx1c2ggKi8KCXJlYWRsKCZyZWdzLT5v
dXRib3VuZF9pbnRyX21hc2spOwp9CgovKioKICogbWVnYXNhc19yZWFkX2Z3X3N0YXR1c19yZWdf
Z2VuMiAtIHJldHVybnMgdGhlIGN1cnJlbnQgRlcgc3RhdHVzIHZhbHVlCiAqIEByZWdzOiAgICAg
ICAgICAgICAgICAgICAgICBNRkkgcmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMgdTMyCm1lZ2FzYXNf
cmVhZF9md19zdGF0dXNfcmVnX2dlbjIoc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9t
ZW0gKnJlZ3MpCnsKCXJldHVybiByZWFkbCgmKHJlZ3MpLT5vdXRib3VuZF9zY3JhdGNoX3BhZCk7
Cn0KCi8qKgogKiBtZWdhc2FzX2NsZWFyX2ludGVycnVwdF9nZW4yIC0gICAgICBDaGVjayAmIGNs
ZWFyIGludGVycnVwdAogKiBAcmVnczogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBNRkkg
cmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfY2xlYXJfaW50cl9nZW4yKHN0cnVj
dCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQp7Cgl1MzIgc3RhdHVzOwoJdTMy
IG1maVN0YXR1cyA9IDA7CgkvKgoJICogQ2hlY2sgaWYgaXQgaXMgb3VyIGludGVycnVwdAoJICov
CglzdGF0dXMgPSByZWFkbCgmcmVncy0+b3V0Ym91bmRfaW50cl9zdGF0dXMpOwoKCWlmIChzdGF0
dXMgJiBNRklfR0VOMl9FTkFCTEVfSU5URVJSVVBUX01BU0spIHsKCQltZmlTdGF0dXMgPSBNRklf
SU5UUl9GTEFHX1JFUExZX01FU1NBR0U7Cgl9CglpZiAoc3RhdHVzICYgTUZJX0cyX09VVEJPVU5E
X0RPT1JCRUxMX0NIQU5HRV9JTlRFUlJVUFQpIHsKCQltZmlTdGF0dXMgfD0gTUZJX0lOVFJfRkxB
R19GSVJNV0FSRV9TVEFURV9DSEFOR0U7Cgl9CgoJLyoKCSAqIENsZWFyIHRoZSBpbnRlcnJ1cHQg
Ynkgd3JpdGluZyBiYWNrIHRoZSBzYW1lIHZhbHVlCgkgKi8KCWlmIChtZmlTdGF0dXMpCgkJd3Jp
dGVsKHN0YXR1cywgJnJlZ3MtPm91dGJvdW5kX2Rvb3JiZWxsX2NsZWFyKTsKCgkvKiBEdW1teSBy
ZWFkbCB0byBmb3JjZSBwY2kgZmx1c2ggKi8KCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX3N0
YXR1cyk7CgoJcmV0dXJuIG1maVN0YXR1czsKfQovKioKICogbWVnYXNhc19maXJlX2NtZF9nZW4y
IC0gICAgIFNlbmRzIGNvbW1hbmQgdG8gdGhlIEZXCiAqIEBmcmFtZV9waHlzX2FkZHIgOiAgICAg
ICAgICBQaHlzaWNhbCBhZGRyZXNzIG9mIGNtZAogKiBAZnJhbWVfY291bnQgOiAgICAgICAgICAg
ICAgTnVtYmVyIG9mIGZyYW1lcyBmb3IgdGhlIGNvbW1hbmQKICogQHJlZ3MgOiAgICAgICAgICAg
ICAgICAgICAgIE1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbmxpbmUgdm9pZAptZWdhc2Fz
X2ZpcmVfY21kX2dlbjIoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAoJCQlkbWFf
YWRkcl90IGZyYW1lX3BoeXNfYWRkciwKCQkJdTMyIGZyYW1lX2NvdW50LAoJCQlzdHJ1Y3QgbWVn
YXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJdW5zaWduZWQgbG9uZyBmbGFnczsK
CXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKCXdyaXRlbCgo
ZnJhbWVfcGh5c19hZGRyIHwgKGZyYW1lX2NvdW50PDwxKSl8MSwKCQkJJihyZWdzKS0+aW5ib3Vu
ZF9xdWV1ZV9wb3J0KTsKCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9j
aywgZmxhZ3MpOwp9CgovKioKICogbWVnYXNhc19hZHBfcmVzZXRfZ2VuMiAtCUZvciBjb250cm9s
bGVyIHJlc2V0CiAqIEByZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CiAqLwpzdGF0aWMgaW50Cm1l
Z2FzYXNfYWRwX3Jlc2V0X2dlbjIoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAoJ
CQlzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVnX3NldCkKewoJdTMyCQkJ
cmV0cnkgPSAwIDsKCXUzMgkJCUhvc3REaWFnOwoKCXdyaXRlbCgwLCAmcmVnX3NldC0+c2VxX29m
ZnNldCk7Cgl3cml0ZWwoNCwgJnJlZ19zZXQtPnNlcV9vZmZzZXQpOwoJd3JpdGVsKDB4YiwgJnJl
Z19zZXQtPnNlcV9vZmZzZXQpOwoJd3JpdGVsKDIsICZyZWdfc2V0LT5zZXFfb2Zmc2V0KTsKCXdy
aXRlbCg3LCAmcmVnX3NldC0+c2VxX29mZnNldCk7Cgl3cml0ZWwoMHhkLCAmcmVnX3NldC0+c2Vx
X29mZnNldCk7Cgltc2xlZXAoMTAwMCk7CgoJSG9zdERpYWcgPSAodTMyKXJlYWRsKCZyZWdfc2V0
LT5ob3N0X2RpYWcpOwoKCXdoaWxlICggISggSG9zdERpYWcgJiBESUFHX1dSSVRFX0VOQUJMRSkg
KSB7CgkJbXNsZWVwKDEwMCk7CgkJSG9zdERpYWcgPSAodTMyKXJlYWRsKCZyZWdfc2V0LT5ob3N0
X2RpYWcpOwoJCXByaW50ayhLRVJOX05PVElDRSAiUkVTRVRHRU4yOiByZXRyeT0leCwgaG9zdGRp
YWc9JXhcbiIsCgkJCQkJcmV0cnksIEhvc3REaWFnKTsKCgkJaWYgKHJldHJ5KysgPj0gMTAwKQoJ
CQlyZXR1cm4gMTsKCgl9CgoJcHJpbnRrKEtFUk5fTk9USUNFICJBRFBfUkVTRVRfR0VOMjogSG9z
dERpYWc9JXhcbiIsIEhvc3REaWFnKTsKCgl3cml0ZWwoKEhvc3REaWFnIHwgRElBR19SRVNFVF9B
REFQVEVSKSwgJnJlZ19zZXQtPmhvc3RfZGlhZyk7CgoJc3NsZWVwKDEwKTsKCglIb3N0RGlhZyA9
ICh1MzIpcmVhZGwoJnJlZ19zZXQtPmhvc3RfZGlhZyk7Cgl3aGlsZSAoICggSG9zdERpYWcgJiBE
SUFHX1JFU0VUX0FEQVBURVIpICkgewoJCW1zbGVlcCgxMDApOwoJCUhvc3REaWFnID0gKHUzMily
ZWFkbCgmcmVnX3NldC0+aG9zdF9kaWFnKTsKCQlwcmludGsoS0VSTl9OT1RJQ0UgIlJFU0VUX0dF
TjI6IHJldHJ5PSV4LCBob3N0ZGlhZz0leFxuIiwKCQkJCXJldHJ5LCBIb3N0RGlhZyk7CgoJCWlm
IChyZXRyeSsrID49IDEwMDApCgkJCXJldHVybiAxOwoKCX0KCXJldHVybiAwOwp9CgovKioKICog
bWVnYXNhc19jaGVja19yZXNldF9nZW4yIC0JRm9yIGNvbnRyb2xsZXIgcmVzZXQgY2hlY2sKICog
QHJlZ3M6CQkJCU1GSSByZWdpc3RlciBzZXQKICovCnN0YXRpYyBpbnQKbWVnYXNhc19jaGVja19y
ZXNldF9nZW4yKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCQlzdHJ1Y3QgbWVn
YXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKewoJaWYgKGluc3RhbmNlLT5hZHByZWNv
dmVyeSAhPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTCkgewoJCXJldHVybiAxOwoJfQoKCXJldHVy
biAwOwp9CgpzdGF0aWMgc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGUgbWVnYXNhc19p
bnN0YW5jZV90ZW1wbGF0ZV9nZW4yID0gewoKCS5maXJlX2NtZCA9IG1lZ2FzYXNfZmlyZV9jbWRf
Z2VuMiwKCS5lbmFibGVfaW50ciA9IG1lZ2FzYXNfZW5hYmxlX2ludHJfZ2VuMiwKCS5kaXNhYmxl
X2ludHIgPSBtZWdhc2FzX2Rpc2FibGVfaW50cl9nZW4yLAoJLmNsZWFyX2ludHIgPSBtZWdhc2Fz
X2NsZWFyX2ludHJfZ2VuMiwKCS5yZWFkX2Z3X3N0YXR1c19yZWcgPSBtZWdhc2FzX3JlYWRfZndf
c3RhdHVzX3JlZ19nZW4yLAoJLmFkcF9yZXNldCA9IG1lZ2FzYXNfYWRwX3Jlc2V0X2dlbjIsCgku
Y2hlY2tfcmVzZXQgPSBtZWdhc2FzX2NoZWNrX3Jlc2V0X2dlbjIsCn07CgovKioKKglUaGlzIGlz
IHRoZSBlbmQgb2Ygc2V0IG9mIGZ1bmN0aW9ucyAmIGRlZmluaXRpb25zCiogICAgICAgc3BlY2lm
aWMgdG8gZ2VuMiAoZGV2aWNlaWQgOiAweDc4LCAweDc5KSBjb250cm9sbGVycwoqLwoKLyoqCiAq
IG1lZ2FzYXNfaXNzdWVfcG9sbGVkIC0JSXNzdWVzIGEgcG9sbGluZyBjb21tYW5kCiAqIEBpbnN0
YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKICogQGNtZDoJCQlDb21tYW5kIHBhY2tldCB0byBi
ZSBpc3N1ZWQgCiAqCiAqIEZvciBwb2xsaW5nLCBNRkkgcmVxdWlyZXMgdGhlIGNtZF9zdGF0dXMg
dG8gYmUgc2V0IHRvIDB4RkYgYmVmb3JlIHBvc3RpbmcuCiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNf
aXNzdWVfcG9sbGVkKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1l
Z2FzYXNfY21kICpjbWQpCnsKCWludCBpOwoJdTMyIG1zZWNzID0gTUZJX1BPTExfVElNRU9VVF9T
RUNTICogMTAwMDsKCglzdHJ1Y3QgbWVnYXNhc19oZWFkZXIgKmZyYW1lX2hkciA9ICZjbWQtPmZy
YW1lLT5oZHI7CgoJZnJhbWVfaGRyLT5jbWRfc3RhdHVzID0gMHhGRjsKCWZyYW1lX2hkci0+Zmxh
Z3MgfD0gTUZJX0ZSQU1FX0RPTlRfUE9TVF9JTl9SRVBMWV9RVUVVRTsKCgkvKgoJICogSXNzdWUg
dGhlIGZyYW1lIHVzaW5nIGluYm91bmQgcXVldWUgcG9ydAoJICovCglpbnN0YW5jZS0+aW5zdGFu
Y2V0LT5maXJlX2NtZChpbnN0YW5jZSwKCQkJY21kLT5mcmFtZV9waHlzX2FkZHIsIDAsIGluc3Rh
bmNlLT5yZWdfc2V0KTsKCgkvKgoJICogV2FpdCBmb3IgY21kX3N0YXR1cyB0byBjaGFuZ2UKCSAq
LwoJZm9yIChpID0gMDsgKGkgPCBtc2VjcykgJiYgKGZyYW1lX2hkci0+Y21kX3N0YXR1cyA9PSAw
eGZmKTsgaSsrKSB7CgkJcm1iKCk7CgkJbXNsZWVwKDEpOwoJfQoKCWlmIChmcmFtZV9oZHItPmNt
ZF9zdGF0dXMgPT0gMHhmZikKCQlyZXR1cm4gLUVUSU1FOwoKCXJldHVybiAwOwp9CgovKioKICog
bWVnYXNhc19pc3N1ZV9ibG9ja2VkX2NtZCAtCVN5bmNocm9ub3VzIHdyYXBwZXIgYXJvdW5kIHJl
Z3VsYXIgRlcgY21kcwogKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqIEBjbWQ6
CQkJQ29tbWFuZCB0byBiZSBpc3N1ZWQKICoKICogVGhpcyBmdW5jdGlvbiB3YWl0cyBvbiBhbiBl
dmVudCBmb3IgdGhlIGNvbW1hbmQgdG8gYmUgcmV0dXJuZWQgZnJvbSBJU1IuCiAqIE1heCB3YWl0
IHRpbWUgaXMgTUVHQVNBU19JTlRFUk5BTF9DTURfV0FJVF9USU1FIHNlY3MKICogVXNlZCB0byBp
c3N1ZSBpb2N0bCBjb21tYW5kcy4KICovCnN0YXRpYyBpbnQKbWVnYXNhc19pc3N1ZV9ibG9ja2Vk
X2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCgkJCSAgc3RydWN0IG1lZ2Fz
YXNfY21kICpjbWQpCnsKCWNtZC0+Y21kX3N0YXR1cyA9IEVOT0RBVEE7CgoJaW5zdGFuY2UtPmlu
c3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCgkJCWNtZC0+ZnJhbWVfcGh5c19hZGRyLCAwLCBp
bnN0YW5jZS0+cmVnX3NldCk7CgoJd2FpdF9ldmVudChpbnN0YW5jZS0+aW50X2NtZF93YWl0X3Es
IGNtZC0+Y21kX3N0YXR1cyAhPSBFTk9EQVRBKTsKCglyZXR1cm4gMDsKfQoKLyoqCiAqIG1lZ2Fz
YXNfaXNzdWVfYmxvY2tlZF9hYm9ydF9jbWQgLQlBYm9ydHMgcHJldmlvdXNseSBpc3N1ZWQgY21k
CiAqIEBpbnN0YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqIEBjbWRfdG9fYWJvcnQ6CQkJ
UHJldmlvdXNseSBpc3N1ZWQgY21kIHRvIGJlIGFib3J0ZWQKICoKICogTUZJIGZpcm13YXJlIGNh
biBhYm9ydCBwcmV2aW91c2x5IGlzc3VlZCBBRU4gY29tYW1uZCAoYXV0b21hdGljIGV2ZW50CiAq
IG5vdGlmaWNhdGlvbikuIFRoZSBtZWdhc2FzX2lzc3VlX2Jsb2NrZWRfYWJvcnRfY21kKCkgaXNz
dWVzIHN1Y2ggYWJvcnQKICogY21kIGFuZCB3YWl0cyBmb3IgcmV0dXJuIHN0YXR1cy4KICogTWF4
IHdhaXQgdGltZSBpcyBNRUdBU0FTX0lOVEVSTkFMX0NNRF9XQUlUX1RJTUUgc2VjcwogKi8Kc3Rh
dGljIGludAptZWdhc2FzX2lzc3VlX2Jsb2NrZWRfYWJvcnRfY21kKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICppbnN0YW5jZSwKCQkJCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kX3RvX2Fib3J0KQp7
CglzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKCXN0cnVjdCBtZWdhc2FzX2Fib3J0X2ZyYW1lICph
Ym9ydF9mcjsKCgljbWQgPSBtZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOwoKCWlmICghY21kKQoJ
CXJldHVybiAtMTsKCglhYm9ydF9mciA9ICZjbWQtPmZyYW1lLT5hYm9ydDsKCgkvKgoJICogUHJl
cGFyZSBhbmQgaXNzdWUgdGhlIGFib3J0IGZyYW1lCgkgKi8KCWFib3J0X2ZyLT5jbWQgPSBNRklf
Q01EX0FCT1JUOwoJYWJvcnRfZnItPmNtZF9zdGF0dXMgPSAweEZGOwoJYWJvcnRfZnItPmZsYWdz
ID0gMDsKCWFib3J0X2ZyLT5hYm9ydF9jb250ZXh0ID0gY21kX3RvX2Fib3J0LT5pbmRleDsKCWFi
b3J0X2ZyLT5hYm9ydF9tZmlfcGh5c19hZGRyX2xvID0gY21kX3RvX2Fib3J0LT5mcmFtZV9waHlz
X2FkZHI7CglhYm9ydF9mci0+YWJvcnRfbWZpX3BoeXNfYWRkcl9oaSA9IDA7CgoJY21kLT5zeW5j
X2NtZCA9IDE7CgljbWQtPmNtZF9zdGF0dXMgPSAweEZGOwoKCWluc3RhbmNlLT5pbnN0YW5jZXQt
PmZpcmVfY21kKGluc3RhbmNlLAoJCQljbWQtPmZyYW1lX3BoeXNfYWRkciwgMCwgaW5zdGFuY2Ut
PnJlZ19zZXQpOwoKCS8qCgkgKiBXYWl0IGZvciB0aGlzIGNtZCB0byBjb21wbGV0ZQoJICovCgl3
YWl0X2V2ZW50KGluc3RhbmNlLT5hYm9ydF9jbWRfd2FpdF9xLCBjbWQtPmNtZF9zdGF0dXMgIT0g
MHhGRik7CgljbWQtPnN5bmNfY21kID0gMDsKCgltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2Us
IGNtZCk7CglyZXR1cm4gMDsKfQoKLyoqCiAqIG1lZ2FzYXNfbWFrZV9zZ2wzMiAtCVByZXBhcmVz
IDMyLWJpdCBTR0wKICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqIEBzY3A6CQlT
Q1NJIGNvbW1hbmQgZnJvbSB0aGUgbWlkLWxheWVyCiAqIEBtZmlfc2dsOgkJU0dMIHRvIGJlIGZp
bGxlZCBpbgogKgogKiBJZiBzdWNjZXNzZnVsLCB0aGlzIGZ1bmN0aW9uIHJldHVybnMgdGhlIG51
bWJlciBvZiBTRyBlbGVtZW50cy4gT3RoZXJ3aXNlLAogKiBpdCByZXR1cm5lcyAtMS4KICovCnN0
YXRpYyBpbnQKbWVnYXNhc19tYWtlX3NnbDMyKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSwgc3RydWN0IHNjc2lfY21uZCAqc2NwLAoJCSAgIHVuaW9uIG1lZ2FzYXNfc2dsICptZmlf
c2dsKQp7CglpbnQgaTsKCWludCBzZ2VfY291bnQ7CglzdHJ1Y3Qgc2NhdHRlcmxpc3QgKm9zX3Nn
bDsKCglzZ2VfY291bnQgPSBzY3NpX2RtYV9tYXAoc2NwKTsKCUJVR19PTihzZ2VfY291bnQgPCAw
KTsKCglpZiAoc2dlX2NvdW50KSB7CgkJc2NzaV9mb3JfZWFjaF9zZyhzY3AsIG9zX3NnbCwgc2dl
X2NvdW50LCBpKSB7CgkJCW1maV9zZ2wtPnNnZTMyW2ldLmxlbmd0aCA9IHNnX2RtYV9sZW4ob3Nf
c2dsKTsKCQkJbWZpX3NnbC0+c2dlMzJbaV0ucGh5c19hZGRyID0gc2dfZG1hX2FkZHJlc3Mob3Nf
c2dsKTsKCQl9Cgl9CglyZXR1cm4gc2dlX2NvdW50Owp9CgovKioKICogbWVnYXNhc19tYWtlX3Nn
bDY0IC0JUHJlcGFyZXMgNjQtYml0IFNHTAogKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3Rh
dGUKICogQHNjcDoJCVNDU0kgY29tbWFuZCBmcm9tIHRoZSBtaWQtbGF5ZXIKICogQG1maV9zZ2w6
CQlTR0wgdG8gYmUgZmlsbGVkIGluCiAqCiAqIElmIHN1Y2Nlc3NmdWwsIHRoaXMgZnVuY3Rpb24g
cmV0dXJucyB0aGUgbnVtYmVyIG9mIFNHIGVsZW1lbnRzLiBPdGhlcndpc2UsCiAqIGl0IHJldHVy
bmVzIC0xLgogKi8Kc3RhdGljIGludAptZWdhc2FzX21ha2Vfc2dsNjQoc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3Qgc2NzaV9jbW5kICpzY3AsCgkJICAgdW5pb24gbWVn
YXNhc19zZ2wgKm1maV9zZ2wpCnsKCWludCBpOwoJaW50IHNnZV9jb3VudDsKCXN0cnVjdCBzY2F0
dGVybGlzdCAqb3Nfc2dsOwoKCXNnZV9jb3VudCA9IHNjc2lfZG1hX21hcChzY3ApOwoJQlVHX09O
KHNnZV9jb3VudCA8IDApOwoKCWlmIChzZ2VfY291bnQpIHsKCQlzY3NpX2Zvcl9lYWNoX3NnKHNj
cCwgb3Nfc2dsLCBzZ2VfY291bnQsIGkpIHsKCQkJbWZpX3NnbC0+c2dlNjRbaV0ubGVuZ3RoID0g
c2dfZG1hX2xlbihvc19zZ2wpOwoJCQltZmlfc2dsLT5zZ2U2NFtpXS5waHlzX2FkZHIgPSBzZ19k
bWFfYWRkcmVzcyhvc19zZ2wpOwoJCX0KCX0KCXJldHVybiBzZ2VfY291bnQ7Cn0KCi8qKgogKiBt
ZWdhc2FzX21ha2Vfc2dsX3NraW5ueSAtIFByZXBhcmVzIElFRUUgU0dMCiAqIEBpbnN0YW5jZTog
ICAgICAgICAgIEFkYXB0ZXIgc29mdCBzdGF0ZQogKiBAc2NwOiAgICAgICAgICAgICAgICBTQ1NJ
IGNvbW1hbmQgZnJvbSB0aGUgbWlkLWxheWVyCiAqIEBtZmlfc2dsOiAgICAgICAgICAgIFNHTCB0
byBiZSBmaWxsZWQgaW4KICoKICogSWYgc3VjY2Vzc2Z1bCwgdGhpcyBmdW5jdGlvbiByZXR1cm5z
IHRoZSBudW1iZXIgb2YgU0cgZWxlbWVudHMuIE90aGVyd2lzZSwKICogaXQgcmV0dXJuZXMgLTEu
CiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfbWFrZV9zZ2xfc2tpbm55KHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICppbnN0YW5jZSwKCQlzdHJ1Y3Qgc2NzaV9jbW5kICpzY3AsIHVuaW9uIG1lZ2FzYXNf
c2dsICptZmlfc2dsKQp7CglpbnQgaTsKCWludCBzZ2VfY291bnQ7CglzdHJ1Y3Qgc2NhdHRlcmxp
c3QgKm9zX3NnbDsKCglzZ2VfY291bnQgPSBzY3NpX2RtYV9tYXAoc2NwKTsKCglpZiAoc2dlX2Nv
dW50KSB7CgkJc2NzaV9mb3JfZWFjaF9zZyhzY3AsIG9zX3NnbCwgc2dlX2NvdW50LCBpKSB7CgkJ
CW1maV9zZ2wtPnNnZV9za2lubnlbaV0ubGVuZ3RoID0gc2dfZG1hX2xlbihvc19zZ2wpOwoJCQlt
Zmlfc2dsLT5zZ2Vfc2tpbm55W2ldLnBoeXNfYWRkciA9CgkJCQkJCXNnX2RtYV9hZGRyZXNzKG9z
X3NnbCk7CgkJCW1maV9zZ2wtPnNnZV9za2lubnlbaV0uZmxhZyA9IDA7CgkJfQoJfQoJcmV0dXJu
IHNnZV9jb3VudDsKfQoKIC8qKgogKiBtZWdhc2FzX2dldF9mcmFtZV9jb3VudCAtIENvbXB1dGVz
IHRoZSBudW1iZXIgb2YgZnJhbWVzCiAqIEBmcmFtZV90eXBlCQk6IHR5cGUgb2YgZnJhbWUtIGlv
IG9yIHB0aHJ1IGZyYW1lCiAqIEBzZ2VfY291bnQJCTogbnVtYmVyIG9mIHNnIGVsZW1lbnRzCiAq
CiAqIFJldHVybnMgdGhlIG51bWJlciBvZiBmcmFtZXMgcmVxdWlyZWQgZm9yIG51bW5iZXIgb2Yg
c2dlJ3MgKHNnZV9jb3VudCkKICovCgpzdGF0aWMgdTMyIG1lZ2FzYXNfZ2V0X2ZyYW1lX2NvdW50
KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCQkJdTggc2dlX2NvdW50LCB1OCBm
cmFtZV90eXBlKQp7CglpbnQgbnVtX2NudDsKCWludCBzZ2VfYnl0ZXM7Cgl1MzIgc2dlX3N6OwoJ
dTMyIGZyYW1lX2NvdW50PTA7CgoJc2dlX3N6ID0gKElTX0RNQTY0KSA/IHNpemVvZihzdHJ1Y3Qg
bWVnYXNhc19zZ2U2NCkgOgoJICAgIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19zZ2UzMik7CgoJaWYg
KGluc3RhbmNlLT5mbGFnX2llZWUpIHsKCQlzZ2Vfc3ogPSBzaXplb2Yoc3RydWN0IG1lZ2FzYXNf
c2dlX3NraW5ueSk7Cgl9CgoJLyoKCSAqIE1haW4gZnJhbWUgY2FuIGNvbnRhaW4gMiBTR0VzIGZv
ciA2NC1iaXQgU0dMcyBhbmQKCSAqIDMgU0dFcyBmb3IgMzItYml0IFNHTHMgZm9yIGxkaW8gJgoJ
ICogMSBTR0VzIGZvciA2NC1iaXQgU0dMcyBhbmQKCSAqIDIgU0dFcyBmb3IgMzItYml0IFNHTHMg
Zm9yIHB0aHJ1IGZyYW1lCgkgKi8KCWlmICh1bmxpa2VseShmcmFtZV90eXBlID09IFBUSFJVX0ZS
QU1FKSkgewoJCWlmIChpbnN0YW5jZS0+ZmxhZ19pZWVlID09IDEpIHsKCQkJbnVtX2NudCA9IHNn
ZV9jb3VudCAtIDE7CgkJfSBlbHNlIGlmIChJU19ETUE2NCkKCQkJbnVtX2NudCA9IHNnZV9jb3Vu
dCAtIDE7CgkJZWxzZQoJCQludW1fY250ID0gc2dlX2NvdW50IC0gMjsKCX0gZWxzZSB7CgkJaWYg
KGluc3RhbmNlLT5mbGFnX2llZWUgPT0gMSkgewoJCQludW1fY250ID0gc2dlX2NvdW50IC0gMTsK
CQl9IGVsc2UgaWYgKElTX0RNQTY0KQoJCQludW1fY250ID0gc2dlX2NvdW50IC0gMjsKCQllbHNl
CgkJCW51bV9jbnQgPSBzZ2VfY291bnQgLSAzOwoJfQoKCWlmKG51bV9jbnQ+MCl7CgkJc2dlX2J5
dGVzID0gc2dlX3N6ICogbnVtX2NudDsKCgkJZnJhbWVfY291bnQgPSAoc2dlX2J5dGVzIC8gTUVH
QU1GSV9GUkFNRV9TSVpFKSArCgkJICAgICgoc2dlX2J5dGVzICUgTUVHQU1GSV9GUkFNRV9TSVpF
KSA/IDEgOiAwKSA7Cgl9CgkvKiBNYWluIGZyYW1lICovCglmcmFtZV9jb3VudCArPTE7CgoJaWYg
KGZyYW1lX2NvdW50ID4gNykKCQlmcmFtZV9jb3VudCA9IDg7CglyZXR1cm4gZnJhbWVfY291bnQ7
Cn0KCi8qKgogKiBtZWdhc2FzX2J1aWxkX2RjZGIgLQlQcmVwYXJlcyBhIGRpcmVjdCBjZGIgKERD
REIpIGNvbW1hbmQKICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqIEBzY3A6CQlT
Q1NJIGNvbW1hbmQKICogQGNtZDoJCUNvbW1hbmQgdG8gYmUgcHJlcGFyZWQgaW4KICoKICogVGhp
cyBmdW5jdGlvbiBwcmVwYXJlcyBDREIgY29tbWFuZHMuIFRoZXNlIGFyZSB0eXBjaWFsbHkgcGFz
cy10aHJvdWdoCiAqIGNvbW1hbmRzIHRvIHRoZSBkZXZpY2VzLgogKi8Kc3RhdGljIGludAptZWdh
c2FzX2J1aWxkX2RjZGIoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3Qg
c2NzaV9jbW5kICpzY3AsCgkJICAgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpCnsKCXUzMiBpc19s
b2dpY2FsOwoJdTMyIGRldmljZV9pZDsKCXUxNiBmbGFncyA9IDA7CglzdHJ1Y3QgbWVnYXNhc19w
dGhydV9mcmFtZSAqcHRocnU7CgoJaXNfbG9naWNhbCA9IE1FR0FTQVNfSVNfTE9HSUNBTChzY3Ap
OwoJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsIHNjcCk7CglwdGhydSA9
IChzdHJ1Y3QgbWVnYXNhc19wdGhydV9mcmFtZSAqKWNtZC0+ZnJhbWU7CgoJaWYgKHNjcC0+c2Nf
ZGF0YV9kaXJlY3Rpb24gPT0gUENJX0RNQV9UT0RFVklDRSkKCQlmbGFncyA9IE1GSV9GUkFNRV9E
SVJfV1JJVEU7CgllbHNlIGlmIChzY3AtPnNjX2RhdGFfZGlyZWN0aW9uID09IFBDSV9ETUFfRlJP
TURFVklDRSkKCQlmbGFncyA9IE1GSV9GUkFNRV9ESVJfUkVBRDsKCWVsc2UgaWYgKHNjcC0+c2Nf
ZGF0YV9kaXJlY3Rpb24gPT0gUENJX0RNQV9OT05FKQoJCWZsYWdzID0gTUZJX0ZSQU1FX0RJUl9O
T05FOwoKCWlmIChpbnN0YW5jZS0+ZmxhZ19pZWVlID09IDEpIHsKCQlmbGFncyB8PSBNRklfRlJB
TUVfSUVFRTsKCX0KCgkvKgoJICogUHJlcGFyZSB0aGUgRENEQiBmcmFtZQoJICovCglwdGhydS0+
Y21kID0gKGlzX2xvZ2ljYWwpID8gTUZJX0NNRF9MRF9TQ1NJX0lPIDogTUZJX0NNRF9QRF9TQ1NJ
X0lPOwoJcHRocnUtPmNtZF9zdGF0dXMgPSAweDA7CglwdGhydS0+c2NzaV9zdGF0dXMgPSAweDA7
CglwdGhydS0+dGFyZ2V0X2lkID0gZGV2aWNlX2lkOwoJcHRocnUtPmx1biA9IHNjcC0+ZGV2aWNl
LT5sdW47CglwdGhydS0+Y2RiX2xlbiA9IHNjcC0+Y21kX2xlbjsKCXB0aHJ1LT50aW1lb3V0ID0g
MDsKCXB0aHJ1LT5wYWRfMCA9IDA7CglwdGhydS0+ZmxhZ3MgPSBmbGFnczsKCXB0aHJ1LT5kYXRh
X3hmZXJfbGVuID0gc2NzaV9idWZmbGVuKHNjcCk7CgoJbWVtY3B5KHB0aHJ1LT5jZGIsIHNjcC0+
Y21uZCwgc2NwLT5jbWRfbGVuKTsKCgkvKgoJKiBJZiB0aGUgY29tbWFuZCBpcyBmb3IgdGhlIHRh
cGUgZGV2aWNlLCBzZXQgdGhlCgkqIHB0aHJ1IHRpbWVvdXQgdG8gdGhlIG9zIGxheWVyIHRpbWVv
dXQgdmFsdWUuCgkqLwoJaWYgKHNjcC0+ZGV2aWNlLT50eXBlID09IFRZUEVfVEFQRSkgewoJCWlm
ICgoc2NwLT5yZXF1ZXN0LT50aW1lb3V0IC8gSFopID4gMHhGRkZGKQoJCQlwdGhydS0+dGltZW91
dCA9IDB4RkZGRjsKCQllbHNlCgkJCXB0aHJ1LT50aW1lb3V0ID0gc2NwLT5yZXF1ZXN0LT50aW1l
b3V0IC8gSFo7Cgl9CgoJLyoKCSAqIENvbnN0cnVjdCBTR0wKCSAqLwoJaWYgKGluc3RhbmNlLT5m
bGFnX2llZWUgPT0gMSkgewoJCXB0aHJ1LT5mbGFncyB8PSBNRklfRlJBTUVfU0dMNjQ7CgkJcHRo
cnUtPnNnZV9jb3VudCA9IG1lZ2FzYXNfbWFrZV9zZ2xfc2tpbm55KGluc3RhbmNlLCBzY3AsCgkJ
CQkJCSAgICAgICZwdGhydS0+c2dsKTsKCX0gZWxzZSBpZiAoSVNfRE1BNjQpIHsKCQlwdGhydS0+
ZmxhZ3MgfD0gTUZJX0ZSQU1FX1NHTDY0OwoJCXB0aHJ1LT5zZ2VfY291bnQgPSBtZWdhc2FzX21h
a2Vfc2dsNjQoaW5zdGFuY2UsIHNjcCwKCQkJCQkJICAgICAgJnB0aHJ1LT5zZ2wpOwoJfSBlbHNl
CgkJcHRocnUtPnNnZV9jb3VudCA9IG1lZ2FzYXNfbWFrZV9zZ2wzMihpbnN0YW5jZSwgc2NwLAoJ
CQkJCQkgICAgICAmcHRocnUtPnNnbCk7CgoJaWYgKHB0aHJ1LT5zZ2VfY291bnQgPiBpbnN0YW5j
ZS0+bWF4X251bV9zZ2UpIHsKCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IERDREIgdHdvIG1h
bnkgU0dFIE5VTT0leFxuIiwKCQkJcHRocnUtPnNnZV9jb3VudCk7CgkJcmV0dXJuIDA7Cgl9CgoJ
LyoKCSAqIFNlbnNlIGluZm8gc3BlY2lmaWMKCSAqLwoJcHRocnUtPnNlbnNlX2xlbiA9IFNDU0lf
U0VOU0VfQlVGRkVSU0laRTsKCXB0aHJ1LT5zZW5zZV9idWZfcGh5c19hZGRyX2hpID0gMDsKCXB0
aHJ1LT5zZW5zZV9idWZfcGh5c19hZGRyX2xvID0gY21kLT5zZW5zZV9waHlzX2FkZHI7CgoJLyoK
CSAqIENvbXB1dGUgdGhlIHRvdGFsIG51bWJlciBvZiBmcmFtZXMgdGhpcyBjb21tYW5kIGNvbnN1
bWVzLiBGVyB1c2VzCgkgKiB0aGlzIG51bWJlciB0byBwdWxsIHN1ZmZpY2llbnQgbnVtYmVyIG9m
IGZyYW1lcyBmcm9tIGhvc3QgbWVtb3J5LgoJICovCgljbWQtPmZyYW1lX2NvdW50ID0gbWVnYXNh
c19nZXRfZnJhbWVfY291bnQoaW5zdGFuY2UsIHB0aHJ1LT5zZ2VfY291bnQsCgkJCQkJCQlQVEhS
VV9GUkFNRSk7CgoJcmV0dXJuIGNtZC0+ZnJhbWVfY291bnQ7Cn0KCi8qKgogKiBtZWdhc2FzX2J1
aWxkX2xkaW8gLQlQcmVwYXJlcyBJT3MgdG8gbG9naWNhbCBkZXZpY2VzCiAqIEBpbnN0YW5jZToJ
CUFkYXB0ZXIgc29mdCBzdGF0ZQogKiBAc2NwOgkJU0NTSSBjb21tYW5kCiAqIEBjbWQ6CQlDb21t
YW5kIHRvIGJlIHByZXBhcmVkCiAqCiAqIEZyYW1lcyAoYW5kIGFjY29tcGFueWluZyBTR0xzKSBm
b3IgcmVndWxhciBTQ1NJIElPcyB1c2UgdGhpcyBmdW5jdGlvbi4KICovCnN0YXRpYyBpbnQKbWVn
YXNhc19idWlsZF9sZGlvKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0
IHNjc2lfY21uZCAqc2NwLAoJCSAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKQp7Cgl1MzIgZGV2
aWNlX2lkOwoJdTggc2MgPSBzY3AtPmNtbmRbMF07Cgl1MTYgZmxhZ3MgPSAwOwoJc3RydWN0IG1l
Z2FzYXNfaW9fZnJhbWUgKmxkaW87CgoJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5z
dGFuY2UsIHNjcCk7CglsZGlvID0gKHN0cnVjdCBtZWdhc2FzX2lvX2ZyYW1lICopY21kLT5mcmFt
ZTsKCglpZiAoc2NwLT5zY19kYXRhX2RpcmVjdGlvbiA9PSBQQ0lfRE1BX1RPREVWSUNFKQoJCWZs
YWdzID0gTUZJX0ZSQU1FX0RJUl9XUklURTsKCWVsc2UgaWYgKHNjcC0+c2NfZGF0YV9kaXJlY3Rp
b24gPT0gUENJX0RNQV9GUk9NREVWSUNFKQoJCWZsYWdzID0gTUZJX0ZSQU1FX0RJUl9SRUFEOwoK
CWlmIChpbnN0YW5jZS0+ZmxhZ19pZWVlID09IDEpIHsKCQlmbGFncyB8PSBNRklfRlJBTUVfSUVF
RTsKCX0KCgkvKgoJICogUHJlcGFyZSB0aGUgTG9naWNhbCBJTyBmcmFtZTogMm5kIGJpdCBpcyB6
ZXJvIGZvciBhbGwgcmVhZCBjbWRzCgkgKi8KCWxkaW8tPmNtZCA9IChzYyAmIDB4MDIpID8gTUZJ
X0NNRF9MRF9XUklURSA6IE1GSV9DTURfTERfUkVBRDsKCWxkaW8tPmNtZF9zdGF0dXMgPSAweDA7
CglsZGlvLT5zY3NpX3N0YXR1cyA9IDB4MDsKCWxkaW8tPnRhcmdldF9pZCA9IGRldmljZV9pZDsK
CWxkaW8tPnRpbWVvdXQgPSAwOwoJbGRpby0+cmVzZXJ2ZWRfMCA9IDA7CglsZGlvLT5wYWRfMCA9
IDA7CglsZGlvLT5mbGFncyA9IGZsYWdzOwoJbGRpby0+c3RhcnRfbGJhX2hpID0gMDsKCWxkaW8t
PmFjY2Vzc19ieXRlID0gKHNjcC0+Y21kX2xlbiAhPSA2KSA/IHNjcC0+Y21uZFsxXSA6IDA7CgoJ
LyoKCSAqIDYtYnl0ZSBSRUFEKDB4MDgpIG9yIFdSSVRFKDB4MEEpIGNkYgoJICovCglpZiAoc2Nw
LT5jbWRfbGVuID09IDYpIHsKCQlsZGlvLT5sYmFfY291bnQgPSAodTMyKSBzY3AtPmNtbmRbNF07
CgkJbGRpby0+c3RhcnRfbGJhX2xvID0gKCh1MzIpIHNjcC0+Y21uZFsxXSA8PCAxNikgfAoJCSAg
ICAoKHUzMikgc2NwLT5jbW5kWzJdIDw8IDgpIHwgKHUzMikgc2NwLT5jbW5kWzNdOwoKCQlsZGlv
LT5zdGFydF9sYmFfbG8gJj0gMHgxRkZGRkY7Cgl9CgoJLyoKCSAqIDEwLWJ5dGUgUkVBRCgweDI4
KSBvciBXUklURSgweDJBKSBjZGIKCSAqLwoJZWxzZSBpZiAoc2NwLT5jbWRfbGVuID09IDEwKSB7
CgkJbGRpby0+bGJhX2NvdW50ID0gKHUzMikgc2NwLT5jbW5kWzhdIHwKCQkgICAgKCh1MzIpIHNj
cC0+Y21uZFs3XSA8PCA4KTsKCQlsZGlvLT5zdGFydF9sYmFfbG8gPSAoKHUzMikgc2NwLT5jbW5k
WzJdIDw8IDI0KSB8CgkJICAgICgodTMyKSBzY3AtPmNtbmRbM10gPDwgMTYpIHwKCQkgICAgKCh1
MzIpIHNjcC0+Y21uZFs0XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs1XTsKCX0KCgkvKgoJICog
MTItYnl0ZSBSRUFEKDB4QTgpIG9yIFdSSVRFKDB4QUEpIGNkYgoJICovCgllbHNlIGlmIChzY3At
PmNtZF9sZW4gPT0gMTIpIHsKCQlsZGlvLT5sYmFfY291bnQgPSAoKHUzMikgc2NwLT5jbW5kWzZd
IDw8IDI0KSB8CgkJICAgICgodTMyKSBzY3AtPmNtbmRbN10gPDwgMTYpIHwKCQkgICAgKCh1MzIp
IHNjcC0+Y21uZFs4XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs5XTsKCgkJbGRpby0+c3RhcnRf
bGJhX2xvID0gKCh1MzIpIHNjcC0+Y21uZFsyXSA8PCAyNCkgfAoJCSAgICAoKHUzMikgc2NwLT5j
bW5kWzNdIDw8IDE2KSB8CgkJICAgICgodTMyKSBzY3AtPmNtbmRbNF0gPDwgOCkgfCAodTMyKSBz
Y3AtPmNtbmRbNV07Cgl9CgoJLyoKCSAqIDE2LWJ5dGUgUkVBRCgweDg4KSBvciBXUklURSgweDhB
KSBjZGIKCSAqLwoJZWxzZSBpZiAoc2NwLT5jbWRfbGVuID09IDE2KSB7CgkJbGRpby0+bGJhX2Nv
dW50ID0gKCh1MzIpIHNjcC0+Y21uZFsxMF0gPDwgMjQpIHwKCQkgICAgKCh1MzIpIHNjcC0+Y21u
ZFsxMV0gPDwgMTYpIHwKCQkgICAgKCh1MzIpIHNjcC0+Y21uZFsxMl0gPDwgOCkgfCAodTMyKSBz
Y3AtPmNtbmRbMTNdOwoKCQlsZGlvLT5zdGFydF9sYmFfbG8gPSAoKHUzMikgc2NwLT5jbW5kWzZd
IDw8IDI0KSB8CgkJICAgICgodTMyKSBzY3AtPmNtbmRbN10gPDwgMTYpIHwKCQkgICAgKCh1MzIp
IHNjcC0+Y21uZFs4XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs5XTsKCgkJbGRpby0+c3RhcnRf
bGJhX2hpID0gKCh1MzIpIHNjcC0+Y21uZFsyXSA8PCAyNCkgfAoJCSAgICAoKHUzMikgc2NwLT5j
bW5kWzNdIDw8IDE2KSB8CgkJICAgICgodTMyKSBzY3AtPmNtbmRbNF0gPDwgOCkgfCAodTMyKSBz
Y3AtPmNtbmRbNV07CgoJfQoKCS8qCgkgKiBDb25zdHJ1Y3QgU0dMCgkgKi8KCWlmIChpbnN0YW5j
ZS0+ZmxhZ19pZWVlKSB7CgkJbGRpby0+ZmxhZ3MgfD0gTUZJX0ZSQU1FX1NHTDY0OwoJCWxkaW8t
PnNnZV9jb3VudCA9IG1lZ2FzYXNfbWFrZV9zZ2xfc2tpbm55KGluc3RhbmNlLCBzY3AsCgkJCQkJ
ICAgICAgJmxkaW8tPnNnbCk7Cgl9IGVsc2UgaWYgKElTX0RNQTY0KSB7CgkJbGRpby0+ZmxhZ3Mg
fD0gTUZJX0ZSQU1FX1NHTDY0OwoJCWxkaW8tPnNnZV9jb3VudCA9IG1lZ2FzYXNfbWFrZV9zZ2w2
NChpbnN0YW5jZSwgc2NwLCAmbGRpby0+c2dsKTsKCX0gZWxzZQoJCWxkaW8tPnNnZV9jb3VudCA9
IG1lZ2FzYXNfbWFrZV9zZ2wzMihpbnN0YW5jZSwgc2NwLCAmbGRpby0+c2dsKTsKCglpZiAobGRp
by0+c2dlX2NvdW50ID4gaW5zdGFuY2UtPm1heF9udW1fc2dlKSB7CgkJcHJpbnRrKEtFUk5fRVJS
ICJtZWdhc2FzOiBidWlsZF9sZF9pbzogc2dlX2NvdW50ID0gJXhcbiIsCgkJCWxkaW8tPnNnZV9j
b3VudCk7CgkJcmV0dXJuIDA7Cgl9CgoJLyoKCSAqIFNlbnNlIGluZm8gc3BlY2lmaWMKCSAqLwoJ
bGRpby0+c2Vuc2VfbGVuID0gU0NTSV9TRU5TRV9CVUZGRVJTSVpFOwoJbGRpby0+c2Vuc2VfYnVm
X3BoeXNfYWRkcl9oaSA9IDA7CglsZGlvLT5zZW5zZV9idWZfcGh5c19hZGRyX2xvID0gY21kLT5z
ZW5zZV9waHlzX2FkZHI7CgoJLyoKCSAqIENvbXB1dGUgdGhlIHRvdGFsIG51bWJlciBvZiBmcmFt
ZXMgdGhpcyBjb21tYW5kIGNvbnN1bWVzLiBGVyB1c2VzCgkgKiB0aGlzIG51bWJlciB0byBwdWxs
IHN1ZmZpY2llbnQgbnVtYmVyIG9mIGZyYW1lcyBmcm9tIGhvc3QgbWVtb3J5LgoJICovCgljbWQt
PmZyYW1lX2NvdW50ID0gbWVnYXNhc19nZXRfZnJhbWVfY291bnQoaW5zdGFuY2UsCgkJCWxkaW8t
PnNnZV9jb3VudCwgSU9fRlJBTUUpOwoKCXJldHVybiBjbWQtPmZyYW1lX2NvdW50Owp9CgovKioK
ICogbWVnYXNhc19pc19sZGlvIC0JCUNoZWNrcyBpZiB0aGUgY21kIGlzIGZvciBsb2dpY2FsIGRy
aXZlCiAqIEBzY21kOgkJCVNDU0kgY29tbWFuZAogKgkKICogQ2FsbGVkIGJ5IG1lZ2FzYXNfcXVl
dWVfY29tbWFuZCB0byBmaW5kIG91dCBpZiB0aGUgY29tbWFuZCB0byBiZSBxdWV1ZWQKICogaXMg
YSBsb2dpY2FsIGRyaXZlIGNvbW1hbmQJCiAqLwpzdGF0aWMgaW5saW5lIGludCBtZWdhc2FzX2lz
X2xkaW8oc3RydWN0IHNjc2lfY21uZCAqY21kKQp7CglpZiAoIU1FR0FTQVNfSVNfTE9HSUNBTChj
bWQpKQoJCXJldHVybiAwOwoJc3dpdGNoIChjbWQtPmNtbmRbMF0pIHsKCWNhc2UgUkVBRF8xMDoK
CWNhc2UgV1JJVEVfMTA6CgljYXNlIFJFQURfMTI6CgljYXNlIFdSSVRFXzEyOgoJY2FzZSBSRUFE
XzY6CgljYXNlIFdSSVRFXzY6CgljYXNlIFJFQURfMTY6CgljYXNlIFdSSVRFXzE2OgoJCXJldHVy
biAxOwoJZGVmYXVsdDoKCQlyZXR1cm4gMDsKCX0KfQoKIC8qKgogKiBtZWdhc2FzX2R1bXBfcGVu
ZGluZ19mcmFtZXMgLQlEdW1wcyB0aGUgZnJhbWUgYWRkcmVzcyBvZiBhbGwgcGVuZGluZyBjbWRz
CiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCWluIEZXCiAqIEBpbnN0YW5jZToJCQkJ
QWRhcHRlciBzb2Z0IHN0YXRlCiAqLwpzdGF0aWMgaW5saW5lIHZvaWQKbWVnYXNhc19kdW1wX3Bl
bmRpbmdfZnJhbWVzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKewoJc3RydWN0
IG1lZ2FzYXNfY21kICpjbWQ7CglpbnQgaSxuOwoJdW5pb24gbWVnYXNhc19zZ2wgKm1maV9zZ2w7
CglzdHJ1Y3QgbWVnYXNhc19pb19mcmFtZSAqbGRpbzsKCXN0cnVjdCBtZWdhc2FzX3B0aHJ1X2Zy
YW1lICpwdGhydTsKCXUzMiBzZ2NvdW50OwoJdTMyIG1heF9jbWQgPSBpbnN0YW5jZS0+bWF4X2Z3
X2NtZHM7CgoJcHJpbnRrKEtFUk5fRVJSICJcbm1lZ2FzYXNbJWRdOiBEdW1waW5nIEZyYW1lIFBo
eXMgQWRkcmVzcyBvZiBhbGwgcGVuZGluZyBjbWRzIGluIEZXXG4iLGluc3RhbmNlLT5ob3N0LT5o
b3N0X25vKTsKCXByaW50ayhLRVJOX0VSUiAibWVnYXNhc1slZF06IFRvdGFsIE9TIFBlbmRpbmcg
Y21kcyA6ICVkXG4iLGluc3RhbmNlLT5ob3N0LT5ob3N0X25vLGF0b21pY19yZWFkKCZpbnN0YW5j
ZS0+Zndfb3V0c3RhbmRpbmcpKTsKCWlmIChJU19ETUE2NCkKCQlwcmludGsoS0VSTl9FUlIgIlxu
bWVnYXNhc1slZF06IDY0IGJpdCBTR0xzIHdlcmUgc2VudCB0byBGV1xuIixpbnN0YW5jZS0+aG9z
dC0+aG9zdF9ubyk7CgllbHNlCgkJcHJpbnRrKEtFUk5fRVJSICJcbm1lZ2FzYXNbJWRdOiAzMiBi
aXQgU0dMcyB3ZXJlIHNlbnQgdG8gRldcbiIsaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOwoKCXBy
aW50ayhLRVJOX0VSUiAibWVnYXNhc1slZF06IFBlbmRpbmcgT1MgY21kcyBpbiBGVyA6IFxuIixp
bnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7Cglmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsrKSB7
CgkJY21kID0gaW5zdGFuY2UtPmNtZF9saXN0W2ldOwoJCWlmKCFjbWQtPnNjbWQpCgkJCWNvbnRp
bnVlOwoJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhc1slZF06IEZyYW1lIGFkZHIgOjB4JTA4bHgg
OiAiLGluc3RhbmNlLT5ob3N0LT5ob3N0X25vLCh1bnNpZ25lZCBsb25nKWNtZC0+ZnJhbWVfcGh5
c19hZGRyKTsKCQlpZiAobWVnYXNhc19pc19sZGlvKGNtZC0+c2NtZCkpewoJCQlsZGlvID0gKHN0
cnVjdCBtZWdhc2FzX2lvX2ZyYW1lICopY21kLT5mcmFtZTsKCQkJbWZpX3NnbCA9ICZsZGlvLT5z
Z2w7CgkJCXNnY291bnQgPSBsZGlvLT5zZ2VfY291bnQ7CgkJCXByaW50ayhLRVJOX0VSUiAibWVn
YXNhc1slZF06IGZyYW1lIGNvdW50IDogMHgleCwgQ21kIDogMHgleCwgVGd0IGlkIDogMHgleCwg
bGJhIGxvIDogMHgleCwgbGJhX2hpIDogMHgleCwgc2Vuc2VfYnVmIGFkZHIgOiAweCV4LHNnZSBj
b3VudCA6IDB4JXhcbiIsaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8sIGNtZC0+ZnJhbWVfY291bnQs
bGRpby0+Y21kLGxkaW8tPnRhcmdldF9pZCwgbGRpby0+c3RhcnRfbGJhX2xvLGxkaW8tPnN0YXJ0
X2xiYV9oaSxsZGlvLT5zZW5zZV9idWZfcGh5c19hZGRyX2xvLHNnY291bnQpOwoJCX0KCQllbHNl
IHsKCQkJcHRocnUgPSAoc3RydWN0IG1lZ2FzYXNfcHRocnVfZnJhbWUgKikgY21kLT5mcmFtZTsK
CQkJbWZpX3NnbCA9ICZwdGhydS0+c2dsOwoJCQlzZ2NvdW50ID0gcHRocnUtPnNnZV9jb3VudDsK
CQkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzWyVkXTogZnJhbWUgY291bnQgOiAweCV4LCBDbWQg
OiAweCV4LCBUZ3QgaWQgOiAweCV4LCBsdW4gOiAweCV4LCBjZGJfbGVuIDogMHgleCwgZGF0YSB4
ZmVyIGxlbiA6IDB4JXgsIHNlbnNlX2J1ZiBhZGRyIDogMHgleCxzZ2UgY291bnQgOiAweCV4XG4i
LGluc3RhbmNlLT5ob3N0LT5ob3N0X25vLGNtZC0+ZnJhbWVfY291bnQscHRocnUtPmNtZCxwdGhy
dS0+dGFyZ2V0X2lkLHB0aHJ1LT5sdW4scHRocnUtPmNkYl9sZW4gLCBwdGhydS0+ZGF0YV94ZmVy
X2xlbixwdGhydS0+c2Vuc2VfYnVmX3BoeXNfYWRkcl9sbyxzZ2NvdW50KTsKCQl9CglpZihtZWdh
c2FzX2RiZ19sdmwgJiBNRUdBU0FTX0RCR19MVkwpewoJCWZvciAobiA9IDA7IG4gPCBzZ2NvdW50
OyBuKyspewoJCQlpZiAoSVNfRE1BNjQpCgkJCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IHNn
bCBsZW4gOiAweCV4LCBzZ2wgYWRkciA6IDB4JTA4bHggIixtZmlfc2dsLT5zZ2U2NFtuXS5sZW5n
dGggLCAodW5zaWduZWQgbG9uZyltZmlfc2dsLT5zZ2U2NFtuXS5waHlzX2FkZHIpIDsKCQkJZWxz
ZQoJCQkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBzZ2wgbGVuIDogMHgleCwgc2dsIGFkZHIg
OiAweCV4ICIsbWZpX3NnbC0+c2dlMzJbbl0ubGVuZ3RoICwgbWZpX3NnbC0+c2dlMzJbbl0ucGh5
c19hZGRyKSA7CgkJCX0KCQl9CgkJcHJpbnRrKEtFUk5fRVJSICJcbiIpOwoJfSAvKmZvciBtYXhf
Y21kKi8KCXByaW50ayhLRVJOX0VSUiAiXG5tZWdhc2FzWyVkXTogUGVuZGluZyBJbnRlcm5hbCBj
bWRzIGluIEZXIDogXG4iLGluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKCWZvciAoaSA9IDA7IGkg
PCBtYXhfY21kOyBpKyspIHsKCgkJY21kID0gaW5zdGFuY2UtPmNtZF9saXN0W2ldOwoKCQlpZihj
bWQtPnN5bmNfY21kID09IDEpewoJCQlwcmludGsoS0VSTl9FUlIgIjB4JTA4bHggOiAiLCAodW5z
aWduZWQgbG9uZyljbWQtPmZyYW1lX3BoeXNfYWRkcik7CgkJfQoJfQoJcHJpbnRrKEtFUk5fRVJS
ICJtZWdhc2FzWyVkXTogRHVtcGluZyBEb25lLlxuXG4iLGluc3RhbmNlLT5ob3N0LT5ob3N0X25v
KTsKfQoKLyoqCiAqIG1lZ2FzYXNfcXVldWVfY29tbWFuZCAtCVF1ZXVlIGVudHJ5IHBvaW50CiAq
IEBzY21kOgkJCVNDU0kgY29tbWFuZCB0byBiZSBxdWV1ZWQKICogQGRvbmU6CQkJQ2FsbGJhY2sg
ZW50cnkgcG9pbnQKICovCnN0YXRpYyBpbnQKbWVnYXNhc19xdWV1ZV9jb21tYW5kKHN0cnVjdCBz
Y3NpX2NtbmQgKnNjbWQsIHZvaWQgKCpkb25lKSAoc3RydWN0IHNjc2lfY21uZCAqKSkKewoJdTMy
IGZyYW1lX2NvdW50OwoJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CglzdHJ1Y3QgbWVnYXNhc19p
bnN0YW5jZSAqaW5zdGFuY2U7Cgl1bnNpZ25lZCBsb25nIGZsYWdzOwoKCWluc3RhbmNlID0gKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICopCgkgICAgc2NtZC0+ZGV2aWNlLT5ob3N0LT5ob3N0ZGF0
YTsKCglpZiAoaW5zdGFuY2UtPmlzc3VlcGVuZF9kb25lID09IDApCgkJcmV0dXJuIFNDU0lfTUxR
VUVVRV9IT1NUX0JVU1k7CgoJc3Bpbl9sb2NrX2lycXNhdmUoJmluc3RhbmNlLT5oYmFfbG9jaywg
ZmxhZ3MpOwoJaWYgKGluc3RhbmNlLT5hZHByZWNvdmVyeSAhPSBNRUdBU0FTX0hCQV9PUEVSQVRJ
T05BTCkgewoJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxh
Z3MpOwoJCXJldHVybiBTQ1NJX01MUVVFVUVfSE9TVF9CVVNZOwoJfQoKCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoKCXNjbWQtPnNjc2lfZG9uZSA9
IGRvbmU7CglzY21kLT5yZXN1bHQgPSAwOwoKCWlmIChNRUdBU0FTX0lTX0xPR0lDQUwoc2NtZCkg
JiYKCSAgICAoc2NtZC0+ZGV2aWNlLT5pZCA+PSBNRUdBU0FTX01BWF9MRCB8fCBzY21kLT5kZXZp
Y2UtPmx1bikpIHsKCQlzY21kLT5yZXN1bHQgPSBESURfQkFEX1RBUkdFVCA8PCAxNjsKCQlnb3Rv
IG91dF9kb25lOwoJfQoKCXN3aXRjaCAoc2NtZC0+Y21uZFswXSkgewoJY2FzZSBTWU5DSFJPTkla
RV9DQUNIRToKCQkvKgoJCSAqIEZXIHRha2VzIGNhcmUgb2YgZmx1c2ggY2FjaGUgb24gaXRzIG93
bgoJCSAqIE5vIG5lZWQgdG8gc2VuZCBpdCBkb3duCgkJICovCgkJc2NtZC0+cmVzdWx0ID0gRElE
X09LIDw8IDE2OwoJCWdvdG8gb3V0X2RvbmU7CglkZWZhdWx0OgoJCWJyZWFrOwoJfQoKCWNtZCA9
IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CglpZiAoIWNtZCkKCQlyZXR1cm4gU0NTSV9NTFFV
RVVFX0hPU1RfQlVTWTsKCgkvKgoJICogTG9naWNhbCBkcml2ZSBjb21tYW5kCgkgKi8KCWlmICht
ZWdhc2FzX2lzX2xkaW8oc2NtZCkpCgkJZnJhbWVfY291bnQgPSBtZWdhc2FzX2J1aWxkX2xkaW8o
aW5zdGFuY2UsIHNjbWQsIGNtZCk7CgllbHNlCgkJZnJhbWVfY291bnQgPSBtZWdhc2FzX2J1aWxk
X2RjZGIoaW5zdGFuY2UsIHNjbWQsIGNtZCk7CgoJaWYgKCFmcmFtZV9jb3VudCkKCQlnb3RvIG91
dF9yZXR1cm5fY21kOwoKCWNtZC0+c2NtZCA9IHNjbWQ7CglzY21kLT5TQ3AucHRyID0gKGNoYXIg
KiljbWQ7CgoJLyoKCSAqIElzc3VlIHRoZSBjb21tYW5kIHRvIHRoZSBGVwoJICovCglhdG9taWNf
aW5jKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOwoKCWluc3RhbmNlLT5pbnN0YW5jZXQtPmZp
cmVfY21kKGluc3RhbmNlLCBjbWQtPmZyYW1lX3BoeXNfYWRkciwKCQkJCWNtZC0+ZnJhbWVfY291
bnQtMSwgaW5zdGFuY2UtPnJlZ19zZXQpOwoJLyoKCSAqIENoZWNrIGlmIHdlIGhhdmUgcGVuZCBj
bWRzIHRvIGJlIGNvbXBsZXRlZAoJICovCglpZiAocG9sbF9tb2RlX2lvICYmIGF0b21pY19yZWFk
KCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpKQoJCXRhc2tsZXRfc2NoZWR1bGUoJmluc3RhbmNl
LT5pc3JfdGFza2xldCk7CgoKCXJldHVybiAwOwoKIG91dF9yZXR1cm5fY21kOgoJbWVnYXNhc19y
ZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwogb3V0X2RvbmU6Cglkb25lKHNjbWQpOwoJcmV0dXJu
IDA7Cn0KCnN0YXRpYyBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqbWVnYXNhc19sb29rdXBfaW5z
dGFuY2UodTE2IGhvc3Rfbm8pCnsKCWludCBpOwoKCWZvciAoaSA9IDA7IGkgPCBtZWdhc2FzX21n
bXRfaW5mby5tYXhfaW5kZXg7IGkrKykgewoKCQlpZiAoKG1lZ2FzYXNfbWdtdF9pbmZvLmluc3Rh
bmNlW2ldKSAmJgoJCSAgICAobWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbaV0tPmhvc3QtPmhv
c3Rfbm8gPT0gaG9zdF9ubykpCgkJCXJldHVybiBtZWdhc2FzX21nbXRfaW5mby5pbnN0YW5jZVtp
XTsKCX0KCglyZXR1cm4gTlVMTDsKfQoKc3RhdGljIGludCBtZWdhc2FzX3NsYXZlX2NvbmZpZ3Vy
ZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCnsKCXUxNiAgICAgICAgICAgICBwZF9pbmRleCA9
IDA7CglzdHJ1Y3QgIG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlIDsKCglpbnN0YW5jZSA9IG1l
Z2FzYXNfbG9va3VwX2luc3RhbmNlKHNkZXYtPmhvc3QtPmhvc3Rfbm8pOwoKCS8qCgkqIERvbid0
IGV4cG9ydCBwaHlzaWNhbCBkaXNrIGRldmljZXMgdG8gdGhlIGRpc2sgZHJpdmVyLgoJKgoJKiBG
SVhNRTogQ3VycmVudGx5IHdlIGRvbid0IGV4cG9ydCB0aGVtIHRvIHRoZSBtaWRsYXllciBhdCBh
bGwuCgkqICAgICAgICBUaGF0IHdpbGwgYmUgZml4ZWQgb25jZSBMU0kgZW5naW5lZXJzIGhhdmUg
YXVkaXRlZCB0aGUKCSogICAgICAgIGZpcm13YXJlIGZvciBwb3NzaWJsZSBpc3N1ZXMuCgkqLwoJ
aWYgKHNkZXYtPmNoYW5uZWwgPCBNRUdBU0FTX01BWF9QRF9DSEFOTkVMUyAmJgoJCQkJc2Rldi0+
dHlwZSA9PSBUWVBFX0RJU0spIHsKCQlwZF9pbmRleCA9IChzZGV2LT5jaGFubmVsICogTUVHQVNB
U19NQVhfREVWX1BFUl9DSEFOTkVMKSArCgkJCQkJCQkJc2Rldi0+aWQ7CgkJaWYgKGluc3RhbmNl
LT5wZF9saXN0W3BkX2luZGV4XS5kcml2ZVN0YXRlID09CgkJCQkJCU1SX1BEX1NUQVRFX1NZU1RF
TSkgewoJCQlibGtfcXVldWVfcnFfdGltZW91dChzZGV2LT5yZXF1ZXN0X3F1ZXVlLAoJCQkJTUVH
QVNBU19ERUZBVUxUX0NNRF9USU1FT1VUICogSFopOwoJCQlyZXR1cm4gMDsKCQl9CgkJcmV0dXJu
IC1FTlhJTzsKCX0KCgkvKgoJKiBUaGUgUkFJRCBmaXJtd2FyZSBtYXkgcmVxdWlyZSBleHRlbmRl
ZCB0aW1lb3V0cy4KCSovCglibGtfcXVldWVfcnFfdGltZW91dChzZGV2LT5yZXF1ZXN0X3F1ZXVl
LAoJCU1FR0FTQVNfREVGQVVMVF9DTURfVElNRU9VVCAqIEhaKTsKCXJldHVybiAwOwp9CgpzdGF0
aWMgaW50IG1lZ2FzYXNfc2xhdmVfYWxsb2Moc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KQp7Cgl1
MTYgICAgICAgICAgICAgcGRfaW5kZXggPSAwOwoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlIDsKCWluc3RhbmNlID0gbWVnYXNhc19sb29rdXBfaW5zdGFuY2Uoc2Rldi0+aG9zdC0+
aG9zdF9ubyk7CglpZiAoKHNkZXYtPmNoYW5uZWwgPCBNRUdBU0FTX01BWF9QRF9DSEFOTkVMUykg
JiYKCQkJCShzZGV2LT50eXBlID09IFRZUEVfRElTSykpIHsKCQkvKgoJCSAqIE9wZW4gdGhlIE9T
IHNjYW4gdG8gdGhlIFNZU1RFTSBQRAoJCSAqLwoJCXBkX2luZGV4ID0KCQkJKHNkZXYtPmNoYW5u
ZWwgKiBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpICsKCQkJc2Rldi0+aWQ7CgkJaWYgKChp
bnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJpdmVTdGF0ZSA9PQoJCQkJCU1SX1BEX1NUQVRF
X1NZU1RFTSkgJiYKCQkJKGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5kcml2ZVR5cGUgPT0K
CQkJCQkJVFlQRV9ESVNLKSkgewoJCQlyZXR1cm4gMDsKCQl9CgkJcmV0dXJuIC1FTlhJTzsKCX0K
CXJldHVybiAwOwp9CgpzdGF0aWMgdm9pZCBtZWdhcmFpZF9zYXNfa2lsbF9oYmEoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQp7CglpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2Ug
PT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwKCQkoaW5zdGFuY2UtPnBkZXYt
PmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewoJCXdyaXRlbChN
RklfU1RPUF9BRFAsCgkJCSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFswXSk7Cgl9IGVs
c2UgewoJCXdyaXRlbChNRklfU1RPUF9BRFAsCgkJCSZpbnN0YW5jZS0+cmVnX3NldC0+aW5ib3Vu
ZF9kb29yYmVsbCk7Cgl9Cn0KCi8qKgogKiBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGMJIC0JUmV0
dXJucyBGVydzIGNvbnRyb2xsZXIgc3RydWN0dXJlCiAqIEBpbnN0YW5jZV9hZGRyOgkJCUFkZHJl
c3Mgb2YgYWRhcHRlciBzb2Z0IHN0YXRlCiAqCiAqIFRhc2tsZXQgdG8gY29tcGxldGUgY21kcwog
Ki8Kc3RhdGljIHZvaWQgbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjKHVuc2lnbmVkIGxvbmcgaW5z
dGFuY2VfYWRkcikKewoJdTMyIHByb2R1Y2VyOwoJdTMyIGNvbnN1bWVyOwoJdTMyIGNvbnRleHQ7
CglzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSA9CgkJCQkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKilpbnN0YW5jZV9hZGRyOwoJdW5z
aWduZWQgbG9uZyBmbGFnczsKCgkvKiBJZiB3ZSBoYXZlIGFscmVhZHkgZGVjbGFyZWQgYWRhcHRl
ciBkZWFkLCBkb25vdCBjb21wbGV0ZSBjbWRzICovCglpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5
ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1IgKQoJCXJldHVybjsKCglzcGluX2xvY2tfaXJx
c2F2ZSgmaW5zdGFuY2UtPmNvbXBsZXRpb25fbG9jaywgZmxhZ3MpOwoKCXByb2R1Y2VyID0gKmlu
c3RhbmNlLT5wcm9kdWNlcjsKCWNvbnN1bWVyID0gKmluc3RhbmNlLT5jb25zdW1lcjsKCgl3aGls
ZSAoY29uc3VtZXIgIT0gcHJvZHVjZXIpIHsKCQljb250ZXh0ID0gaW5zdGFuY2UtPnJlcGx5X3F1
ZXVlW2NvbnN1bWVyXTsKCQlpZiAoY29udGV4dCA+PSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHMpIHsK
CQkJcHJpbnRrKEtFUk5fRVJSICJVbmV4cGVjdGVkIGNvbnRleHQgdmFsdWUgJXhcbiIsCgkJCQlj
b250ZXh0KTsKCQkJQlVHKCk7CgkJfQoKCQljbWQgPSBpbnN0YW5jZS0+Y21kX2xpc3RbY29udGV4
dF07CgoJCW1lZ2FzYXNfY29tcGxldGVfY21kKGluc3RhbmNlLCBjbWQsIERJRF9PSyk7CgoJCWNv
bnN1bWVyKys7CgkJaWYgKGNvbnN1bWVyID09IChpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgKyAxKSkg
ewoJCQljb25zdW1lciA9IDA7CgkJfQoJfQoKCSppbnN0YW5jZS0+Y29uc3VtZXIgPSBwcm9kdWNl
cjsKCglzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+Y29tcGxldGlvbl9sb2NrLCBm
bGFncyk7CgoJLyoKCSAqIENoZWNrIGlmIHdlIGNhbiByZXN0b3JlIGNhbl9xdWV1ZQoJICovCglp
ZiAoaW5zdGFuY2UtPmZsYWcgJiBNRUdBU0FTX0ZXX0JVU1kKCQkmJiB0aW1lX2FmdGVyKGppZmZp
ZXMsIGluc3RhbmNlLT5sYXN0X3RpbWUgKyA1ICogSFopCgkJJiYgYXRvbWljX3JlYWQoJmluc3Rh
bmNlLT5md19vdXRzdGFuZGluZykgPCAxNykgewoKCQlzcGluX2xvY2tfaXJxc2F2ZShpbnN0YW5j
ZS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CgkJaW5zdGFuY2UtPmZsYWcgJj0gfk1FR0FTQVNf
RldfQlVTWTsKCQlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KCQkJUENJX0RFVklDRV9J
RF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwKCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KCQkJ
UENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKCQkJaW5zdGFuY2UtPmhvc3QtPmNh
bl9xdWV1ZSA9CgkJCQlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgLSBNRUdBU0FTX1NLSU5OWV9JTlRf
Q01EUzsKCQl9IGVsc2UKCQkJaW5zdGFuY2UtPmhvc3QtPmNhbl9xdWV1ZSA9CgkJCQlpbnN0YW5j
ZS0+bWF4X2Z3X2NtZHMgLSBNRUdBU0FTX0lOVF9DTURTOwoKCQlzcGluX3VubG9ja19pcnFyZXN0
b3JlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKCX0KfQoKc3RhdGljIHZvaWQK
bWVnYXNhc19pbnRlcm5hbF9yZXNldF9kZWZlcl9jbWRzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZSk7CgpzdGF0aWMgdm9pZApwcm9jZXNzX2Z3X3N0YXRlX2NoYW5nZV93cShzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwoKdm9pZCBtZWdhc2FzX2RvX29jcihzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpCnsKCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQ
Q0lfREVWSUNFX0lEX0xTSV9TQVMxMDY0UikgfHwKCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
IFBDSV9ERVZJQ0VfSURfREVMTF9QRVJDNSkgfHwKCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
IFBDSV9ERVZJQ0VfSURfTFNJX1ZFUkRFX1pDUikpIHsKCQkqaW5zdGFuY2UtPmNvbnN1bWVyICAg
ICA9IE1FR0FTQVNfQURQUkVTRVRfSU5QUk9HX1NJR047Cgl9CglpbnN0YW5jZS0+aW5zdGFuY2V0
LT5kaXNhYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOwoJaW5zdGFuY2UtPmFkcHJlY292ZXJ5
ICAgPSBNRUdBU0FTX0FEUFJFU0VUX1NNX0lORkFVTFQ7CglpbnN0YW5jZS0+aXNzdWVwZW5kX2Rv
bmUgPSAwOwoKCWF0b21pY19zZXQoJmluc3RhbmNlLT5md19vdXRzdGFuZGluZywgMCk7CgltZWdh
c2FzX2ludGVybmFsX3Jlc2V0X2RlZmVyX2NtZHMoaW5zdGFuY2UpOwoJcHJvY2Vzc19md19zdGF0
ZV9jaGFuZ2Vfd3EoJmluc3RhbmNlLT53b3JrX2luaXQpOwp9CgovKioKICogbWVnYXNhc193YWl0
X2Zvcl9vdXRzdGFuZGluZyAtCVdhaXQgZm9yIGFsbCBvdXRzdGFuZGluZyBjbWRzCiAqIEBpbnN0
YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqCiAqIFRoaXMgZnVuY3Rpb24gd2FpdHMgZm9y
IHVwdG8gTUVHQVNBU19SRVNFVF9XQUlUX1RJTUUgc2Vjb25kcyBmb3IgRlcgdG8KICogY29tcGxl
dGUgYWxsIGl0cyBvdXRzdGFuZGluZyBjb21tYW5kcy4gUmV0dXJucyBlcnJvciBpZiBvbmUgb3Ig
bW9yZSBJT3MKICogYXJlIHBlbmRpbmcgYWZ0ZXIgdGhpcyB0aW1lIHBlcmlvZC4gSXQgYWxzbyBt
YXJrcyB0aGUgY29udHJvbGxlciBkZWFkLgogKi8Kc3RhdGljIGludCBtZWdhc2FzX3dhaXRfZm9y
X291dHN0YW5kaW5nKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKewoJaW50IGk7
Cgl1MzIgcmVzZXRfaW5kZXg7Cgl1MzIgd2FpdF90aW1lID0gTUVHQVNBU19SRVNFVF9XQUlUX1RJ
TUU7Cgl1OCBhZHByZWNvdmVyeTsKCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CglzdHJ1Y3QgbGlzdF9o
ZWFkIGNsaXN0X2xvY2FsOwoJc3RydWN0IG1lZ2FzYXNfY21kICpyZXNldF9jbWQ7Cgl1MzIgZndf
c3RhdGU7Cgl1OCBraWxsX2FkYXB0ZXJfZmxhZzsKCglzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFu
Y2UtPmhiYV9sb2NrLCBmbGFncyk7CglhZHByZWNvdmVyeSA9IGluc3RhbmNlLT5hZHByZWNvdmVy
eTsKCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoK
CWlmIChhZHByZWNvdmVyeSAhPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTCkgewoKCQlJTklUX0xJ
U1RfSEVBRCgmY2xpc3RfbG9jYWwpOwoJCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJh
X2xvY2ssIGZsYWdzKTsKCQlsaXN0X3NwbGljZV9pbml0KCZpbnN0YW5jZS0+aW50ZXJuYWxfcmVz
ZXRfcGVuZGluZ19xLAoJCQkJJmNsaXN0X2xvY2FsKTsKCQlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKCgkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdh
c2FzOiBIQkEgcmVzZXQgd2FpdCAuLi5cbiIpOwoJCWZvciAoaSA9IDA7IGkgPCB3YWl0X3RpbWU7
IGkrKykgewoJCQltc2xlZXAoMTAwMCk7CgkJCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+
aGJhX2xvY2ssIGZsYWdzKTsKCQkJYWRwcmVjb3ZlcnkgPSBpbnN0YW5jZS0+YWRwcmVjb3Zlcnk7
CgkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoJ
CQlpZiAoYWRwcmVjb3ZlcnkgPT0gTUVHQVNBU19IQkFfT1BFUkFUSU9OQUwpCgkJCQlicmVhazsK
CQl9CgoJCWlmIChhZHByZWNvdmVyeSAhPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTCkgewoJCQlw
cmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FzYXM6IHJlc2V0OiBTdG9wcGluZyBIQkEuXG4iKTsKCQkJ
c3Bpbl9sb2NrX2lycXNhdmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoJCQlpbnN0YW5j
ZS0+YWRwcmVjb3ZlcnkJPSBNRUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SOwoJCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKCQkJcmV0dXJuIEZBSUxF
RDsKCQl9CgoJCXJlc2V0X2luZGV4CT0gMDsKCQl3aGlsZSAoIWxpc3RfZW1wdHkoJmNsaXN0X2xv
Y2FsKSkgewoJCQlyZXNldF9jbWQJPSBsaXN0X2VudHJ5KCgmY2xpc3RfbG9jYWwpLT5uZXh0LAoJ
CQkJCQlzdHJ1Y3QgbWVnYXNhc19jbWQsIGxpc3QpOwoJCQlsaXN0X2RlbF9pbml0KCZyZXNldF9j
bWQtPmxpc3QpOwoJCQlpZiAocmVzZXRfY21kLT5zY21kKSB7CgkJCQlyZXNldF9jbWQtPnNjbWQt
PnJlc3VsdCA9IERJRF9SRVNFVCA8PCAxNjsKCQkJCXByaW50ayhLRVJOX05PVElDRSAiJWQ6JXAg
cmVzZXQgWyUwMnhdLCAlI2x4XG4iLAoJCQkJCXJlc2V0X2luZGV4LCByZXNldF9jbWQsCgkJCQkJ
cmVzZXRfY21kLT5zY21kLT5jbW5kWzBdLAoJCQkJCXJlc2V0X2NtZC0+c2NtZC0+c2VyaWFsX251
bWJlcik7CgoJCQkJcmVzZXRfY21kLT5zY21kLT5zY3NpX2RvbmUocmVzZXRfY21kLT5zY21kKTsK
CQkJCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwgcmVzZXRfY21kKTsKCQkJfSBlbHNlIGlm
IChyZXNldF9jbWQtPnN5bmNfY21kKSB7CgkJCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FzYXM6
JXAgc3luY2ggY21kcyIKCQkJCQkJInJlc2V0IHF1ZXVlXG4iLAoJCQkJCQlyZXNldF9jbWQpOwoK
CQkJCXJlc2V0X2NtZC0+Y21kX3N0YXR1cyA9IEVOT0RBVEE7CgkJCQlpbnN0YW5jZS0+aW5zdGFu
Y2V0LT5maXJlX2NtZChpbnN0YW5jZSwKCQkJCQkJcmVzZXRfY21kLT5mcmFtZV9waHlzX2FkZHIs
CgkJCQkJCTAsIGluc3RhbmNlLT5yZWdfc2V0KTsKCQkJfSBlbHNlIHsKCQkJCXByaW50ayhLRVJO
X05PVElDRSAibWVnYXNhczogJXAgdW5leHBlY3RlZCIKCQkJCQkiY21kcyBsc3RcbiIsCgkJCQkJ
cmVzZXRfY21kKTsKCQkJfQoJCQlyZXNldF9pbmRleCsrOwoJCX0KCgkJcmV0dXJuIFNVQ0NFU1M7
Cgl9CgoJZm9yIChpID0gMDsgaSA8IHdhaXRfdGltZTsgaSsrKSB7CgoJCWludCBvdXRzdGFuZGlu
ZyA9IGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOwoKCQlpZiAoIW91dHN0
YW5kaW5nKQoJCQlicmVhazsKCgkJaWYgKCEoaSAlIE1FR0FTQVNfUkVTRVRfTk9USUNFX0lOVEVS
VkFMKSkgewoJCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FzYXM6IFslMmRdd2FpdGluZyBmb3Ig
JWQgIgoJCQkgICAgICAgImNvbW1hbmRzIHRvIGNvbXBsZXRlXG4iLGksb3V0c3RhbmRpbmcpOwoJ
CQkvKgoJCQkgKiBDYWxsIGNtZCBjb21wbGV0aW9uIHJvdXRpbmUuIENtZCB0byBiZQoJCQkgKiBi
ZSBjb21wbGV0ZWQgZGlyZWN0bHkgd2l0aG91dCBkZXBlbmRpbmcgb24gaXNyLgoJCQkgKi8KCQkJ
bWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjKCh1bnNpZ25lZCBsb25nKWluc3RhbmNlKTsKCQl9CgoJ
CW1zbGVlcCgxMDAwKTsKCX0KCglpID0gMDsKCWtpbGxfYWRhcHRlcl9mbGFnID0gMDsKCWRvIHsK
CQlmd19zdGF0ZSA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKCQkJ
CQlpbnN0YW5jZS0+cmVnX3NldCkgJiBNRklfU1RBVEVfTUFTSzsKCQlpZiAoKGZ3X3N0YXRlID09
IE1GSV9TVEFURV9GQVVMVCkgJiYKCQkJKGluc3RhbmNlLT5kaXNhYmxlT25saW5lQ3RybFJlc2V0
ID09IDApKSB7CgkJCWlmIChpID09IDMpIHsKCQkJCWtpbGxfYWRhcHRlcl9mbGFnID0gMjsKCQkJ
CWJyZWFrOwoJCQl9CgkJCW1lZ2FzYXNfZG9fb2NyKGluc3RhbmNlKTsKCQkJa2lsbF9hZGFwdGVy
X2ZsYWcgPSAxOwoKCQkJLyogd2FpdCBmb3IgMSBzZWNzIHRvIGxldCBGVyBmaW5pc2ggdGhlIHBl
bmRpbmcgY21kcyAqLwoJCQltc2xlZXAoMTAwMCk7CgkJfQoJCWkrKzsKCX0gd2hpbGUgKGkgPD0g
Myk7CgoJaWYgKGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpICYmCgkJCQkJ
IWtpbGxfYWRhcHRlcl9mbGFnKSB7CgkJaWYgKGluc3RhbmNlLT5kaXNhYmxlT25saW5lQ3RybFJl
c2V0ID09IDApIHsKCgkJCW1lZ2FzYXNfZG9fb2NyKGluc3RhbmNlKTsKCgkJCS8qIHdhaXQgZm9y
IDUgc2VjcyB0byBsZXQgRlcgZmluaXNoIHRoZSBwZW5kaW5nIGNtZHMgKi8KCQkJZm9yIChpID0g
MDsgaSA8IHdhaXRfdGltZTsgaSsrKSB7CgkJCQlpbnQgb3V0c3RhbmRpbmcgPQoJCQkJCWF0b21p
Y19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOwoJCQkJaWYgKCFvdXRzdGFuZGluZykK
CQkJCQlyZXR1cm4gU1VDQ0VTUzsKCQkJCW1zbGVlcCgxMDAwKTsKCQkJfQoJCX0KCX0KCglpZiAo
YXRvbWljX3JlYWQoJmluc3RhbmNlLT5md19vdXRzdGFuZGluZykgfHwKCQkJCQkoa2lsbF9hZGFw
dGVyX2ZsYWcgPT0gMikpIHsKCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FyYWlkX3NhczogcGVu
ZGluZyBjbWRzIGFmdGVyIHJlc2V0XG4iKTsKCQkvKgoJCSogU2VuZCBzaWduYWwgdG8gRlcgdG8g
c3RvcCBwcm9jZXNzaW5nIGFueSBwZW5kaW5nIGNtZHMuCgkJKiBUaGUgY29udHJvbGxlciB3aWxs
IGJlIHRha2VuIG9mZmxpbmUgYnkgdGhlIE9TIG5vdy4KCQkqLwoJCWlmICgoaW5zdGFuY2UtPnBk
ZXYtPmRldmljZSA9PQoJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5ZKSB8fAoJCQko
aW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQoJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJ
Tk5ZKSkgewoJCQl3cml0ZWwoTUZJX1NUT1BfQURQLAoJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5y
ZXNlcnZlZF8wWzBdKTsKCQl9IGVsc2UgewoJCQl3cml0ZWwoTUZJX1NUT1BfQURQLAoJCQkJJmlu
c3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKCQl9CgkJbWVnYXNhc19kdW1wX3Bl
bmRpbmdfZnJhbWVzKGluc3RhbmNlKTsKCQlzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmhi
YV9sb2NrLCBmbGFncyk7CgkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5CT0gTUVHQVNBU19IV19DUklU
SUNBTF9FUlJPUjsKCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+aGJhX2xvY2ss
IGZsYWdzKTsKCQlyZXR1cm4gRkFJTEVEOwoJfQoKCXByaW50ayhLRVJOX05PVElDRSAibWVnYXJh
aWRfc2FzOiBubyBwZW5kaW5nIGNtZHMgYWZ0ZXIgcmVzZXRcbiIpOwoKCXJldHVybiBTVUNDRVNT
Owp9CgovKioKICogbWVnYXNhc19nZW5lcmljX3Jlc2V0IC0JR2VuZXJpYyByZXNldCByb3V0aW5l
CiAqIEBzY21kOgkJCU1pZC1sYXllciBTQ1NJIGNvbW1hbmQKICoKICogVGhpcyByb3V0aW5lIGlt
cGxlbWVudHMgYSBnZW5lcmljIHJlc2V0IGhhbmRsZXIgZm9yIGRldmljZSwgYnVzIGFuZCBob3N0
CiAqIHJlc2V0IHJlcXVlc3RzLiBEZXZpY2UsIGJ1cyBhbmQgaG9zdCBzcGVjaWZpYyByZXNldCBo
YW5kbGVycyBjYW4gdXNlIHRoaXMKICogZnVuY3Rpb24gYWZ0ZXIgdGhleSBkbyB0aGVpciBzcGVj
aWZpYyB0YXNrcy4KICovCnN0YXRpYyBpbnQgbWVnYXNhc19nZW5lcmljX3Jlc2V0KHN0cnVjdCBz
Y3NpX2NtbmQgKnNjbWQpCnsKCWludCByZXRfdmFsOwoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlOwoKCWluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICopc2NtZC0+
ZGV2aWNlLT5ob3N0LT5ob3N0ZGF0YTsKCglzY21kX3ByaW50ayhLRVJOX05PVElDRSwgc2NtZCwg
Im1lZ2FzYXM6IFJFU0VUIC0lbGQgY21kPSV4IHJldHJpZXM9JXhcbiIsCgkJIHNjbWQtPnNlcmlh
bF9udW1iZXIsIHNjbWQtPmNtbmRbMF0sIHNjbWQtPnJldHJpZXMpOwoKCWlmIChpbnN0YW5jZS0+
YWRwcmVjb3ZlcnkgPT0gTUVHQVNBU19IV19DUklUSUNBTF9FUlJPUikgewoJCXByaW50ayhLRVJO
X0VSUiAibWVnYXNhczogY2Fubm90IHJlY292ZXIgZnJvbSBwcmV2aW91cyByZXNldCAiCgkJICAg
ICAgICJmYWlsdXJlc1xuIik7CgkJcmV0dXJuIEZBSUxFRDsKCX0KCglyZXRfdmFsID0gbWVnYXNh
c193YWl0X2Zvcl9vdXRzdGFuZGluZyhpbnN0YW5jZSk7CglpZiAocmV0X3ZhbCA9PSBTVUNDRVNT
KQoJCXByaW50ayhLRVJOX05PVElDRSAibWVnYXNhczogcmVzZXQgc3VjY2Vzc2Z1bCBcbiIpOwoJ
ZWxzZQoJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogZmFpbGVkIHRvIGRvIHJlc2V0XG4iKTsK
CglyZXR1cm4gcmV0X3ZhbDsKfQoKLyoqCiAqIG1lZ2FzYXNfcmVzZXRfdGltZXIgLSBxdWllc2Nl
IHRoZSBhZGFwdGVyIGlmIHJlcXVpcmVkCiAqIEBzY21kOgkJc2NzaSBjbW5kCiAqCiAqIFNldHMg
dGhlIEZXIGJ1c3kgZmxhZyBhbmQgcmVkdWNlcyB0aGUgaG9zdC0+Y2FuX3F1ZXVlIGlmIHRoZQog
KiBjbWQgaGFzIG5vdCBiZWVuIGNvbXBsZXRlZCB3aXRoaW4gdGhlIHRpbWVvdXQgcGVyaW9kLgog
Ki8Kc3RhdGljIGVudW0KYmxrX2VoX3RpbWVyX3JldHVybiBtZWdhc2FzX3Jlc2V0X3RpbWVyKHN0
cnVjdCBzY3NpX2NtbmQgKnNjbWQpCnsKCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kID0gKHN0cnVj
dCBtZWdhc2FzX2NtZCAqKXNjbWQtPlNDcC5wdHI7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2U7Cgl1bnNpZ25lZCBsb25nIGZsYWdzOwoKCWlmICh0aW1lX2FmdGVyKGppZmZpZXMs
IHNjbWQtPmppZmZpZXNfYXRfYWxsb2MgKwoJCQkJKE1FR0FTQVNfREVGQVVMVF9DTURfVElNRU9V
VCAqIDIpICogSFopKSB7CgkJcmV0dXJuIEJMS19FSF9OT1RfSEFORExFRDsKCX0KCglpbnN0YW5j
ZSA9IGNtZC0+aW5zdGFuY2U7CglpZiAoIShpbnN0YW5jZS0+ZmxhZyAmIE1FR0FTQVNfRldfQlVT
WSkpIHsKCQkvKiBGVyBpcyBidXN5LCB0aHJvdHRsZSBJTyAqLwoJCXNwaW5fbG9ja19pcnFzYXZl
KGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKCgkJaW5zdGFuY2UtPmhvc3QtPmNh
bl9xdWV1ZSA9IDE2OwoJCWluc3RhbmNlLT5sYXN0X3RpbWUgPSBqaWZmaWVzOwoJCWluc3RhbmNl
LT5mbGFnIHw9IE1FR0FTQVNfRldfQlVTWTsKCgkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpbnN0
YW5jZS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7Cgl9CglyZXR1cm4gQkxLX0VIX1JFU0VUX1RJ
TUVSOwp9CgovKioKICogbWVnYXNhc19yZXNldF9kZXZpY2UgLQlEZXZpY2UgcmVzZXQgaGFuZGxl
ciBlbnRyeSBwb2ludAogKi8Kc3RhdGljIGludCBtZWdhc2FzX3Jlc2V0X2RldmljZShzdHJ1Y3Qg
c2NzaV9jbW5kICpzY21kKQp7CglpbnQgcmV0OwoKCS8qCgkgKiBGaXJzdCB3YWl0IGZvciBhbGwg
Y29tbWFuZHMgdG8gY29tcGxldGUKCSAqLwoJcmV0ID0gbWVnYXNhc19nZW5lcmljX3Jlc2V0KHNj
bWQpOwoKCXJldHVybiByZXQ7Cn0KCi8qKgogKiBtZWdhc2FzX3Jlc2V0X2J1c19ob3N0IC0JQnVz
ICYgaG9zdCByZXNldCBoYW5kbGVyIGVudHJ5IHBvaW50CiAqLwpzdGF0aWMgaW50IG1lZ2FzYXNf
cmVzZXRfYnVzX2hvc3Qoc3RydWN0IHNjc2lfY21uZCAqc2NtZCkKewoJaW50IHJldDsKCgkvKgoJ
ICogRmlyc3Qgd2FpdCBmb3IgYWxsIGNvbW1hbmRzIHRvIGNvbXBsZXRlCgkgKi8KCXJldCA9IG1l
Z2FzYXNfZ2VuZXJpY19yZXNldChzY21kKTsKCglyZXR1cm4gcmV0Owp9CgovKioKICogbWVnYXNh
c19iaW9zX3BhcmFtIC0gUmV0dXJucyBkaXNrIGdlb21ldHJ5IGZvciBhIGRpc2sKICogQHNkZXY6
IAkJZGV2aWNlIGhhbmRsZQogKiBAYmRldjoJCWJsb2NrIGRldmljZQogKiBAY2FwYWNpdHk6CQlk
cml2ZSBjYXBhY2l0eQogKiBAZ2VvbToJCWdlb21ldHJ5IHBhcmFtZXRlcnMKICovCnN0YXRpYyBp
bnQKbWVnYXNhc19iaW9zX3BhcmFtKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldiwKCQkgc2VjdG9yX3QgY2FwYWNpdHksIGludCBnZW9tW10pCnsKCWlu
dCBoZWFkczsKCWludCBzZWN0b3JzOwoJc2VjdG9yX3QgY3lsaW5kZXJzOwoJdW5zaWduZWQgbG9u
ZyB0bXA7CgkvKiBEZWZhdWx0IGhlYWRzICg2NCkgJiBzZWN0b3JzICgzMikgKi8KCWhlYWRzID0g
NjQ7CglzZWN0b3JzID0gMzI7CgoJdG1wID0gaGVhZHMgKiBzZWN0b3JzOwoJY3lsaW5kZXJzID0g
Y2FwYWNpdHk7CgoJc2VjdG9yX2RpdihjeWxpbmRlcnMsIHRtcCk7CgoJLyoKCSAqIEhhbmRsZSBl
eHRlbmRlZCB0cmFuc2xhdGlvbiBzaXplIGZvciBsb2dpY2FsIGRyaXZlcyA+IDFHYgoJICovCgoJ
aWYgKGNhcGFjaXR5ID49IDB4MjAwMDAwKSB7CgkJaGVhZHMgPSAyNTU7CgkJc2VjdG9ycyA9IDYz
OwoJCXRtcCA9IGhlYWRzKnNlY3RvcnM7CgkJY3lsaW5kZXJzID0gY2FwYWNpdHk7CgkJc2VjdG9y
X2RpdihjeWxpbmRlcnMsIHRtcCk7Cgl9CgoJZ2VvbVswXSA9IGhlYWRzOwoJZ2VvbVsxXSA9IHNl
Y3RvcnM7CglnZW9tWzJdID0gY3lsaW5kZXJzOwoKCXJldHVybiAwOwp9CgpzdGF0aWMgdm9pZCBt
ZWdhc2FzX2Flbl9wb2xsaW5nKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CgovKioKICogbWVn
YXNhc19zZXJ2aWNlX2FlbiAtCVByb2Nlc3NlcyBhbiBldmVudCBub3RpZmljYXRpb24KICogQGlu
c3RhbmNlOgkJCUFkYXB0ZXIgc29mdCBzdGF0ZQogKiBAY21kOgkJCUFFTiBjb21tYW5kIGNvbXBs
ZXRlZCBieSB0aGUgSVNSCiAqCiAqIEZvciBBRU4sIGRyaXZlciBzZW5kcyBhIGNvbW1hbmQgZG93
biB0byBGVyB0aGF0IGlzIGhlbGQgYnkgdGhlIEZXIHRpbGwgYW4KICogZXZlbnQgb2NjdXJzLiBX
aGVuIGFuIGV2ZW50IG9mIGludGVyZXN0IG9jY3VycywgRlcgY29tcGxldGVzIHRoZSBjb21tYW5k
CiAqIHRoYXQgaXQgd2FzIHByZXZpb3VzbHkgaG9sZGluZy4KICoKICogVGhpcyByb3V0aW5lcyBz
ZW5kcyBTSUdJTyBzaWduYWwgdG8gcHJvY2Vzc2VzIHRoYXQgaGF2ZSByZWdpc3RlcmVkIHdpdGgg
dGhlCiAqIGRyaXZlciBmb3IgQUVOLgogKi8Kc3RhdGljIHZvaWQKbWVnYXNhc19zZXJ2aWNlX2Fl
bihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAq
Y21kKQp7Cgl1bnNpZ25lZCBsb25nIGZsYWdzOwoJLyoKCSAqIERvbid0IHNpZ25hbCBhcHAgaWYg
aXQgaXMganVzdCBhbiBhYm9ydGVkIHByZXZpb3VzbHkgcmVnaXN0ZXJlZCBhZW4KCSAqLwoJaWYg
KCghY21kLT5hYm9ydF9hZW4pICYmIChpbnN0YW5jZS0+dW5sb2FkID09IDApKSB7CgkJc3Bpbl9s
b2NrX2lycXNhdmUoJnBvbGxfYWVuX2xvY2ssIGZsYWdzKTsKCQltZWdhc2FzX3BvbGxfd2FpdF9h
ZW4gPSAxOwoJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBvbGxfYWVuX2xvY2ssIGZsYWdzKTsK
CQl3YWtlX3VwKCZtZWdhc2FzX3BvbGxfd2FpdCk7CgkJa2lsbF9mYXN5bmMoJm1lZ2FzYXNfYXN5
bmNfcXVldWUsIFNJR0lPLCBQT0xMX0lOKTsKCX0KCWVsc2UKCQljbWQtPmFib3J0X2FlbiA9IDA7
CgoJaW5zdGFuY2UtPmFlbl9jbWQgPSBOVUxMOwoJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNl
LCBjbWQpOwoKCWlmICgoaW5zdGFuY2UtPnVubG9hZCA9PSAwKSAmJgoJCSgoaW5zdGFuY2UtPmlz
c3VlcGVuZF9kb25lID09IDEpKSkgewoJCXN0cnVjdCBtZWdhc2FzX2Flbl9ldmVudCAqZXY7CgkJ
ZXYgPSBremFsbG9jKHNpemVvZigqZXYpLCBHRlBfQVRPTUlDKTsKCQlpZiAoIWV2KSB7CgkJCXBy
aW50ayhLRVJOX0VSUiAibWVnYXNhc19zZXJ2aWNlX2Flbjogb3V0IG9mIG1lbW9yeVxuIik7CgkJ
fSBlbHNlIHsKCQkJZXYtPmluc3RhbmNlID0gaW5zdGFuY2U7CgkJCWluc3RhbmNlLT5ldiA9IGV2
OwoJCQlJTklUX1dPUksoJmV2LT5ob3RwbHVnX3dvcmssIG1lZ2FzYXNfYWVuX3BvbGxpbmcpOwoJ
CQlzY2hlZHVsZV9kZWxheWVkX3dvcmsoCgkJCQkoc3RydWN0IGRlbGF5ZWRfd29yayAqKSZldi0+
aG90cGx1Z193b3JrLCAwKTsKCQl9Cgl9Cn0KCi8qCiAqIFNjc2kgaG9zdCB0ZW1wbGF0ZSBmb3Ig
bWVnYXJhaWRfc2FzIGRyaXZlcgogKi8Kc3RhdGljIHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUg
bWVnYXNhc190ZW1wbGF0ZSA9IHsKCgkubW9kdWxlID0gVEhJU19NT0RVTEUsCgkubmFtZSA9ICJM
U0kgU0FTIGJhc2VkIE1lZ2FSQUlEIGRyaXZlciIsCgkucHJvY19uYW1lID0gIm1lZ2FyYWlkX3Nh
cyIsCgkuc2xhdmVfY29uZmlndXJlID0gbWVnYXNhc19zbGF2ZV9jb25maWd1cmUsCgkuc2xhdmVf
YWxsb2MgPSBtZWdhc2FzX3NsYXZlX2FsbG9jLAoJLnF1ZXVlY29tbWFuZCA9IG1lZ2FzYXNfcXVl
dWVfY29tbWFuZCwKCS5laF9kZXZpY2VfcmVzZXRfaGFuZGxlciA9IG1lZ2FzYXNfcmVzZXRfZGV2
aWNlLAoJLmVoX2J1c19yZXNldF9oYW5kbGVyID0gbWVnYXNhc19yZXNldF9idXNfaG9zdCwKCS5l
aF9ob3N0X3Jlc2V0X2hhbmRsZXIgPSBtZWdhc2FzX3Jlc2V0X2J1c19ob3N0LAoJLmVoX3RpbWVk
X291dCA9IG1lZ2FzYXNfcmVzZXRfdGltZXIsCgkuYmlvc19wYXJhbSA9IG1lZ2FzYXNfYmlvc19w
YXJhbSwKCS51c2VfY2x1c3RlcmluZyA9IEVOQUJMRV9DTFVTVEVSSU5HLAp9OwoKLyoqCiAqIG1l
Z2FzYXNfY29tcGxldGVfaW50X2NtZCAtCUNvbXBsZXRlcyBhbiBpbnRlcm5hbCBjb21tYW5kCiAq
IEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKICogQGNtZDoJCQlDb21tYW5kIHRvIGJl
IGNvbXBsZXRlZAogKgogKiBUaGUgbWVnYXNhc19pc3N1ZV9ibG9ja2VkX2NtZCgpIGZ1bmN0aW9u
IHdhaXRzIGZvciBhIGNvbW1hbmQgdG8gY29tcGxldGUKICogYWZ0ZXIgaXQgaXNzdWVzIGEgY29t
bWFuZC4gVGhpcyBmdW5jdGlvbiB3YWtlcyB1cCB0aGF0IHdhaXRpbmcgcm91dGluZSBieQogKiBj
YWxsaW5nIHdha2VfdXAoKSBvbiB0aGUgd2FpdCBxdWV1ZS4KICovCnN0YXRpYyB2b2lkCm1lZ2Fz
YXNfY29tcGxldGVfaW50X2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCgkJ
CSBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCkKewoJY21kLT5jbWRfc3RhdHVzID0gY21kLT5mcmFt
ZS0+aW8uY21kX3N0YXR1czsKCglpZiAoY21kLT5jbWRfc3RhdHVzID09IEVOT0RBVEEpIHsKCQlj
bWQtPmNtZF9zdGF0dXMgPSAwOwoJfQoJd2FrZV91cCgmaW5zdGFuY2UtPmludF9jbWRfd2FpdF9x
KTsKfQoKLyoqCiAqIG1lZ2FzYXNfY29tcGxldGVfYWJvcnQgLQlDb21wbGV0ZXMgYWJvcnRpbmcg
YSBjb21tYW5kCiAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKICogQGNtZDoJCQlD
bWQgdGhhdCB3YXMgaXNzdWVkIHRvIGFib3J0IGFub3RoZXIgY21kCiAqCiAqIFRoZSBtZWdhc2Fz
X2lzc3VlX2Jsb2NrZWRfYWJvcnRfY21kKCkgZnVuY3Rpb24gd2FpdHMgb24gYWJvcnRfY21kX3dh
aXRfcSAKICogYWZ0ZXIgaXQgaXNzdWVzIGFuIGFib3J0IG9uIGEgcHJldmlvdXNseSBpc3N1ZWQg
Y29tbWFuZC4gVGhpcyBmdW5jdGlvbiAKICogd2FrZXMgdXAgYWxsIGZ1bmN0aW9ucyB3YWl0aW5n
IG9uIHRoZSBzYW1lIHdhaXQgcXVldWUuCiAqLwpzdGF0aWMgdm9pZAptZWdhc2FzX2NvbXBsZXRl
X2Fib3J0KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCQkgICAgICAgc3RydWN0
IG1lZ2FzYXNfY21kICpjbWQpCnsKCWlmIChjbWQtPnN5bmNfY21kKSB7CgkJY21kLT5zeW5jX2Nt
ZCA9IDA7CgkJY21kLT5jbWRfc3RhdHVzID0gMDsKCQl3YWtlX3VwKCZpbnN0YW5jZS0+YWJvcnRf
Y21kX3dhaXRfcSk7Cgl9CgoJcmV0dXJuOwp9CgovKioKICogbWVnYXNhc19jb21wbGV0ZV9jbWQg
LQlDb21wbGV0ZXMgYSBjb21tYW5kCiAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUK
ICogQGNtZDoJCQlDb21tYW5kIHRvIGJlIGNvbXBsZXRlZAogKiBAYWx0X3N0YXR1czoJCQlJZiBu
b24temVybywgdXNlIHRoaXMgdmFsdWUgYXMgc3RhdHVzIHRvIAogKiAJCQkJU0NTSSBtaWQtbGF5
ZXIgaW5zdGVhZCBvZiB0aGUgdmFsdWUgcmV0dXJuZWQKICogCQkJCWJ5IHRoZSBGVy4gVGhpcyBz
aG91bGQgYmUgdXNlZCBpZiBjYWxsZXIgd2FudHMKICogCQkJCWFuIGFsdGVybmF0ZSBzdGF0dXMg
KGFzIGluIHRoZSBjYXNlIG9mIGFib3J0ZWQKICogCQkJCWNvbW1hbmRzKQogKi8Kc3RhdGljIHZv
aWQKbWVnYXNhc19jb21wbGV0ZV9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNl
LCBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCwKCQkgICAgIHU4IGFsdF9zdGF0dXMpCnsKCWludCBl
eGNlcHRpb24gPSAwOwoJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpoZHIgPSAmY21kLT5mcmFtZS0+
aGRyOwoJdW5zaWduZWQgbG9uZyBmbGFnczsKCgkvKiBmbGFnIGZvciB0aGUgcmV0cnkgcmVzZXQg
Ki8KCWNtZC0+cmV0cnlfZm9yX2Z3X3Jlc2V0ID0gMDsKCglpZiAoY21kLT5zY21kKQoJCWNtZC0+
c2NtZC0+U0NwLnB0ciA9IE5VTEw7CgoJc3dpdGNoIChoZHItPmNtZCkgewoKCWNhc2UgTUZJX0NN
RF9QRF9TQ1NJX0lPOgoJY2FzZSBNRklfQ01EX0xEX1NDU0lfSU86CgoJCS8qCgkJICogTUZJX0NN
RF9QRF9TQ1NJX0lPIGFuZCBNRklfQ01EX0xEX1NDU0lfSU8gY291bGQgaGF2ZSBiZWVuCgkJICog
aXNzdWVkIGVpdGhlciB0aHJvdWdoIGFuIElPIHBhdGggb3IgYW4gSU9DVEwgcGF0aC4gSWYgaXQK
CQkgKiB3YXMgdmlhIElPQ1RMLCB3ZSB3aWxsIHNlbmQgaXQgdG8gaW50ZXJuYWwgY29tcGxldGlv
bi4KCQkgKi8KCQlpZiAoY21kLT5zeW5jX2NtZCkgewoJCQljbWQtPnN5bmNfY21kID0gMDsKCQkJ
bWVnYXNhc19jb21wbGV0ZV9pbnRfY21kKGluc3RhbmNlLCBjbWQpOwoJCQlicmVhazsKCQl9CgoJ
Y2FzZSBNRklfQ01EX0xEX1JFQUQ6CgljYXNlIE1GSV9DTURfTERfV1JJVEU6CgoJCWlmIChhbHRf
c3RhdHVzKSB7CgkJCWNtZC0+c2NtZC0+cmVzdWx0ID0gYWx0X3N0YXR1cyA8PCAxNjsKCQkJZXhj
ZXB0aW9uID0gMTsKCQl9CgoJCWlmIChleGNlcHRpb24pIHsKCgkJCWF0b21pY19kZWMoJmluc3Rh
bmNlLT5md19vdXRzdGFuZGluZyk7CgoJCQlzY3NpX2RtYV91bm1hcChjbWQtPnNjbWQpOwoJCQlj
bWQtPnNjbWQtPnNjc2lfZG9uZShjbWQtPnNjbWQpOwoJCQltZWdhc2FzX3JldHVybl9jbWQoaW5z
dGFuY2UsIGNtZCk7CgoJCQlicmVhazsKCQl9CgoJCXN3aXRjaCAoaGRyLT5jbWRfc3RhdHVzKSB7
CgoJCWNhc2UgTUZJX1NUQVRfT0s6CgkJCWNtZC0+c2NtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2
OwoJCQlicmVhazsKCgkJY2FzZSBNRklfU1RBVF9TQ1NJX0lPX0ZBSUxFRDoKCQljYXNlIE1GSV9T
VEFUX0xEX0lOSVRfSU5fUFJPR1JFU1M6CgkJCWNtZC0+c2NtZC0+cmVzdWx0ID0KCQkJICAgIChE
SURfRVJST1IgPDwgMTYpIHwgaGRyLT5zY3NpX3N0YXR1czsKCQkJYnJlYWs7CgoJCWNhc2UgTUZJ
X1NUQVRfU0NTSV9ET05FX1dJVEhfRVJST1I6CgoJCQljbWQtPnNjbWQtPnJlc3VsdCA9IChESURf
T0sgPDwgMTYpIHwgaGRyLT5zY3NpX3N0YXR1czsKCgkJCWlmIChoZHItPnNjc2lfc3RhdHVzID09
IFNBTV9TVEFUX0NIRUNLX0NPTkRJVElPTikgewoJCQkJbWVtc2V0KGNtZC0+c2NtZC0+c2Vuc2Vf
YnVmZmVyLCAwLAoJCQkJICAgICAgIFNDU0lfU0VOU0VfQlVGRkVSU0laRSk7CgkJCQltZW1jcHko
Y21kLT5zY21kLT5zZW5zZV9idWZmZXIsIGNtZC0+c2Vuc2UsCgkJCQkgICAgICAgaGRyLT5zZW5z
ZV9sZW4pOwoKCQkJCWNtZC0+c2NtZC0+cmVzdWx0IHw9IERSSVZFUl9TRU5TRSA8PCAyNDsKCQkJ
fQoKCQkJYnJlYWs7CgoJCWNhc2UgTUZJX1NUQVRfTERfT0ZGTElORToKCQljYXNlIE1GSV9TVEFU
X0RFVklDRV9OT1RfRk9VTkQ6CgkJCWNtZC0+c2NtZC0+cmVzdWx0ID0gRElEX0JBRF9UQVJHRVQg
PDwgMTY7CgkJCWJyZWFrOwoKCQlkZWZhdWx0OgoJCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNh
czogTUZJIEZXIHN0YXR1cyAlI3hcbiIsCgkJCSAgICAgICBoZHItPmNtZF9zdGF0dXMpOwoJCQlj
bWQtPnNjbWQtPnJlc3VsdCA9IERJRF9FUlJPUiA8PCAxNjsKCQkJYnJlYWs7CgkJfQoKCQlhdG9t
aWNfZGVjKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOwoKCQlzY3NpX2RtYV91bm1hcChjbWQt
PnNjbWQpOwoJCWNtZC0+c2NtZC0+c2NzaV9kb25lKGNtZC0+c2NtZCk7CgkJbWVnYXNhc19yZXR1
cm5fY21kKGluc3RhbmNlLCBjbWQpOwoKCQlicmVhazsKCgljYXNlIE1GSV9DTURfU01QOgoJY2Fz
ZSBNRklfQ01EX1NUUDoKCWNhc2UgTUZJX0NNRF9EQ01EOgoJCWlmIChjbWQtPmZyYW1lLT5kY21k
Lm9wY29kZSA9PSBNUl9EQ01EX0NUUkxfRVZFTlRfR0VUX0lORk8gfHwKCQkJY21kLT5mcmFtZS0+
ZGNtZC5vcGNvZGUgPT0gTVJfRENNRF9DVFJMX0VWRU5UX0dFVCkgewoJCQlzcGluX2xvY2tfaXJx
c2F2ZSgmcG9sbF9hZW5fbG9jaywgZmxhZ3MpOwoJCQltZWdhc2FzX3BvbGxfd2FpdF9hZW4gPSAw
OwoJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwb2xsX2Flbl9sb2NrLCBmbGFncyk7CgkJfQoK
CQkvKgoJCSAqIFNlZSBpZiBnb3QgYW4gZXZlbnQgbm90aWZpY2F0aW9uCgkJICovCgkJaWYgKGNt
ZC0+ZnJhbWUtPmRjbWQub3Bjb2RlID09IE1SX0RDTURfQ1RSTF9FVkVOVF9XQUlUKQoJCQltZWdh
c2FzX3NlcnZpY2VfYWVuKGluc3RhbmNlLCBjbWQpOwoJCWVsc2UKCQkJbWVnYXNhc19jb21wbGV0
ZV9pbnRfY21kKGluc3RhbmNlLCBjbWQpOwoKCQlicmVhazsKCgljYXNlIE1GSV9DTURfQUJPUlQ6
CgkJLyoKCQkgKiBDbWQgaXNzdWVkIHRvIGFib3J0IGFub3RoZXIgY21kIHJldHVybmVkCgkJICov
CgkJbWVnYXNhc19jb21wbGV0ZV9hYm9ydChpbnN0YW5jZSwgY21kKTsKCQlicmVhazsKCglkZWZh
dWx0OgoJCXByaW50aygibWVnYXNhczogVW5rbm93biBjb21tYW5kIGNvbXBsZXRlZCEgWzB4JVhd
XG4iLAoJCSAgICAgICBoZHItPmNtZCk7CgkJYnJlYWs7Cgl9Cn0KCi8qKgogKiBtZWdhc2FzX2lz
c3VlX3BlbmRpbmdfY21kc19hZ2FpbiAtCWlzc3VlIGFsbCBwZW5kaW5nIGNtZHMKICogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAJaW4gRlcgYWdhaW4gYmVjYXVzZSBvZiB0aGUgZncgcmVz
ZXQKICogQGluc3RhbmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKICovCnN0YXRpYyBpbmxpbmUg
dm9pZAptZWdhc2FzX2lzc3VlX3BlbmRpbmdfY21kc19hZ2FpbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpCnsKCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOwoJc3RydWN0IGxpc3Rf
aGVhZCBjbGlzdF9sb2NhbDsKCXVuaW9uIG1lZ2FzYXNfZXZ0X2NsYXNzX2xvY2FsZSBjbGFzc19s
b2NhbGU7Cgl1bnNpZ25lZCBsb25nIGZsYWdzOwoJdTMyIHNlcV9udW07CgoJSU5JVF9MSVNUX0hF
QUQoJmNsaXN0X2xvY2FsKTsKCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ss
IGZsYWdzKTsKCWxpc3Rfc3BsaWNlX2luaXQoJmluc3RhbmNlLT5pbnRlcm5hbF9yZXNldF9wZW5k
aW5nX3EsICZjbGlzdF9sb2NhbCk7CglzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+
aGJhX2xvY2ssIGZsYWdzKTsKCgl3aGlsZSAoIWxpc3RfZW1wdHkoJmNsaXN0X2xvY2FsKSkgewoJ
CWNtZAk9IGxpc3RfZW50cnkoKCZjbGlzdF9sb2NhbCktPm5leHQsCgkJCQkJc3RydWN0IG1lZ2Fz
YXNfY21kLCBsaXN0KTsKCQlsaXN0X2RlbF9pbml0KCZjbWQtPmxpc3QpOwoKCQlpZiAoY21kLT5z
eW5jX2NtZCB8fCBjbWQtPnNjbWQpIHsKCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhcmFpZF9z
YXM6IGNvbW1hbmQgJXAsICVwOiVkIgoJCQkJImRldGVjdGVkIHRvIGJlIHBlbmRpbmcgd2hpbGUg
SEJBIHJlc2V0LlxuIiwKCQkJCQljbWQsIGNtZC0+c2NtZCwgY21kLT5zeW5jX2NtZCk7CgoJCQlj
bWQtPnJldHJ5X2Zvcl9md19yZXNldCsrOwoKCQkJaWYgKGNtZC0+cmV0cnlfZm9yX2Z3X3Jlc2V0
ID09IDMpIHsKCQkJCXByaW50ayhLRVJOX05PVElDRSAibWVnYXJhaWRfc2FzOiBjbWQgJXAsICVw
OiVkIgoJCQkJCSJ3YXMgdHJpZWQgbXVsdGlwbGUgdGltZXMgZHVyaW5nIHJlc2V0LiIKCQkJCQki
U2h1dHRpbmcgZG93biB0aGUgSEJBXG4iLAoJCQkJCWNtZCwgY21kLT5zY21kLCBjbWQtPnN5bmNf
Y21kKTsKCQkJCW1lZ2FyYWlkX3Nhc19raWxsX2hiYShpbnN0YW5jZSk7CgoJCQkJaW5zdGFuY2Ut
PmFkcHJlY292ZXJ5ID0KCQkJCQkJTUVHQVNBU19IV19DUklUSUNBTF9FUlJPUjsKCQkJCXJldHVy
bjsKCQkJfQoJCX0KCgkJaWYgKGNtZC0+c3luY19jbWQgPT0gMSkgewoJCQlpZiAoY21kLT5zY21k
KSB7CgkJCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FyYWlkX3NhczogdW5leHBlY3RlZCIKCQkJ
CQkiY21kIGF0dGFjaGVkIHRvIGludGVybmFsIGNvbW1hbmQhXG4iKTsKCQkJfQoJCQlwcmludGso
S0VSTl9OT1RJQ0UgIm1lZ2FzYXM6ICVwIHN5bmNocm9ub3VzIGNtZCIKCQkJCQkJIm9uIHRoZSBp
bnRlcm5hbCByZXNldCBxdWV1ZSwiCgkJCQkJCSJpc3N1ZSBpdCBhZ2Fpbi5cbiIsIGNtZCk7CgkJ
CWNtZC0+Y21kX3N0YXR1cyA9IEVOT0RBVEE7CgkJCWluc3RhbmNlLT5pbnN0YW5jZXQtPmZpcmVf
Y21kKGluc3RhbmNlLAoJCQkJCQkJY21kLT5mcmFtZV9waHlzX2FkZHIgLAoJCQkJCQkJMCwgaW5z
dGFuY2UtPnJlZ19zZXQpOwoJCX0gZWxzZSBpZiAoY21kLT5zY21kKSB7CgkJCXByaW50ayhLRVJO
X05PVElDRSAibWVnYXNhczogJXAgc2NzaSBjbWQgWyUwMnhdLCUjbHgiCgkJCSJkZXRlY3RlZCBv
biB0aGUgaW50ZXJuYWwgcXVldWUsIGlzc3VlIGFnYWluLlxuIiwKCQkJY21kLCBjbWQtPnNjbWQt
PmNtbmRbMF0sIGNtZC0+c2NtZC0+c2VyaWFsX251bWJlcik7CgoJCQlhdG9taWNfaW5jKCZpbnN0
YW5jZS0+Zndfb3V0c3RhbmRpbmcpOwoJCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChp
bnN0YW5jZSwKCQkJCQljbWQtPmZyYW1lX3BoeXNfYWRkciwKCQkJCQljbWQtPmZyYW1lX2NvdW50
LTEsIGluc3RhbmNlLT5yZWdfc2V0KTsKCQl9IGVsc2UgewoJCQlwcmludGsoS0VSTl9OT1RJQ0Ug
Im1lZ2FzYXM6ICVwIHVuZXhwZWN0ZWQgY21kIG9uIHRoZSIKCQkJCSJpbnRlcm5hbCByZXNldCBk
ZWZlciBsaXN0IHdoaWxlIHJlLWlzc3VlISFcbiIsCgkJCQljbWQpOwoJCX0KCX0KCglpZiAoaW5z
dGFuY2UtPmFlbl9jbWQpIHsKCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FyYWlkX3NhczogYWVu
X2NtZCBpbiBkZWYgcHJvY2Vzc1xuIik7CgkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBp
bnN0YW5jZS0+YWVuX2NtZCk7CgoJCWluc3RhbmNlLT5hZW5fY21kCT0gTlVMTDsKCX0KCgkvKgoJ
KiBJbml0aWF0ZSBBRU4gKEFzeW5jaHJvbm91cyBFdmVudCBOb3RpZmljYXRpb24pCgkqLwoJc2Vx
X251bSA9IGluc3RhbmNlLT5sYXN0X3NlcV9udW07CgljbGFzc19sb2NhbGUubWVtYmVycy5yZXNl
cnZlZCA9IDA7CgljbGFzc19sb2NhbGUubWVtYmVycy5sb2NhbGUgPSBNUl9FVlRfTE9DQUxFX0FM
TDsKCWNsYXNzX2xvY2FsZS5tZW1iZXJzLmNsYXNzID0gTVJfRVZUX0NMQVNTX0RFQlVHOwoKCW1l
Z2FzYXNfcmVnaXN0ZXJfYWVuKGluc3RhbmNlLCBzZXFfbnVtLCBjbGFzc19sb2NhbGUud29yZCk7
Cn0KCi8qKgogKiBNb3ZlIHRoZSBpbnRlcm5hbCByZXNldCBwZW5kaW5nIGNvbW1hbmRzIHRvIGEg
ZGVmZXJyZWQgcXVldWUuCiAqCiAqIFdlIG1vdmUgdGhlIGNvbW1hbmRzIHBlbmRpbmcgYXQgaW50
ZXJuYWwgcmVzZXQgdGltZSB0byBhCiAqIHBlbmRpbmcgcXVldWUuIFRoaXMgcXVldWUgd291bGQg
YmUgZmx1c2hlZCBhZnRlciBzdWNjZXNzZnVsCiAqIGNvbXBsZXRpb24gb2YgdGhlIGludGVybmFs
IHJlc2V0IHNlcXVlbmNlLiBpZiB0aGUgaW50ZXJuYWwgcmVzZXQKICogZGlkIG5vdCBjb21wbGV0
ZSBpbiB0aW1lLCB0aGUga2VybmVsIHJlc2V0IGhhbmRsZXIgd291bGQgZmx1c2gKICogdGhlc2Ug
Y29tbWFuZHMuCiAqKi8Kc3RhdGljIHZvaWQKbWVnYXNhc19pbnRlcm5hbF9yZXNldF9kZWZlcl9j
bWRzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKewoJc3RydWN0IG1lZ2FzYXNf
Y21kICpjbWQ7CglpbnQgaTsKCXUzMiBtYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOwoJ
dTMyIGRlZmVyX2luZGV4OwoJdW5zaWduZWQgbG9uZyBmbGFnczsKCglkZWZlcl9pbmRleCAgICAg
PSAwOwoJc3Bpbl9sb2NrX2lycXNhdmUoJmluc3RhbmNlLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7
Cglmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsrKSB7CgkJY21kID0gaW5zdGFuY2UtPmNtZF9s
aXN0W2ldOwoJCWlmIChjbWQtPnN5bmNfY21kID09IDEgfHwgY21kLT5zY21kKSB7CgkJCXByaW50
ayhLRVJOX05PVElDRSAibWVnYXNhczogbW92aW5nIGNtZFslZF06JXA6JWQ6JXAiCgkJCQkJIm9u
IHRoZSBkZWZlciBxdWV1ZSBhcyBpbnRlcm5hbFxuIiwKCQkJCWRlZmVyX2luZGV4LCBjbWQsIGNt
ZC0+c3luY19jbWQsIGNtZC0+c2NtZCk7CgoJCQlpZiAoIWxpc3RfZW1wdHkoJmNtZC0+bGlzdCkp
IHsKCQkJCXByaW50ayhLRVJOX05PVElDRSAibWVnYXJhaWRfc2FzOiBFUlJPUiB3aGlsZSIKCQkJ
CQkiIG1vdmluZyB0aGlzIGNtZDolcCwgJWQgJXAsIGl0IHdhcyIKCQkJCQkiZGlzY292ZXJlZCBv
biBzb21lIGxpc3Q/XG4iLAoJCQkJCWNtZCwgY21kLT5zeW5jX2NtZCwgY21kLT5zY21kKTsKCgkJ
CQlsaXN0X2RlbF9pbml0KCZjbWQtPmxpc3QpOwoJCQl9CgkJCWRlZmVyX2luZGV4Kys7CgkJCWxp
c3RfYWRkX3RhaWwoJmNtZC0+bGlzdCwKCQkJCSZpbnN0YW5jZS0+aW50ZXJuYWxfcmVzZXRfcGVu
ZGluZ19xKTsKCQl9Cgl9CglzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+Y21kX3Bv
b2xfbG9jaywgZmxhZ3MpOwp9CgoKc3RhdGljIHZvaWQKcHJvY2Vzc19md19zdGF0ZV9jaGFuZ2Vf
d3Eoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQp7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2UgPQoJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSwg
d29ya19pbml0KTsKCXUzMiB3YWl0OwoJdW5zaWduZWQgbG9uZyBmbGFnczsKCglpZiAoaW5zdGFu
Y2UtPmFkcHJlY292ZXJ5ICE9IE1FR0FTQVNfQURQUkVTRVRfU01fSU5GQVVMVCkgewoJCXByaW50
ayhLRVJOX05PVElDRSAibWVnYXJhaWRfc2FzOiBlcnJvciwgcmVjb3Zlcnkgc3QgJXggXG4iLAoJ
CQkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5KTsKCQlyZXR1cm4gOwoJfQoKCWlmIChpbnN0YW5jZS0+
YWRwcmVjb3ZlcnkgPT0gTUVHQVNBU19BRFBSRVNFVF9TTV9JTkZBVUxUKSB7CgkJcHJpbnRrKEtF
Uk5fTk9USUNFICJtZWdhcmFpZF9zYXM6IEZXIGRldGVjdGVkIHRvIGJlIGluIGZhdWx0IgoJCQkJ
CSJzdGF0ZSwgcmVzdGFydGluZyBpdC4uLlxuIik7CgoJCWluc3RhbmNlLT5pbnN0YW5jZXQtPmRp
c2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7CgkJYXRvbWljX3NldCgmaW5zdGFuY2UtPmZ3
X291dHN0YW5kaW5nLCAwKTsKCgkJYXRvbWljX3NldCgmaW5zdGFuY2UtPmZ3X3Jlc2V0X25vX3Bj
aV9hY2Nlc3MsIDEpOwoJCWluc3RhbmNlLT5pbnN0YW5jZXQtPmFkcF9yZXNldChpbnN0YW5jZSwg
aW5zdGFuY2UtPnJlZ19zZXQpOwoJCWF0b21pY19zZXQoJmluc3RhbmNlLT5md19yZXNldF9ub19w
Y2lfYWNjZXNzLCAwICk7CgoJCXByaW50ayhLRVJOX05PVElDRSAibWVnYXJhaWRfc2FzOiBGVyBy
ZXN0YXJ0ZWQgc3VjY2Vzc2Z1bGx5LCIKCQkJCQkiaW5pdGlhdGluZyBuZXh0IHN0YWdlLi4uXG4i
KTsKCgkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhcmFpZF9zYXM6IEhCQSByZWNvdmVyeSBzdGF0
ZSBtYWNoaW5lLCIKCQkJCQkic3RhdGUgMiBzdGFydGluZy4uLlxuIik7CgoJCS8qd2FpdHRpbmcg
Zm9yIGFib3V0IDIwIHNlY29uZCBiZWZvcmUgc3RhcnQgdGhlIHNlY29uZCBpbml0Ki8KCQlmb3Ig
KHdhaXQgPSAwOyB3YWl0IDwgMzA7IHdhaXQrKykgewoJCQltc2xlZXAoMTAwMCk7CgkJfQoKCQlp
ZiAobWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KGluc3RhbmNlKSkgewoJCQlwcmludGsoS0VS
Tl9OT1RJQ0UgIm1lZ2FyYWlkX3NhczphZGFwdGVyIG5vdCByZWFkeVxuIik7CgoJCQltZWdhcmFp
ZF9zYXNfa2lsbF9oYmEoaW5zdGFuY2UpOwoJCQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkJPSBNRUdB
U0FTX0hXX0NSSVRJQ0FMX0VSUk9SOwoJCQlyZXR1cm4gOwoJCX0KCgkJaWYgKChpbnN0YW5jZS0+
cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNjRSKSB8fAoJCQkoaW5zdGFu
Y2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0RFTExfUEVSQzUpIHx8CgkJCShpbnN0
YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX1ZFUkRFX1pDUikKCQkJKSB7
CgkJCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAqaW5zdGFuY2UtPnByb2R1Y2VyOwoJCX0gZWxzZSB7
CgkJCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAwOwoJCQkqaW5zdGFuY2UtPnByb2R1Y2VyID0gMDsK
CQl9CgoJCW1lZ2FzYXNfaXNzdWVfaW5pdF9tZmkoaW5zdGFuY2UpOwoKCQlzcGluX2xvY2tfaXJx
c2F2ZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CgkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5
CT0gTUVHQVNBU19IQkFfT1BFUkFUSU9OQUw7CgkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5z
dGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CgkJaW5zdGFuY2UtPmluc3RhbmNldC0+ZW5hYmxlX2lu
dHIoaW5zdGFuY2UtPnJlZ19zZXQpOwoKCQltZWdhc2FzX2lzc3VlX3BlbmRpbmdfY21kc19hZ2Fp
bihpbnN0YW5jZSk7CgkJaW5zdGFuY2UtPmlzc3VlcGVuZF9kb25lID0gMTsKCX0KCXJldHVybiA7
Cn0KCi8qKgogKiBtZWdhc2FzX2RlcGxldGVfcmVwbHlfcXVldWUgLQlQcm9jZXNzZXMgYWxsIGNv
bXBsZXRlZCBjb21tYW5kcwogKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQogKiBA
YWx0X3N0YXR1czoJCQkJQWx0ZXJuYXRlIHN0YXR1cyB0byBiZSByZXR1cm5lZCB0bwogKiAJCQkJ
CVNDU0kgbWlkLWxheWVyIGluc3RlYWQgb2YgdGhlIHN0YXR1cwogKiAJCQkJCXJldHVybmVkIGJ5
IHRoZSBGVwogKiBOb3RlOiB0aGlzIG11c3QgYmUgY2FsbGVkIHdpdGggaGJhIGxvY2sgaGVsZAog
Ki8Kc3RhdGljIGludAptZWdhc2FzX2RlcGxldGVfcmVwbHlfcXVldWUoc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLAoJCQkJCXU4IGFsdF9zdGF0dXMpCnsKCXUzMiBtZmlTdGF0dXM7
Cgl1MzIgZndfc3RhdGU7CgoJaWYgKChtZmlTdGF0dXMgPSBpbnN0YW5jZS0+aW5zdGFuY2V0LT5j
aGVja19yZXNldChpbnN0YW5jZSwKCQkJCQlpbnN0YW5jZS0+cmVnX3NldCkpID09IDEpIHsKCQly
ZXR1cm4gSVJRX0hBTkRMRUQ7Cgl9CgoJaWYgKChtZmlTdGF0dXMgPSBpbnN0YW5jZS0+aW5zdGFu
Y2V0LT5jbGVhcl9pbnRyKAoJCQkJCQlpbnN0YW5jZS0+cmVnX3NldCkKCQkJCQkJKSA9PSAwKSB7
CgkJcmV0dXJuIElSUV9OT05FOwoJfQoKCWluc3RhbmNlLT5tZmlTdGF0dXMgPSBtZmlTdGF0dXM7
CgoJaWYgKChtZmlTdGF0dXMgJiBNRklfSU5UUl9GTEFHX0ZJUk1XQVJFX1NUQVRFX0NIQU5HRSkp
IHsKCQlmd19zdGF0ZSA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygK
CQkJCWluc3RhbmNlLT5yZWdfc2V0KSAmIE1GSV9TVEFURV9NQVNLOwoKCQlpZiAoZndfc3RhdGUg
IT0gTUZJX1NUQVRFX0ZBVUxUKSB7CgkJCXByaW50ayhLRVJOX05PVElDRSAibWVnYXJhaWRfc2Fz
OiBmdyBzdGF0ZToleFxuIiwKCQkJCQkJZndfc3RhdGUpOwoJCX0KCgkJaWYgKChmd19zdGF0ZSA9
PSBNRklfU1RBVEVfRkFVTFQpICYmCgkJCQkoaW5zdGFuY2UtPmRpc2FibGVPbmxpbmVDdHJsUmVz
ZXQgPT0gMCkpIHsKCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhcmFpZF9zYXM6IHdhaXQgYWRw
IHJlc3RhcnRcbiIpOwoKCQkJaWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CgkJCQkJUENJ
X0RFVklDRV9JRF9MU0lfU0FTMTA2NFIpIHx8CgkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9
PQoJCQkJCVBDSV9ERVZJQ0VfSURfREVMTF9QRVJDNSkgfHwKCQkJCShpbnN0YW5jZS0+cGRldi0+
ZGV2aWNlID09CgkJCQkJUENJX0RFVklDRV9JRF9MU0lfVkVSREVfWkNSKSkgewoKCQkJCSppbnN0
YW5jZS0+Y29uc3VtZXIgPQoJCQkJCU1FR0FTQVNfQURQUkVTRVRfSU5QUk9HX1NJR047CgkJCX0K
CgoJCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQp
OwoJCQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkJPSBNRUdBU0FTX0FEUFJFU0VUX1NNX0lORkFVTFQ7
CgkJCWluc3RhbmNlLT5pc3N1ZXBlbmRfZG9uZSA9IDA7CgoJCQlhdG9taWNfc2V0KCZpbnN0YW5j
ZS0+Zndfb3V0c3RhbmRpbmcsIDApOwoJCQltZWdhc2FzX2ludGVybmFsX3Jlc2V0X2RlZmVyX2Nt
ZHMoaW5zdGFuY2UpOwoKCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhc2FzOiBmd1N0YXRlPSV4
LCBzdGFnZTolZFxuIiwKCQkJCQlmd19zdGF0ZSwgaW5zdGFuY2UtPmFkcHJlY292ZXJ5KTsKCgkJ
CXNjaGVkdWxlX3dvcmsoJmluc3RhbmNlLT53b3JrX2luaXQpOwoJCQlyZXR1cm4gSVJRX0hBTkRM
RUQ7CgoJCX0gZWxzZSB7CgkJCXByaW50ayhLRVJOX05PVElDRSAibWVnYXNhczogZndzdGF0ZTol
eCwgZGlzX09DUj0leFxuIiwKCQkJCWZ3X3N0YXRlLCBpbnN0YW5jZS0+ZGlzYWJsZU9ubGluZUN0
cmxSZXNldCk7CgkJfQoJfQoKCXRhc2tsZXRfc2NoZWR1bGUoJmluc3RhbmNlLT5pc3JfdGFza2xl
dCk7CglyZXR1cm4gSVJRX0hBTkRMRUQ7Cn0KLyoqCiAqIG1lZ2FzYXNfaXNyIC0gaXNyIGVudHJ5
IHBvaW50CiAqLwpzdGF0aWMgaXJxcmV0dXJuX3QgbWVnYXNhc19pc3IoaW50IGlycSwgdm9pZCAq
ZGV2cCkKewoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOwoJdW5zaWduZWQgbG9u
ZyBmbGFnczsKCWlycXJldHVybl90CXJjOwoKCWlmIChhdG9taWNfcmVhZCgKCQkmKCgoc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2UgKilkZXZwKS0+ZndfcmVzZXRfbm9fcGNpX2FjY2VzcykpKQoJCXJl
dHVybiBJUlFfSEFORExFRDsKCglpbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
KWRldnA7CgoJc3Bpbl9sb2NrX2lycXNhdmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoJ
cmMgPSAgbWVnYXNhc19kZXBsZXRlX3JlcGx5X3F1ZXVlKGluc3RhbmNlLCBESURfT0spOwoJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CgoJcmV0dXJu
IHJjOwp9CgovKioKICogbWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5IC0JTW92ZSB0aGUgRlcg
dG8gUkVBRFkgc3RhdGUKICogQGluc3RhbmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKICoKICog
RHVyaW5nIHRoZSBpbml0aWFsaXphdGlvbiwgRlcgcGFzc2VzIGNhbiBwb3RlbnRpYWxseSBiZSBp
biBhbnkgb25lIG9mCiAqIHNldmVyYWwgcG9zc2libGUgc3RhdGVzLiBJZiB0aGUgRlcgaW4gb3Bl
cmF0aW9uYWwsIHdhaXRpbmctZm9yLWhhbmRzaGFrZQogKiBzdGF0ZXMsIGRyaXZlciBtdXN0IHRh
a2Ugc3RlcHMgdG8gYnJpbmcgaXQgdG8gcmVhZHkgc3RhdGUuIE90aGVyd2lzZSwgaXQKICogaGFz
IHRvIHdhaXQgZm9yIHRoZSByZWFkeSBzdGF0ZS4KICovCnN0YXRpYyBpbnQKbWVnYXNhc190cmFu
c2l0aW9uX3RvX3JlYWR5KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlKiBpbnN0YW5jZSkKewoJaW50
IGk7Cgl1OCBtYXhfd2FpdDsKCXUzMiBmd19zdGF0ZTsKCXUzMiBjdXJfc3RhdGU7Cgl1MzIgYWJz
X3N0YXRlLCBjdXJyX2Fic19zdGF0ZTsKCglmd19zdGF0ZSA9IGluc3RhbmNlLT5pbnN0YW5jZXQt
PnJlYWRfZndfc3RhdHVzX3JlZyhpbnN0YW5jZS0+cmVnX3NldCkgJiBNRklfU1RBVEVfTUFTSzsK
CglpZiAoZndfc3RhdGUgIT0gTUZJX1NUQVRFX1JFQURZKQogCQlwcmludGsoS0VSTl9JTkZPICJt
ZWdhc2FzOiBXYWl0aW5nIGZvciBGVyB0byBjb21lIHRvIHJlYWR5IgogCQkgICAgICAgIiBzdGF0
ZVxuIik7CgoJd2hpbGUgKGZ3X3N0YXRlICE9IE1GSV9TVEFURV9SRUFEWSkgewoKCQlhYnNfc3Rh
dGUgPQoJCWluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZyhpbnN0YW5jZS0+
cmVnX3NldCk7CgoJCXN3aXRjaCAoZndfc3RhdGUpIHsKCgkJY2FzZSBNRklfU1RBVEVfRkFVTFQ6
CgoJCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRlcgaW4gRkFVTFQgc3RhdGUhIVxuIik7
CgkJCXJldHVybiAtRU5PREVWOwoKCQljYXNlIE1GSV9TVEFURV9XQUlUX0hBTkRTSEFLRToKCQkJ
LyoKCQkJICogU2V0IHRoZSBDTFIgYml0IGluIGluYm91bmQgZG9vcmJlbGwKCQkJICovCgkJCWlm
ICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQoJCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3
M1NLSU5OWSkgfHwKCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CgkJCQlQQ0lfREVWSUNF
X0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewoKCQkJCXdyaXRlbCgKCQkJCSAgTUZJX0lOSVRfQ0xF
QVJfSEFORFNIQUtFfE1GSV9JTklUX0hPVFBMVUcsCgkJCQkgICZpbnN0YW5jZS0+cmVnX3NldC0+
cmVzZXJ2ZWRfMFswXSk7CgkJCX0gZWxzZSB7CgkJCQl3cml0ZWwoCgkJCQkgICAgTUZJX0lOSVRf
Q0xFQVJfSEFORFNIQUtFfE1GSV9JTklUX0hPVFBMVUcsCgkJCQkJJmluc3RhbmNlLT5yZWdfc2V0
LT5pbmJvdW5kX2Rvb3JiZWxsKTsKCQkJfQoKCQkJbWF4X3dhaXQgPSBNRUdBU0FTX1JFU0VUX1dB
SVRfVElNRTsKCQkJY3VyX3N0YXRlID0gTUZJX1NUQVRFX1dBSVRfSEFORFNIQUtFOwoJCQlicmVh
azsKCgkJY2FzZSBNRklfU1RBVEVfQk9PVF9NRVNTQUdFX1BFTkRJTkc6CgkJCWlmICgoaW5zdGFu
Y2UtPnBkZXYtPmRldmljZSA9PQoJCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkg
fHwKCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KCQkJCVBDSV9ERVZJQ0VfSURfTFNJX1NB
UzAwNzFTS0lOTlkpKSB7CgkJCQl3cml0ZWwoTUZJX0lOSVRfSE9UUExVRywKCQkJCSZpbnN0YW5j
ZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFswXSk7CgkJCX0gZWxzZQoJCQkJd3JpdGVsKE1GSV9JTklU
X0hPVFBMVUcsCgkJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKCgkJ
CW1heF93YWl0ID0gTUVHQVNBU19SRVNFVF9XQUlUX1RJTUU7CgkJCWN1cl9zdGF0ZSA9IE1GSV9T
VEFURV9CT09UX01FU1NBR0VfUEVORElORzsKCQkJYnJlYWs7CgoJCWNhc2UgTUZJX1NUQVRFX09Q
RVJBVElPTkFMOgoJCQkvKgoJCQkgKiBCcmluZyBpdCB0byBSRUFEWSBzdGF0ZTsgYXNzdW1pbmcg
bWF4IHdhaXQgMTAgc2VjcwoJCQkgKi8KCQkJaW5zdGFuY2UtPmluc3RhbmNldC0+ZGlzYWJsZV9p
bnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKCQkJaWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
CgkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5ZKSB8fAoJCQkJKGluc3RhbmNlLT5w
ZGV2LT5kZXZpY2UgPT0KCQkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpKSB7CgkJ
CQl3cml0ZWwoTUZJX1JFU0VUX0ZMQUdTLAoJCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2
ZWRfMFswXSk7CgkJCX0gZWxzZQoJCQkJd3JpdGVsKE1GSV9SRVNFVF9GTEFHUywKCQkJCQkmaW5z
dGFuY2UtPnJlZ19zZXQtPmluYm91bmRfZG9vcmJlbGwpOwoKCQkJbWF4X3dhaXQgPSBNRUdBU0FT
X1JFU0VUX1dBSVRfVElNRTsKCQkJY3VyX3N0YXRlID0gTUZJX1NUQVRFX09QRVJBVElPTkFMOwoJ
CQlicmVhazsKCgkJY2FzZSBNRklfU1RBVEVfVU5ERUZJTkVEOgoJCQkvKgoJCQkgKiBUaGlzIHN0
YXRlIHNob3VsZCBub3QgbGFzdCBmb3IgbW9yZSB0aGFuIDIgc2Vjb25kcwoJCQkgKi8KCQkJbWF4
X3dhaXQgPSBNRUdBU0FTX1JFU0VUX1dBSVRfVElNRTsKCQkJY3VyX3N0YXRlID0gTUZJX1NUQVRF
X1VOREVGSU5FRDsKCQkJYnJlYWs7CgoJCWNhc2UgTUZJX1NUQVRFX0JCX0lOSVQ6CgkJCW1heF93
YWl0ID0gTUVHQVNBU19SRVNFVF9XQUlUX1RJTUU7CgkJCWN1cl9zdGF0ZSA9IE1GSV9TVEFURV9C
Ql9JTklUOwoJCQlicmVhazsKCgkJY2FzZSBNRklfU1RBVEVfRldfSU5JVDoKCQkJbWF4X3dhaXQg
PSBNRUdBU0FTX1JFU0VUX1dBSVRfVElNRTsKCQkJY3VyX3N0YXRlID0gTUZJX1NUQVRFX0ZXX0lO
SVQ7CgkJCWJyZWFrOwoKCQljYXNlIE1GSV9TVEFURV9GV19JTklUXzI6CgkJCW1heF93YWl0ID0g
TUVHQVNBU19SRVNFVF9XQUlUX1RJTUU7CgkJCWN1cl9zdGF0ZSA9IE1GSV9TVEFURV9GV19JTklU
XzI7CgkJCWJyZWFrOwoKCQljYXNlIE1GSV9TVEFURV9ERVZJQ0VfU0NBTjoKCQkJbWF4X3dhaXQg
PSBNRUdBU0FTX1JFU0VUX1dBSVRfVElNRTsKCQkJY3VyX3N0YXRlID0gTUZJX1NUQVRFX0RFVklD
RV9TQ0FOOwoJCQlicmVhazsKCgkJY2FzZSBNRklfU1RBVEVfRkxVU0hfQ0FDSEU6CgkJCW1heF93
YWl0ID0gTUVHQVNBU19SRVNFVF9XQUlUX1RJTUU7CgkJCWN1cl9zdGF0ZSA9IE1GSV9TVEFURV9G
TFVTSF9DQUNIRTsKCQkJYnJlYWs7CgoJCWRlZmF1bHQ6CgkJCXByaW50ayhLRVJOX0RFQlVHICJt
ZWdhc2FzOiBVbmtub3duIHN0YXRlIDB4JXhcbiIsCgkJCSAgICAgICBmd19zdGF0ZSk7CgkJCXJl
dHVybiAtRU5PREVWOwoJCX0KCgkJLyoKCQkgKiBUaGUgY3VyX3N0YXRlIHNob3VsZCBub3QgbGFz
dCBmb3IgbW9yZSB0aGFuIG1heF93YWl0IHNlY3MKCQkgKi8KCQlmb3IgKGkgPSAwOyBpIDwgKG1h
eF93YWl0ICogMTAwMCk7IGkrKykgewoJCQlmd19zdGF0ZSA9IGluc3RhbmNlLT5pbnN0YW5jZXQt
PnJlYWRfZndfc3RhdHVzX3JlZyhpbnN0YW5jZS0+cmVnX3NldCkgJiAgCgkJCQkJTUZJX1NUQVRF
X01BU0sgOwoJCWN1cnJfYWJzX3N0YXRlID0KCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3
X3N0YXR1c19yZWcoaW5zdGFuY2UtPnJlZ19zZXQpOwoKCQkJaWYgKGFic19zdGF0ZSA9PSBjdXJy
X2Fic19zdGF0ZSkgewoJCQkJbXNsZWVwKDEpOwoJCQl9IGVsc2UKCQkJCWJyZWFrOwoJCX0KCgkJ
LyoKCQkgKiBSZXR1cm4gZXJyb3IgaWYgZndfc3RhdGUgaGFzbid0IGNoYW5nZWQgYWZ0ZXIgbWF4
X3dhaXQKCQkgKi8KCQlpZiAoY3Vycl9hYnNfc3RhdGUgPT0gYWJzX3N0YXRlKSB7CgkJCXByaW50
ayhLRVJOX0RFQlVHICJGVyBzdGF0ZSBbJWRdIGhhc24ndCBjaGFuZ2VkICIKCQkJICAgICAgICJp
biAlZCBzZWNzXG4iLCBmd19zdGF0ZSwgbWF4X3dhaXQpOwoJCQlyZXR1cm4gLUVOT0RFVjsKCQl9
Cgl9CiAJcHJpbnRrKEtFUk5fSU5GTyAibWVnYXNhczogRlcgbm93IGluIFJlYWR5IHN0YXRlXG4i
KTsKCglyZXR1cm4gMDsKfQoKLyoqCiAqIG1lZ2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbCAtCURl
c3Ryb3kgdGhlIGNtZCBmcmFtZSBETUEgcG9vbAogKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29m
dCBzdGF0ZQogKi8Kc3RhdGljIHZvaWQgbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29sKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKewoJaW50IGk7Cgl1MzIgbWF4X2NtZCA9IGlu
c3RhbmNlLT5tYXhfZndfY21kczsKCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOwoKCWlmICghaW5z
dGFuY2UtPmZyYW1lX2RtYV9wb29sKQoJCXJldHVybjsKCgkvKgoJICogUmV0dXJuIGFsbCBmcmFt
ZXMgdG8gcG9vbAoJICovCglmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsrKSB7CgoJCWNtZCA9
IGluc3RhbmNlLT5jbWRfbGlzdFtpXTsKCgkJaWYgKGNtZC0+ZnJhbWUpCgkJCXBjaV9wb29sX2Zy
ZWUoaW5zdGFuY2UtPmZyYW1lX2RtYV9wb29sLCBjbWQtPmZyYW1lLAoJCQkJICAgICAgY21kLT5m
cmFtZV9waHlzX2FkZHIpOwoKCQlpZiAoY21kLT5zZW5zZSkKCQkJcGNpX3Bvb2xfZnJlZShpbnN0
YW5jZS0+c2Vuc2VfZG1hX3Bvb2wsIGNtZC0+c2Vuc2UsCgkJCQkgICAgICBjbWQtPnNlbnNlX3Bo
eXNfYWRkcik7Cgl9CgoJLyoKCSAqIE5vdyBkZXN0cm95IHRoZSBwb29sIGl0c2VsZgoJICovCglw
Y2lfcG9vbF9kZXN0cm95KGluc3RhbmNlLT5mcmFtZV9kbWFfcG9vbCk7CglwY2lfcG9vbF9kZXN0
cm95KGluc3RhbmNlLT5zZW5zZV9kbWFfcG9vbCk7CgoJaW5zdGFuY2UtPmZyYW1lX2RtYV9wb29s
ID0gTlVMTDsKCWluc3RhbmNlLT5zZW5zZV9kbWFfcG9vbCA9IE5VTEw7Cn0KCi8qKgogKiBtZWdh
c2FzX2NyZWF0ZV9mcmFtZV9wb29sIC0JQ3JlYXRlcyBETUEgcG9vbCBmb3IgY21kIGZyYW1lcwog
KiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqCiAqIEVhY2ggY29tbWFuZCBwYWNr
ZXQgaGFzIGFuIGVtYmVkZGVkIERNQSBtZW1vcnkgYnVmZmVyIHRoYXQgaXMgdXNlZCBmb3IKICog
ZmlsbGluZyBNRkkgZnJhbWUgYW5kIHRoZSBTRyBsaXN0IHRoYXQgaW1tZWRpYXRlbHkgZm9sbG93
cyB0aGUgZnJhbWUuIFRoaXMKICogZnVuY3Rpb24gY3JlYXRlcyB0aG9zZSBETUEgbWVtb3J5IGJ1
ZmZlcnMgZm9yIGVhY2ggY29tbWFuZCBwYWNrZXQgYnkgdXNpbmcKICogUENJIHBvb2wgZmFjaWxp
dHkuCiAqLwpzdGF0aWMgaW50IG1lZ2FzYXNfY3JlYXRlX2ZyYW1lX3Bvb2woc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlKQp7CglpbnQgaTsKCXUzMiBtYXhfY21kOwoJdTMyIHNnZV9z
ejsKCXUzMiBzZ2xfc3o7Cgl1MzIgdG90YWxfc3o7Cgl1MzIgZnJhbWVfY291bnQ7CglzdHJ1Y3Qg
bWVnYXNhc19jbWQgKmNtZDsKCgltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOwoKCS8q
CgkgKiBTaXplIG9mIG91ciBmcmFtZSBpcyA2NCBieXRlcyBmb3IgTUZJIGZyYW1lLCBmb2xsb3dl
ZCBieSBtYXggU0cKCSAqIGVsZW1lbnRzIGFuZCBmaW5hbGx5IFNDU0lfU0VOU0VfQlVGRkVSU0la
RSBieXRlcyBmb3Igc2Vuc2UgYnVmZmVyCgkgKi8KCXNnZV9zeiA9IChJU19ETUE2NCkgPyBzaXpl
b2Yoc3RydWN0IG1lZ2FzYXNfc2dlNjQpIDoKCSAgICBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfc2dl
MzIpOwoKCWlmIChpbnN0YW5jZS0+ZmxhZ19pZWVlKSB7CgkJc2dlX3N6ID0gc2l6ZW9mKHN0cnVj
dCBtZWdhc2FzX3NnZV9za2lubnkpOwoJfQoKCS8qCgkgKiBDYWxjdWxhdGVkIHRoZSBudW1iZXIg
b2YgNjRieXRlIGZyYW1lcyByZXF1aXJlZCBmb3IgU0dMCgkgKi8KCXNnbF9zeiA9IHNnZV9zeiAq
IGluc3RhbmNlLT5tYXhfbnVtX3NnZTsKCWZyYW1lX2NvdW50ID0gKHNnbF9zeiArIE1FR0FNRklf
RlJBTUVfU0laRSAtIDEpIC8gTUVHQU1GSV9GUkFNRV9TSVpFOwoJZnJhbWVfY291bnQgPSAxNTsK
CgkvKgoJICogV2UgbmVlZCBvbmUgZXh0cmEgZnJhbWUgZm9yIHRoZSBNRkkgY29tbWFuZAoJICov
CglmcmFtZV9jb3VudCsrOwoKCXRvdGFsX3N6ID0gTUVHQU1GSV9GUkFNRV9TSVpFICogZnJhbWVf
Y291bnQ7CgkvKgoJICogVXNlIERNQSBwb29sIGZhY2lsaXR5IHByb3ZpZGVkIGJ5IFBDSSBsYXll
cgoJICovCglpbnN0YW5jZS0+ZnJhbWVfZG1hX3Bvb2wgPSBwY2lfcG9vbF9jcmVhdGUoIm1lZ2Fz
YXMgZnJhbWUgcG9vbCIsCgkJCQkJCSAgIGluc3RhbmNlLT5wZGV2LCB0b3RhbF9zeiwgNjQsCgkJ
CQkJCSAgIDApOwoKCWlmICghaW5zdGFuY2UtPmZyYW1lX2RtYV9wb29sKSB7CgkJcHJpbnRrKEtF
Uk5fREVCVUcgIm1lZ2FzYXM6IGZhaWxlZCB0byBzZXR1cCBmcmFtZSBwb29sXG4iKTsKCQlyZXR1
cm4gLUVOT01FTTsKCX0KCglpbnN0YW5jZS0+c2Vuc2VfZG1hX3Bvb2wgPSBwY2lfcG9vbF9jcmVh
dGUoIm1lZ2FzYXMgc2Vuc2UgcG9vbCIsCgkJCQkJCSAgIGluc3RhbmNlLT5wZGV2LCAxMjgsIDQs
IDApOwoKCWlmICghaW5zdGFuY2UtPnNlbnNlX2RtYV9wb29sKSB7CgkJcHJpbnRrKEtFUk5fREVC
VUcgIm1lZ2FzYXM6IGZhaWxlZCB0byBzZXR1cCBzZW5zZSBwb29sXG4iKTsKCgkJcGNpX3Bvb2xf
ZGVzdHJveShpbnN0YW5jZS0+ZnJhbWVfZG1hX3Bvb2wpOwoJCWluc3RhbmNlLT5mcmFtZV9kbWFf
cG9vbCA9IE5VTEw7CgoJCXJldHVybiAtRU5PTUVNOwoJfQoKCS8qCgkgKiBBbGxvY2F0ZSBhbmQg
YXR0YWNoIGEgZnJhbWUgdG8gZWFjaCBvZiB0aGUgY29tbWFuZHMgaW4gY21kX2xpc3QuCgkgKiBC
eSBtYWtpbmcgY21kLT5pbmRleCBhcyB0aGUgY29udGV4dCBpbnN0ZWFkIG9mIHRoZSAmY21kLCB3
ZSBjYW4KCSAqIGFsd2F5cyB1c2UgMzJiaXQgY29udGV4dCByZWdhcmRsZXNzIG9mIHRoZSBhcmNo
aXRlY3R1cmUKCSAqLwoJZm9yIChpID0gMDsgaSA8IG1heF9jbWQ7IGkrKykgewoKCQljbWQgPSBp
bnN0YW5jZS0+Y21kX2xpc3RbaV07CgoJCWNtZC0+ZnJhbWUgPSBwY2lfcG9vbF9hbGxvYyhpbnN0
YW5jZS0+ZnJhbWVfZG1hX3Bvb2wsCgkJCQkJICAgIEdGUF9LRVJORUwsICZjbWQtPmZyYW1lX3Bo
eXNfYWRkcik7CgoJCWNtZC0+c2Vuc2UgPSBwY2lfcG9vbF9hbGxvYyhpbnN0YW5jZS0+c2Vuc2Vf
ZG1hX3Bvb2wsCgkJCQkJICAgIEdGUF9LRVJORUwsICZjbWQtPnNlbnNlX3BoeXNfYWRkcik7CgoJ
CS8qCgkJICogbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29sKCkgdGFrZXMgY2FyZSBvZiBmcmVl
aW5nCgkJICogd2hhdGV2ZXIgaGFzIGJlZW4gYWxsb2NhdGVkCgkJICovCgkJaWYgKCFjbWQtPmZy
YW1lIHx8ICFjbWQtPnNlbnNlKSB7CgkJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBwY2lf
cG9vbF9hbGxvYyBmYWlsZWQgXG4iKTsKCQkJbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29sKGlu
c3RhbmNlKTsKCQkJcmV0dXJuIC1FTk9NRU07CgkJfQoKCQltZW1zZXQoY21kLT5mcmFtZSwgMCwg
dG90YWxfc3opOwoJCWNtZC0+ZnJhbWUtPmlvLmNvbnRleHQgPSBjbWQtPmluZGV4OwoJCWNtZC0+
ZnJhbWUtPmlvLnBhZF8wID0gMDsKCX0KCglyZXR1cm4gMDsKfQoKLyoqCiAqIG1lZ2FzYXNfZnJl
ZV9jbWRzIC0JRnJlZSBhbGwgdGhlIGNtZHMgaW4gdGhlIGZyZWUgY21kIHBvb2wKICogQGluc3Rh
bmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqLwpzdGF0aWMgdm9pZCBtZWdhc2FzX2ZyZWVfY21k
cyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCnsKCWludCBpOwoJLyogRmlyc3Qg
ZnJlZSB0aGUgTUZJIGZyYW1lIHBvb2wgKi8KCW1lZ2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbChp
bnN0YW5jZSk7CgoJLyogRnJlZSBhbGwgdGhlIGNvbW1hbmRzIGluIHRoZSBjbWRfbGlzdCAqLwoJ
Zm9yIChpID0gMDsgaSA8IGluc3RhbmNlLT5tYXhfZndfY21kczsgaSsrKQoJCWtmcmVlKGluc3Rh
bmNlLT5jbWRfbGlzdFtpXSk7CgoJLyogRnJlZSB0aGUgY21kX2xpc3QgYnVmZmVyIGl0c2VsZiAq
LwoJa2ZyZWUoaW5zdGFuY2UtPmNtZF9saXN0KTsKCWluc3RhbmNlLT5jbWRfbGlzdCA9IE5VTEw7
CgoJSU5JVF9MSVNUX0hFQUQoJmluc3RhbmNlLT5jbWRfcG9vbCk7Cn0KCi8qKgogKiBtZWdhc2Fz
X2FsbG9jX2NtZHMgLQlBbGxvY2F0ZXMgdGhlIGNvbW1hbmQgcGFja2V0cwogKiBAaW5zdGFuY2U6
CQlBZGFwdGVyIHNvZnQgc3RhdGUKICoKICogRWFjaCBjb21tYW5kIHRoYXQgaXMgaXNzdWVkIHRv
IHRoZSBGVywgd2hldGhlciBJTyBjb21tYW5kcyBmcm9tIHRoZSBPUyBvcgogKiBpbnRlcm5hbCBj
b21tYW5kcyBsaWtlIElPQ1RMcywgYXJlIHdyYXBwZWQgaW4gbG9jYWwgZGF0YSBzdHJ1Y3R1cmUg
Y2FsbGVkCiAqIG1lZ2FzYXNfY21kLiBUaGUgZnJhbWUgZW1iZWRkZWQgaW4gdGhpcyBtZWdhc2Fz
X2NtZCBpcyBhY3R1YWxseSBpc3N1ZWQgdG8KICogdGhlIEZXLgogKgogKiBFYWNoIGZyYW1lIGhh
cyBhIDMyLWJpdCBmaWVsZCBjYWxsZWQgY29udGV4dCAodGFnKS4gVGhpcyBjb250ZXh0IGlzIHVz
ZWQKICogdG8gZ2V0IGJhY2sgdGhlIG1lZ2FzYXNfY21kIGZyb20gdGhlIGZyYW1lIHdoZW4gYSBm
cmFtZSBnZXRzIGNvbXBsZXRlZCBpbgogKiB0aGUgSVNSLiBUeXBpY2FsbHkgdGhlIGFkZHJlc3Mg
b2YgdGhlIG1lZ2FzYXNfY21kIGl0c2VsZiB3b3VsZCBiZSB1c2VkIGFzCiAqIHRoZSBjb250ZXh0
LiBCdXQgd2Ugd2FudGVkIHRvIGtlZXAgdGhlIGRpZmZlcmVuY2VzIGJldHdlZW4gMzIgYW5kIDY0
IGJpdAogKiBzeXN0ZW1zIHRvIHRoZSBtaW5pbnVtLiBXZSBhbHdheXMgdXNlIDMyIGJpdCBpbnRl
Z2VycyBmb3IgdGhlIGNvbnRleHQuIEluCiAqIHRoaXMgZHJpdmVyLCB0aGUgMzIgYml0IHZhbHVl
cyBhcmUgdGhlIGluZGljZXMgaW50byBhbiBhcnJheSBjbWRfbGlzdC4KICogVGhpcyBhcnJheSBp
cyB1c2VkIG9ubHkgdG8gbG9vayB1cCB0aGUgbWVnYXNhc19jbWQgZ2l2ZW4gdGhlIGNvbnRleHQu
IFRoZQogKiBmcmVlIGNvbW1hbmRzIHRoZW1zZWx2ZXMgYXJlIG1haW50YWluZWQgaW4gYSBsaW5r
ZWQgbGlzdCBjYWxsZWQgY21kX3Bvb2wuCiAqLwpzdGF0aWMgaW50IG1lZ2FzYXNfYWxsb2NfY21k
cyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCnsKCWludCBpOwoJaW50IGo7Cgl1
MzIgbWF4X2NtZDsKCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOwoKCW1heF9jbWQgPSBpbnN0YW5j
ZS0+bWF4X2Z3X2NtZHM7CgoJLyoKCSAqIGluc3RhbmNlLT5jbWRfbGlzdCBpcyBhbiBhcnJheSBv
ZiBzdHJ1Y3QgbWVnYXNhc19jbWQgcG9pbnRlcnMuCgkgKiBBbGxvY2F0ZSB0aGUgZHluYW1pYyBh
cnJheSBmaXJzdCBhbmQgdGhlbiBhbGxvY2F0ZSBpbmRpdmlkdWFsCgkgKiBjb21tYW5kcy4KCSAq
LwoJaW5zdGFuY2UtPmNtZF9saXN0ID0ga2NhbGxvYyhtYXhfY21kLCBzaXplb2Yoc3RydWN0IG1l
Z2FzYXNfY21kKiksIEdGUF9LRVJORUwpOwoKCWlmICghaW5zdGFuY2UtPmNtZF9saXN0KSB7CgkJ
cHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IG91dCBvZiBtZW1vcnlcbiIpOwoJCXJldHVybiAt
RU5PTUVNOwoJfQoKCglmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsrKSB7CgkJaW5zdGFuY2Ut
PmNtZF9saXN0W2ldID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IG1lZ2FzYXNfY21kKSwKCQkJCQkJ
R0ZQX0tFUk5FTCk7CgoJCWlmICghaW5zdGFuY2UtPmNtZF9saXN0W2ldKSB7CgoJCQlmb3IgKGog
PSAwOyBqIDwgaTsgaisrKQoJCQkJa2ZyZWUoaW5zdGFuY2UtPmNtZF9saXN0W2pdKTsKCgkJCWtm
cmVlKGluc3RhbmNlLT5jbWRfbGlzdCk7CgkJCWluc3RhbmNlLT5jbWRfbGlzdCA9IE5VTEw7CgoJ
CQlyZXR1cm4gLUVOT01FTTsKCQl9Cgl9CgoJLyoKCSAqIEFkZCBhbGwgdGhlIGNvbW1hbmRzIHRv
IGNvbW1hbmQgcG9vbCAoaW5zdGFuY2UtPmNtZF9wb29sKQoJICovCglmb3IgKGkgPSAwOyBpIDwg
bWF4X2NtZDsgaSsrKSB7CgkJY21kID0gaW5zdGFuY2UtPmNtZF9saXN0W2ldOwoJCW1lbXNldChj
bWQsIDAsIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19jbWQpKTsKCQljbWQtPmluZGV4ID0gaTsKCQlj
bWQtPnNjbWQgPSBOVUxMOwoJCWNtZC0+aW5zdGFuY2UgPSBpbnN0YW5jZTsKCgkJbGlzdF9hZGRf
dGFpbCgmY21kLT5saXN0LCAmaW5zdGFuY2UtPmNtZF9wb29sKTsKCX0KCgkvKgoJICogQ3JlYXRl
IGEgZnJhbWUgcG9vbCBhbmQgYXNzaWduIG9uZSBmcmFtZSB0byBlYWNoIGNtZAoJICovCglpZiAo
bWVnYXNhc19jcmVhdGVfZnJhbWVfcG9vbChpbnN0YW5jZSkpIHsKCQlwcmludGsoS0VSTl9ERUJV
RyAibWVnYXNhczogRXJyb3IgY3JlYXRpbmcgZnJhbWUgRE1BIHBvb2xcbiIpOwoJCW1lZ2FzYXNf
ZnJlZV9jbWRzKGluc3RhbmNlKTsKCX0KCglyZXR1cm4gMDsKfQoKLyoKICogbWVnYXNhc19nZXRf
cGRfbGlzdF9pbmZvIC0JUmV0dXJucyBGVydzIHBkX2xpc3Qgc3RydWN0dXJlCiAqIEBpbnN0YW5j
ZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqIEBwZF9saXN0OgkJCQlwZF9saXN0IHN0cnVjdHVy
ZQogKgogKiBJc3N1ZXMgYW4gaW50ZXJuYWwgY29tbWFuZCAoRENNRCkgdG8gZ2V0IHRoZSBGVydz
IGNvbnRyb2xsZXIgUEQKICogbGlzdCBzdHJ1Y3R1cmUuICBUaGlzIGluZm9ybWF0aW9uIGlzIG1h
aW5seSB1c2VkIHRvIGZpbmQgb3V0IFNZU1RFTQogKiBzdXBwb3J0ZWQgYnkgdGhlIEZXLgogKi8K
c3RhdGljIGludAptZWdhc2FzX2dldF9wZF9saXN0KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICpp
bnN0YW5jZSkKewoJaW50IHJldCA9IDAsIHBkX2luZGV4ID0gMDsKCXN0cnVjdCBtZWdhc2FzX2Nt
ZCAqY21kOwoJc3RydWN0IG1lZ2FzYXNfZGNtZF9mcmFtZSAqZGNtZDsKCXN0cnVjdCBNUl9QRF9M
SVNUICpjaTsKCXN0cnVjdCBNUl9QRF9BRERSRVNTICpwZF9hZGRyOwoJZG1hX2FkZHJfdCBjaV9o
ID0gMDsKCgljbWQgPSBtZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOwoKCWlmICghY21kKSB7CgkJ
cHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXMgKGdldF9wZF9saXN0KTogRmFpbGVkIHRvIGdldCBj
bWRcbiIpOwoJCXJldHVybiAtRU5PTUVNOwoJfQoKCWRjbWQgPSAmY21kLT5mcmFtZS0+ZGNtZDsK
CgljaSA9IHBjaV9hbGxvY19jb25zaXN0ZW50KGluc3RhbmNlLT5wZGV2LAoJCSAgTUVHQVNBU19N
QVhfUEQgKiBzaXplb2Yoc3RydWN0IE1SX1BEX0xJU1QpLCAmY2lfaCk7CgoJaWYgKCFjaSkgewoJ
CXByaW50ayhLRVJOX0RFQlVHICJGYWlsZWQgdG8gYWxsb2MgbWVtIGZvciBwZF9saXN0XG4iKTsK
CQltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNtZCk7CgkJcmV0dXJuIC1FTk9NRU07Cgl9
CgoJbWVtc2V0KGNpLCAwLCBzaXplb2YoKmNpKSk7CgltZW1zZXQoZGNtZC0+bWJveC5iLCAwLCBN
RklfTUJPWF9TSVpFKTsKCglkY21kLT5tYm94LmJbMF0gPSBNUl9QRF9RVUVSWV9UWVBFX0VYUE9T
RURfVE9fSE9TVDsKCWRjbWQtPm1ib3guYlsxXSA9IDA7CglkY21kLT5jbWQgPSBNRklfQ01EX0RD
TUQ7CglkY21kLT5jbWRfc3RhdHVzID0gMHhGRjsKCWRjbWQtPnNnZV9jb3VudCA9IDE7CglkY21k
LT5mbGFncyA9IE1GSV9GUkFNRV9ESVJfUkVBRDsKCWRjbWQtPnRpbWVvdXQgPSAwOwoJZGNtZC0+
cGFkXzAgPSAwOwoJZGNtZC0+ZGF0YV94ZmVyX2xlbiA9IE1FR0FTQVNfTUFYX1BEICogc2l6ZW9m
KHN0cnVjdCBNUl9QRF9MSVNUKTsKCWRjbWQtPm9wY29kZSA9IE1SX0RDTURfUERfTElTVF9RVUVS
WTsKCWRjbWQtPnNnbC5zZ2UzMlswXS5waHlzX2FkZHIgPSBjaV9oOwoJZGNtZC0+c2dsLnNnZTMy
WzBdLmxlbmd0aCA9IE1FR0FTQVNfTUFYX1BEICogc2l6ZW9mKHN0cnVjdCBNUl9QRF9MSVNUKTsK
CglpZiAoIW1lZ2FzYXNfaXNzdWVfcG9sbGVkKGluc3RhbmNlLCBjbWQpKSB7CgkJcmV0ID0gMDsK
CX0gZWxzZSB7CgkJcmV0ID0gLTE7Cgl9CgoJLyoKCSogdGhlIGZvbGxvd2luZyBmdW5jdGlvbiB3
aWxsIGdldCB0aGUgaW5zdGFuY2UgUEQgTElTVC4KCSovCgoJcGRfYWRkciA9IGNpLT5hZGRyOwoK
CWlmICggcmV0ID09IDAgJiYKCQkoY2ktPmNvdW50IDwKCQkgIChNRUdBU0FTX01BWF9QRF9DSEFO
TkVMUyAqIE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTCkpKSB7CgoJCW1lbXNldChpbnN0YW5j
ZS0+cGRfbGlzdCwgMCwKCQkJTUVHQVNBU19NQVhfUEQgKiBzaXplb2Yoc3RydWN0IG1lZ2FzYXNf
cGRfbGlzdCkpOwoKCQlmb3IgKHBkX2luZGV4ID0gMDsgcGRfaW5kZXggPCBjaS0+Y291bnQ7IHBk
X2luZGV4KyspIHsKCgkJCWluc3RhbmNlLT5wZF9saXN0W3BkX2FkZHItPmRldmljZUlkXS50aWQJ
PQoJCQkJCQkJcGRfYWRkci0+ZGV2aWNlSWQ7CgkJCWluc3RhbmNlLT5wZF9saXN0W3BkX2FkZHIt
PmRldmljZUlkXS5kcml2ZVR5cGUJPQoJCQkJCQkJcGRfYWRkci0+c2NzaURldlR5cGU7CgkJCWlu
c3RhbmNlLT5wZF9saXN0W3BkX2FkZHItPmRldmljZUlkXS5kcml2ZVN0YXRlCT0KCQkJCQkJCU1S
X1BEX1NUQVRFX1NZU1RFTTsKCQkJcGRfYWRkcisrOwoJCX0KCX0KCglwY2lfZnJlZV9jb25zaXN0
ZW50KGluc3RhbmNlLT5wZGV2LAoJCQkJTUVHQVNBU19NQVhfUEQgKiBzaXplb2Yoc3RydWN0IE1S
X1BEX0xJU1QpLAoJCQkJY2ksIGNpX2gpOwoJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBj
bWQpOwoKCXJldHVybiByZXQ7Cn0KCi8qCiAqIG1lZ2FzYXNfZ2V0X2xkX2xpc3RfaW5mbyAtCVJl
dHVybnMgRlcncyBsZF9saXN0IHN0cnVjdHVyZQogKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29m
dCBzdGF0ZQogKiBAbGRfbGlzdDoJCQkJbGRfbGlzdCBzdHJ1Y3R1cmUKICoKICogSXNzdWVzIGFu
IGludGVybmFsIGNvbW1hbmQgKERDTUQpIHRvIGdldCB0aGUgRlcncyBjb250cm9sbGVyIFBECiAq
IGxpc3Qgc3RydWN0dXJlLiAgVGhpcyBpbmZvcm1hdGlvbiBpcyBtYWlubHkgdXNlZCB0byBmaW5k
IG91dCBTWVNURU0KICogc3VwcG9ydGVkIGJ5IHRoZSBGVy4KICovCnN0YXRpYyBpbnQKbWVnYXNh
c19nZXRfbGRfbGlzdChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCnsKCWludCBy
ZXQgPSAwLCBsZF9pbmRleCA9IDAsIGlkcyA9IDA7CglzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsK
CXN0cnVjdCBtZWdhc2FzX2RjbWRfZnJhbWUgKmRjbWQ7CglzdHJ1Y3QgTVJfTERfTElTVCAqY2k7
CglkbWFfYWRkcl90IGNpX2ggPSAwOwoKCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7
CgoJaWYgKCFjbWQpIHsKCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhc19nZXRfbGRfbGlzdDog
RmFpbGVkIHRvIGdldCBjbWRcbiIpOwoJCXJldHVybiAtRU5PTUVNOwoJfQoKCWRjbWQgPSAmY21k
LT5mcmFtZS0+ZGNtZDsKCgljaSA9IHBjaV9hbGxvY19jb25zaXN0ZW50KGluc3RhbmNlLT5wZGV2
LAoJCQkJc2l6ZW9mKHN0cnVjdCBNUl9MRF9MSVNUKSwKCQkJCSZjaV9oKTsKCglpZiAoIWNpKSB7
CgkJcHJpbnRrKEtFUk5fREVCVUcgIkZhaWxlZCB0byBhbGxvYyBtZW0gaW4gZ2V0X2xkX2xpc3Rc
biIpOwoJCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwgY21kKTsKCQlyZXR1cm4gLUVOT01F
TTsKCX0KCgltZW1zZXQoY2ksIDAsIHNpemVvZigqY2kpKTsKCW1lbXNldChkY21kLT5tYm94LmIs
IDAsIE1GSV9NQk9YX1NJWkUpOwoKCWRjbWQtPmNtZCA9IE1GSV9DTURfRENNRDsKCWRjbWQtPmNt
ZF9zdGF0dXMgPSAweEZGOwoJZGNtZC0+c2dlX2NvdW50ID0gMTsKCWRjbWQtPmZsYWdzID0gTUZJ
X0ZSQU1FX0RJUl9SRUFEOwoJZGNtZC0+dGltZW91dCA9IDA7CglkY21kLT5kYXRhX3hmZXJfbGVu
ID0gc2l6ZW9mKHN0cnVjdCBNUl9MRF9MSVNUKTsKCWRjbWQtPm9wY29kZSA9IE1SX0RDTURfTERf
R0VUX0xJU1Q7CglkY21kLT5zZ2wuc2dlMzJbMF0ucGh5c19hZGRyID0gY2lfaDsKCWRjbWQtPnNn
bC5zZ2UzMlswXS5sZW5ndGggPSBzaXplb2Yoc3RydWN0IE1SX0xEX0xJU1QpOwoJZGNtZC0+cGFk
XzAgID0gMDsKCglpZiAoIW1lZ2FzYXNfaXNzdWVfcG9sbGVkKGluc3RhbmNlLCBjbWQpKSB7CgkJ
cmV0ID0gMDsKCX0gZWxzZSB7CgkJcmV0ID0gLTE7Cgl9CgoJLyogdGhlIGZvbGxvd2luZyBmdW5j
dGlvbiB3aWxsIGdldCB0aGUgaW5zdGFuY2UgUEQgTElTVCAqLwoKCWlmICgocmV0ID09IDApICYm
IChjaS0+bGRDb3VudCA8PSBNQVhfTE9HSUNBTF9EUklWRVMpKSB7CgkJbWVtc2V0KGluc3RhbmNl
LT5sZF9pZHMsIDB4ZmYsIE1FR0FTQVNfTUFYX0xEX0lEUyk7CgoJCWZvciAobGRfaW5kZXggPSAw
OyBsZF9pbmRleCA8IGNpLT5sZENvdW50OyBsZF9pbmRleCsrKSB7CgkJCWlmIChjaS0+bGRMaXN0
W2xkX2luZGV4XS5zdGF0ZSAhPSAwKSB7CgkJCQlpZHMgPSBjaS0+bGRMaXN0W2xkX2luZGV4XS5y
ZWYudGFyZ2V0SWQ7CgkJCQlpbnN0YW5jZS0+bGRfaWRzW2lkc10gPQoJCQkJCWNpLT5sZExpc3Rb
bGRfaW5kZXhdLnJlZi50YXJnZXRJZDsKCQkJfQoJCX0KCX0KCglwY2lfZnJlZV9jb25zaXN0ZW50
KGluc3RhbmNlLT5wZGV2LAoJCQkJc2l6ZW9mKHN0cnVjdCBNUl9MRF9MSVNUKSwKCQkJCWNpLAoJ
CQkJY2lfaCk7CgoJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwoJcmV0dXJuIHJl
dDsKfQoKLyoqCiAqIG1lZ2FzYXNfZ2V0X2NvbnRyb2xsZXJfaW5mbyAtCVJldHVybnMgRlcncyBj
b250cm9sbGVyIHN0cnVjdHVyZQogKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQog
KiBAY3RybF9pbmZvOgkJCQlDb250cm9sbGVyIGluZm9ybWF0aW9uIHN0cnVjdHVyZQogKgogKiBJ
c3N1ZXMgYW4gaW50ZXJuYWwgY29tbWFuZCAoRENNRCkgdG8gZ2V0IHRoZSBGVydzIGNvbnRyb2xs
ZXIgc3RydWN0dXJlLgogKiBUaGlzIGluZm9ybWF0aW9uIGlzIG1haW5seSB1c2VkIHRvIGZpbmQg
b3V0IHRoZSBtYXhpbXVtIElPIHRyYW5zZmVyIHBlcgogKiBjb21tYW5kIHN1cHBvcnRlZCBieSB0
aGUgRlcuCiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfZ2V0X2N0cmxfaW5mbyhzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UsCgkJICAgICAgc3RydWN0IG1lZ2FzYXNfY3RybF9pbmZvICpj
dHJsX2luZm8pCnsKCWludCByZXQgPSAwOwoJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CglzdHJ1
Y3QgbWVnYXNhc19kY21kX2ZyYW1lICpkY21kOwoJc3RydWN0IG1lZ2FzYXNfY3RybF9pbmZvICpj
aTsKCWRtYV9hZGRyX3QgY2lfaCA9IDA7CgoJY21kID0gbWVnYXNhc19nZXRfY21kKGluc3RhbmNl
KTsKCglpZiAoIWNtZCkgewoJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8g
Z2V0IGEgZnJlZSBjbWRcbiIpOwoJCXJldHVybiAtRU5PTUVNOwoJfQoKCWRjbWQgPSAmY21kLT5m
cmFtZS0+ZGNtZDsKCgljaSA9IHBjaV9hbGxvY19jb25zaXN0ZW50KGluc3RhbmNlLT5wZGV2LAoJ
CQkJICBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfY3RybF9pbmZvKSwgJmNpX2gpOwoKCWlmICghY2kp
IHsKCQlwcmludGsoS0VSTl9ERUJVRyAiRmFpbGVkIHRvIGFsbG9jIG1lbSBmb3IgY3RybCBpbmZv
XG4iKTsKCQltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNtZCk7CgkJcmV0dXJuIC1FTk9N
RU07Cgl9CgoJbWVtc2V0KGNpLCAwLCBzaXplb2YoKmNpKSk7CgltZW1zZXQoZGNtZC0+bWJveC5i
LCAwLCBNRklfTUJPWF9TSVpFKTsKCglkY21kLT5jbWQgPSBNRklfQ01EX0RDTUQ7CglkY21kLT5j
bWRfc3RhdHVzID0gMHhGRjsKCWRjbWQtPnNnZV9jb3VudCA9IDE7CglkY21kLT5mbGFncyA9IE1G
SV9GUkFNRV9ESVJfUkVBRDsKCWRjbWQtPnRpbWVvdXQgPSAwOwoJZGNtZC0+cGFkXzAgPSAwOwoJ
ZGNtZC0+ZGF0YV94ZmVyX2xlbiA9IHNpemVvZihzdHJ1Y3QgbWVnYXNhc19jdHJsX2luZm8pOwoJ
ZGNtZC0+b3Bjb2RlID0gTVJfRENNRF9DVFJMX0dFVF9JTkZPOwoJZGNtZC0+c2dsLnNnZTMyWzBd
LnBoeXNfYWRkciA9IGNpX2g7CglkY21kLT5zZ2wuc2dlMzJbMF0ubGVuZ3RoID0gc2l6ZW9mKHN0
cnVjdCBtZWdhc2FzX2N0cmxfaW5mbyk7CgoJaWYgKCFtZWdhc2FzX2lzc3VlX3BvbGxlZChpbnN0
YW5jZSwgY21kKSkgewoJCXJldCA9IDA7CgkJbWVtY3B5KGN0cmxfaW5mbywgY2ksIHNpemVvZihz
dHJ1Y3QgbWVnYXNhc19jdHJsX2luZm8pKTsKCX0gZWxzZSB7CgkJcmV0ID0gLTE7Cgl9CgoJcGNp
X2ZyZWVfY29uc2lzdGVudChpbnN0YW5jZS0+cGRldiwgc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2N0
cmxfaW5mbyksCgkJCSAgICBjaSwgY2lfaCk7CgoJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNl
LCBjbWQpOwoJcmV0dXJuIHJldDsKfQoKLyoqCiAqIG1lZ2FzYXNfaXNzdWVfaW5pdF9tZmkgLQlJ
bml0aWFsaXplcyB0aGUgRlcKICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqCiAq
IElzc3VlcyB0aGUgSU5JVCBNRkkgY21kCiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfaXNzdWVfaW5p
dF9tZmkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQp7Cgl1MzIgY29udGV4dDsK
CglzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKCglzdHJ1Y3QgbWVnYXNhc19pbml0X2ZyYW1lICpp
bml0X2ZyYW1lOwoJc3RydWN0IG1lZ2FzYXNfaW5pdF9xdWV1ZV9pbmZvICppbml0cV9pbmZvOwoJ
ZG1hX2FkZHJfdCBpbml0X2ZyYW1lX2g7CglkbWFfYWRkcl90IGluaXRxX2luZm9faDsKCgkvKgoJ
ICogUHJlcGFyZSBhIGluaXQgZnJhbWUuIE5vdGUgdGhlIGluaXQgZnJhbWUgcG9pbnRzIHRvIHF1
ZXVlIGluZm8KCSAqIHN0cnVjdHVyZS4gRWFjaCBmcmFtZSBoYXMgU0dMIGFsbG9jYXRlZCBhZnRl
ciBmaXJzdCA2NCBieXRlcy4gRm9yCgkgKiB0aGlzIGZyYW1lIC0gc2luY2Ugd2UgZG9uJ3QgbmVl
ZCBhbnkgU0dMIC0gd2UgdXNlIFNHTCdzIHNwYWNlIGFzCgkgKiBxdWV1ZSBpbmZvIHN0cnVjdHVy
ZQoJICoKCSAqIFdlIHdpbGwgbm90IGdldCBhIE5VTEwgY29tbWFuZCBiZWxvdy4gV2UganVzdCBj
cmVhdGVkIHRoZSBwb29sLgoJICovCgljbWQgPSBtZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOwoK
CWluaXRfZnJhbWUgPSAoc3RydWN0IG1lZ2FzYXNfaW5pdF9mcmFtZSAqKWNtZC0+ZnJhbWU7Cglp
bml0cV9pbmZvID0gKHN0cnVjdCBtZWdhc2FzX2luaXRfcXVldWVfaW5mbyAqKQoJCSgodW5zaWdu
ZWQgbG9uZylpbml0X2ZyYW1lICsgNjQpOwoKCWluaXRfZnJhbWVfaCA9IGNtZC0+ZnJhbWVfcGh5
c19hZGRyOwoJaW5pdHFfaW5mb19oID0gaW5pdF9mcmFtZV9oICsgNjQ7CgoJY29udGV4dCA9IGlu
aXRfZnJhbWUtPmNvbnRleHQ7CgltZW1zZXQoaW5pdF9mcmFtZSwgMCwgTUVHQU1GSV9GUkFNRV9T
SVpFKTsKCW1lbXNldChpbml0cV9pbmZvLCAwLCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfaW5pdF9x
dWV1ZV9pbmZvKSk7Cglpbml0X2ZyYW1lLT5jb250ZXh0ID0gY29udGV4dDsKCglpbml0cV9pbmZv
LT5yZXBseV9xdWV1ZV9lbnRyaWVzID0gaW5zdGFuY2UtPm1heF9md19jbWRzICsgMTsKCWluaXRx
X2luZm8tPnJlcGx5X3F1ZXVlX3N0YXJ0X3BoeXNfYWRkcl9sbyA9IGluc3RhbmNlLT5yZXBseV9x
dWV1ZV9oOwoKCWluaXRxX2luZm8tPnByb2R1Y2VyX2luZGV4X3BoeXNfYWRkcl9sbyA9IGluc3Rh
bmNlLT5wcm9kdWNlcl9oOwoJaW5pdHFfaW5mby0+Y29uc3VtZXJfaW5kZXhfcGh5c19hZGRyX2xv
ID0gaW5zdGFuY2UtPmNvbnN1bWVyX2g7CgoJaW5pdF9mcmFtZS0+Y21kID0gTUZJX0NNRF9JTklU
OwoJaW5pdF9mcmFtZS0+Y21kX3N0YXR1cyA9IDB4RkY7Cglpbml0X2ZyYW1lLT5xdWV1ZV9pbmZv
X25ld19waHlzX2FkZHJfbG8gPSBpbml0cV9pbmZvX2g7CgoJaW5pdF9mcmFtZS0+ZGF0YV94ZmVy
X2xlbiA9IHNpemVvZihzdHJ1Y3QgbWVnYXNhc19pbml0X3F1ZXVlX2luZm8pOwoKCS8qCgkgKiBk
aXNhYmxlIHRoZSBpbnRyIGJlZm9yZSBmaXJpbmcgdGhlIGluaXQgZnJhbWUgdG8gRlcKCSAqLwoJ
aW5zdGFuY2UtPmluc3RhbmNldC0+ZGlzYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKCgkv
KgoJICogSXNzdWUgdGhlIGluaXQgZnJhbWUgaW4gcG9sbGVkIG1vZGUKCSAqLwoKCWlmIChtZWdh
c2FzX2lzc3VlX3BvbGxlZChpbnN0YW5jZSwgY21kKSkgewoJCXByaW50ayhLRVJOX0VSUiAibWVn
YXNhczogRmFpbGVkIHRvIGluaXQgZmlybXdhcmVcbiIpOwoJCW1lZ2FzYXNfcmV0dXJuX2NtZChp
bnN0YW5jZSwgY21kKTsKCQlnb3RvIGZhaWxfZndfaW5pdDsKCX0KCgltZWdhc2FzX3JldHVybl9j
bWQoaW5zdGFuY2UsIGNtZCk7CgoJcmV0dXJuIDA7CgpmYWlsX2Z3X2luaXQ6CglyZXR1cm4gLUVJ
TlZBTDsKfQoKLyoqCiAqIG1lZ2FzYXNfc3RhcnRfdGltZXIgLSBJbml0aWFsaXplcyBhIHRpbWVy
IG9iamVjdAogKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKICogQHRpbWVyOgkJdGlt
ZXIgb2JqZWN0IHRvIGJlIGluaXRpYWxpemVkCiAqIEBmbjoJCQl0aW1lciBmdW5jdGlvbgogKiBA
aW50ZXJ2YWw6CQl0aW1lIGludGVydmFsIGJldHdlZW4gdGltZXIgZnVuY3Rpb24gY2FsbAogKi8K
c3RhdGljIGlubGluZSB2b2lkCm1lZ2FzYXNfc3RhcnRfdGltZXIoc3RydWN0IG1lZ2FzYXNfaW5z
dGFuY2UgKmluc3RhbmNlLAoJCQlzdHJ1Y3QgdGltZXJfbGlzdCAqdGltZXIsCgkJCXZvaWQgKmZu
LCB1bnNpZ25lZCBsb25nIGludGVydmFsKQp7Cglpbml0X3RpbWVyKHRpbWVyKTsKCXRpbWVyLT5l
eHBpcmVzID0gamlmZmllcyArIGludGVydmFsOwoJdGltZXItPmRhdGEgPSAodW5zaWduZWQgbG9u
ZylpbnN0YW5jZTsKCXRpbWVyLT5mdW5jdGlvbiA9IGZuOwoJYWRkX3RpbWVyKHRpbWVyKTsKfQoK
LyoqCiAqIG1lZ2FzYXNfaW9fY29tcGxldGlvbl90aW1lciAtIFRpbWVyIGZuCiAqIEBpbnN0YW5j
ZV9hZGRyOglBZGRyZXNzIG9mIGFkYXB0ZXIgc29mdCBzdGF0ZQogKgogKiBTY2hlZHVsZXMgdGFz
a2xldCBmb3IgY21kIGNvbXBsZXRpb24KICogaWYgcG9sbF9tb2RlX2lvIGlzIHNldAogKi8Kc3Rh
dGljIHZvaWQKbWVnYXNhc19pb19jb21wbGV0aW9uX3RpbWVyKHVuc2lnbmVkIGxvbmcgaW5zdGFu
Y2VfYWRkcikKewoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlID0KCQkJKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICopaW5zdGFuY2VfYWRkcjsKCglpZiAoYXRvbWljX3JlYWQoJmlu
c3RhbmNlLT5md19vdXRzdGFuZGluZykpCgkJdGFza2xldF9zY2hlZHVsZSgmaW5zdGFuY2UtPmlz
cl90YXNrbGV0KTsKCgkvKiBSZXN0YXJ0IHRpbWVyICovCglpZiAocG9sbF9tb2RlX2lvKQoJCW1v
ZF90aW1lcigmaW5zdGFuY2UtPmlvX2NvbXBsZXRpb25fdGltZXIsCgkJCWppZmZpZXMgKyBNRUdB
U0FTX0NPTVBMRVRJT05fVElNRVJfSU5URVJWQUwpOwp9CgovKioKICogbWVnYXNhc19pbml0X21m
aSAtCUluaXRpYWxpemVzIHRoZSBGVwogKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUK
ICoKICogVGhpcyBpcyB0aGUgbWFpbiBmdW5jdGlvbiBmb3IgaW5pdGlhbGl6aW5nIE1GSSBmaXJt
d2FyZS4KICovCnN0YXRpYyBpbnQgbWVnYXNhc19pbml0X21maShzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpCnsKCXUzMiBjb250ZXh0X3N6OwoJdTMyIHJlcGx5X3Ffc3o7Cgl1MzIg
bWF4X3NlY3RvcnNfMTsKCXUzMiBtYXhfc2VjdG9yc18yOwoJdTMyIHRtcF9zZWN0b3JzOwoJc3Ry
dWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ19zZXQ7CglzdHJ1Y3QgbWVnYXNh
c19jdHJsX2luZm8gKmN0cmxfaW5mbzsKCS8qCgkgKiBNYXAgdGhlIG1lc3NhZ2UgcmVnaXN0ZXJz
CgkgKi8KCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9T
QVMxMDc4R0VOMikgfHwKCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lE
X0xTSV9TQVMwMDcxU0tJTk5ZKSB8fAoJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9E
RVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlkpIHx8CgkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2Ug
PT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3OUdFTjIpKSB7CgkJaW5zdGFuY2UtPmJhc2VfYWRk
ciA9IHBjaV9yZXNvdXJjZV9zdGFydChpbnN0YW5jZS0+cGRldiwgMSk7Cgl9IGVsc2UgewoJCWlu
c3RhbmNlLT5iYXNlX2FkZHIgPSBwY2lfcmVzb3VyY2Vfc3RhcnQoaW5zdGFuY2UtPnBkZXYsIDAp
OwoJfQoKCWlmIChwY2lfcmVxdWVzdF9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNlLT5wZGV2LAoJ
CXBjaV9zZWxlY3RfYmFycyhpbnN0YW5jZS0+cGRldiwgSU9SRVNPVVJDRV9NRU0pLAoJCSJtZWdh
c2FzOiBMU0kiKSkgewoJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBJTyBtZW1vcnkgcmVn
aW9uIGJ1c3khXG4iKTsKCQlyZXR1cm4gLUVCVVNZOwoJfQoKCWluc3RhbmNlLT5yZWdfc2V0ID0g
aW9yZW1hcF9ub2NhY2hlKGluc3RhbmNlLT5iYXNlX2FkZHIsIDgxOTIpOwoKCWlmICghaW5zdGFu
Y2UtPnJlZ19zZXQpIHsKCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRmFpbGVkIHRvIG1h
cCBJTyBtZW1cbiIpOwoJCWdvdG8gZmFpbF9pb3JlbWFwOwoJfQoKCXJlZ19zZXQgPSBpbnN0YW5j
ZS0+cmVnX3NldDsKCglzd2l0Y2goaW5zdGFuY2UtPnBkZXYtPmRldmljZSkKCXsKCQljYXNlIFBD
SV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhSOgoJCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfU0FTMTA3
OERFOgoJCQlpbnN0YW5jZS0+aW5zdGFuY2V0ID0gJm1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGVf
cHBjOwoJCQlicmVhazsKCQljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhHRU4yOgoJCWNh
c2UgUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3OUdFTjI6CgkJCWluc3RhbmNlLT5pbnN0YW5jZXQg
PSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9nZW4yOwoJCQlicmVhazsKCQljYXNlIFBDSV9E
RVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlk6CgkJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMw
MDcxU0tJTk5ZOgoJCQlpbnN0YW5jZS0+aW5zdGFuY2V0ID0gJm1lZ2FzYXNfaW5zdGFuY2VfdGVt
cGxhdGVfc2tpbm55OwoJCQlicmVhazsKCQljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNjRS
OgoJCWNhc2UgUENJX0RFVklDRV9JRF9ERUxMX1BFUkM1OgoJCWRlZmF1bHQ6CgkJCWluc3RhbmNl
LT5pbnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV94c2NhbGU7CgkJCWJyZWFr
OwoJfQoKCS8qCgkgKiBXZSBleHBlY3QgdGhlIEZXIHN0YXRlIHRvIGJlIFJFQURZCgkgKi8KCWlm
IChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFuY2UpKQoJCWdvdG8gZmFpbF9yZWFk
eV9zdGF0ZTsKCgkvKgoJICogR2V0IHZhcmlvdXMgb3BlcmF0aW9uYWwgcGFyYW1ldGVycyBmcm9t
IHN0YXR1cyByZWdpc3RlcgoJICovCglpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgPSBpbnN0YW5jZS0+
aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcocmVnX3NldCkgJiAweDAwRkZGRjsKCS8qCgkg
KiBSZWR1Y2UgdGhlIG1heCBzdXBwb3J0ZWQgY21kcyBieSAxLiBUaGlzIGlzIHRvIGVuc3VyZSB0
aGF0IHRoZQoJICogcmVwbHlfcV9zeiAoMSBtb3JlIHRoYW4gdGhlIG1heCBjbWQgdGhhdCBkcml2
ZXIgbWF5IHNlbmQpCgkgKiBkb2VzIG5vdCBleGNlZWQgbWF4IGNtZHMgdGhhdCB0aGUgRlcgY2Fu
IHN1cHBvcnQKCSAqLwoJaW5zdGFuY2UtPm1heF9md19jbWRzID0gaW5zdGFuY2UtPm1heF9md19j
bWRzLTE7CglpbnN0YW5jZS0+bWF4X251bV9zZ2UgPSAoaW5zdGFuY2UtPmluc3RhbmNldC0+cmVh
ZF9md19zdGF0dXNfcmVnKHJlZ19zZXQpICYgMHhGRjAwMDApID4+IAoJCQkJCTB4MTA7CgkvKgoJ
ICogQ3JlYXRlIGEgcG9vbCBvZiBjb21tYW5kcwoJICovCglpZiAobWVnYXNhc19hbGxvY19jbWRz
KGluc3RhbmNlKSkKCQlnb3RvIGZhaWxfYWxsb2NfY21kczsKCgkvKgoJICogQWxsb2NhdGUgbWVt
b3J5IGZvciByZXBseSBxdWV1ZS4gTGVuZ3RoIG9mIHJlcGx5IHF1ZXVlIHNob3VsZAoJICogYmUg
X29uZV8gbW9yZSB0aGFuIHRoZSBtYXhpbXVtIGNvbW1hbmRzIGhhbmRsZWQgYnkgdGhlIGZpcm13
YXJlLgoJICoKCSAqIE5vdGU6IFdoZW4gRlcgY29tcGxldGVzIGNvbW1hbmRzLCBpdCBwbGFjZXMg
Y29ycmVzcG9uZGluZyBjb250ZXgKCSAqIHZhbHVlcyBpbiB0aGlzIGNpcmN1bGFyIHJlcGx5IHF1
ZXVlLiBUaGlzIGNpcmN1bGFyIHF1ZXVlIGlzIGEgZmFpcmx5CgkgKiB0eXBpY2FsIHByb2R1Y2Vy
LWNvbnN1bWVyIHF1ZXVlLiBGVyBpcyB0aGUgcHJvZHVjZXIgKG9mIGNvbXBsZXRlZAoJICogY29t
bWFuZHMpIGFuZCB0aGUgZHJpdmVyIGlzIHRoZSBjb25zdW1lci4KCSAqLwoJY29udGV4dF9zeiA9
IHNpemVvZih1MzIpOwoJcmVwbHlfcV9zeiA9IGNvbnRleHRfc3ogKiAoaW5zdGFuY2UtPm1heF9m
d19jbWRzICsgMSk7CgoJaW5zdGFuY2UtPnJlcGx5X3F1ZXVlID0gcGNpX2FsbG9jX2NvbnNpc3Rl
bnQoaW5zdGFuY2UtPnBkZXYsCgkJCQkJCSAgICAgcmVwbHlfcV9zeiwKCQkJCQkJICAgICAmaW5z
dGFuY2UtPnJlcGx5X3F1ZXVlX2gpOwoKCWlmICghaW5zdGFuY2UtPnJlcGx5X3F1ZXVlKSB7CgkJ
cHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IE91dCBvZiBETUEgbWVtIGZvciByZXBseSBxdWV1
ZVxuIik7CgkJZ290byBmYWlsX3JlcGx5X3F1ZXVlOwoJfQoKCWlmIChtZWdhc2FzX2lzc3VlX2lu
aXRfbWZpKGluc3RhbmNlKSkKCQlnb3RvIGZhaWxfZndfaW5pdDsKCglpbnN0YW5jZS0+Zndfc3Vw
cG9ydF9pZWVlID0gMDsKCWluc3RhbmNlLT5md19zdXBwb3J0X2llZWUgPQoJCShpbnN0YW5jZS0+
aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcocmVnX3NldCkgJgoJCTB4MDQwMDAwMDApOwoK
CXByaW50ayhLRVJOX05PVElDRSAibWVnYXNhc19pbml0X21maTogZndfc3VwcG9ydF9pZWVlPSVk
IiwKCQkJaW5zdGFuY2UtPmZ3X3N1cHBvcnRfaWVlZSk7CgoJaWYgKGluc3RhbmNlLT5md19zdXBw
b3J0X2llZWUpCgkJaW5zdGFuY2UtPmZsYWdfaWVlZSA9IDE7CgoJLyoqIGZvciBwYXNzdGhyb3Vn
aAoJKiB0aGUgZm9sbG93aW5nIGZ1bmN0aW9uIHdpbGwgZ2V0IHRoZSBQRCBMSVNULgoJKi8KCglt
ZW1zZXQoaW5zdGFuY2UtPnBkX2xpc3QsIDAgLAoJCShNRUdBU0FTX01BWF9QRCAqIHNpemVvZihz
dHJ1Y3QgbWVnYXNhc19wZF9saXN0KSkpOwoJbWVnYXNhc19nZXRfcGRfbGlzdChpbnN0YW5jZSk7
CgoJbWVtc2V0KGluc3RhbmNlLT5sZF9pZHMsIDB4ZmYsIE1FR0FTQVNfTUFYX0xEX0lEUyk7Cglt
ZWdhc2FzX2dldF9sZF9saXN0KGluc3RhbmNlKTsKCgljdHJsX2luZm8gPSBrbWFsbG9jKHNpemVv
ZihzdHJ1Y3QgbWVnYXNhc19jdHJsX2luZm8pLCBHRlBfS0VSTkVMKTsKCgkvKgoJICogQ29tcHV0
ZSB0aGUgbWF4IGFsbG93ZWQgc2VjdG9ycyBwZXIgSU86IFRoZSBjb250cm9sbGVyIGluZm8gaGFz
IHR3bwoJICogbGltaXRzIG9uIG1heCBzZWN0b3JzLiBEcml2ZXIgc2hvdWxkIHVzZSB0aGUgbWlu
aW11bSBvZiB0aGVzZSB0d28uCgkgKgoJICogMSA8PCBzdHJpcGVfc3pfb3BzLm1pbiA9IG1heCBz
ZWN0b3JzIHBlciBzdHJpcAoJICoKCSAqIE5vdGUgdGhhdCBvbGRlciBmaXJtd2FyZXMgKCA8IEZX
IHZlciAzMCkgZGlkbid0IHJlcG9ydCBpbmZvcm1hdGlvbgoJICogdG8gY2FsY3VsYXRlIG1heF9z
ZWN0b3JzXzEuIFNvIHRoZSBudW1iZXIgZW5kZWQgdXAgYXMgemVybyBhbHdheXMuCgkgKi8KCXRt
cF9zZWN0b3JzID0gMDsKCWlmIChjdHJsX2luZm8gJiYgIW1lZ2FzYXNfZ2V0X2N0cmxfaW5mbyhp
bnN0YW5jZSwgY3RybF9pbmZvKSkgewoKCQltYXhfc2VjdG9yc18xID0gKDEgPDwgY3RybF9pbmZv
LT5zdHJpcGVfc3pfb3BzLm1pbikgKgoJCSAgICBjdHJsX2luZm8tPm1heF9zdHJpcHNfcGVyX2lv
OwoJCW1heF9zZWN0b3JzXzIgPSBjdHJsX2luZm8tPm1heF9yZXF1ZXN0X3NpemU7CgoJCXRtcF9z
ZWN0b3JzID0gbWluX3QodTMyLCBtYXhfc2VjdG9yc18xICwgbWF4X3NlY3RvcnNfMik7CgkJaW5z
dGFuY2UtPmRpc2FibGVPbmxpbmVDdHJsUmVzZXQgPQoJCWN0cmxfaW5mby0+cHJvcGVydGllcy5P
bk9mZlByb3BlcnRpZXMuZGlzYWJsZU9ubGluZUN0cmxSZXNldDsKCX0KCglpbnN0YW5jZS0+bWF4
X3NlY3RvcnNfcGVyX3JlcSA9IGluc3RhbmNlLT5tYXhfbnVtX3NnZSAqCgkJCQkJCVBBR0VfU0la
RSAvIDUxMjsKCWlmICh0bXBfc2VjdG9ycyAmJiAoaW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9y
ZXEgPiB0bXBfc2VjdG9ycykpCgkJaW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9yZXEgPSB0bXBf
c2VjdG9yczsKCglrZnJlZShjdHJsX2luZm8pOwoKICAgICAgICAvKgoJKiBTZXR1cCB0YXNrbGV0
IGZvciBjbWQgY29tcGxldGlvbgoJKi8KCgl0YXNrbGV0X2luaXQoJmluc3RhbmNlLT5pc3JfdGFz
a2xldCwgbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjLAoJCSh1bnNpZ25lZCBsb25nKWluc3RhbmNl
KTsKCgkvKiBJbml0aWFsaXplIHRoZSBjbWQgY29tcGxldGlvbiB0aW1lciAqLwoJaWYgKHBvbGxf
bW9kZV9pbykKCQltZWdhc2FzX3N0YXJ0X3RpbWVyKGluc3RhbmNlLCAmaW5zdGFuY2UtPmlvX2Nv
bXBsZXRpb25fdGltZXIsCgkJCQltZWdhc2FzX2lvX2NvbXBsZXRpb25fdGltZXIsCgkJCQlNRUdB
U0FTX0NPTVBMRVRJT05fVElNRVJfSU5URVJWQUwpOwoJcmV0dXJuIDA7CgogICAgICBmYWlsX2Z3
X2luaXQ6CgoJcGNpX2ZyZWVfY29uc2lzdGVudChpbnN0YW5jZS0+cGRldiwgcmVwbHlfcV9zeiwK
CQkJICAgIGluc3RhbmNlLT5yZXBseV9xdWV1ZSwgaW5zdGFuY2UtPnJlcGx5X3F1ZXVlX2gpOwog
ICAgICBmYWlsX3JlcGx5X3F1ZXVlOgoJbWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOwoKICAg
ICAgZmFpbF9hbGxvY19jbWRzOgogICAgICBmYWlsX3JlYWR5X3N0YXRlOgoJaW91bm1hcChpbnN0
YW5jZS0+cmVnX3NldCk7CgogICAgICBmYWlsX2lvcmVtYXA6CglwY2lfcmVsZWFzZV9zZWxlY3Rl
ZF9yZWdpb25zKGluc3RhbmNlLT5wZGV2LAoJCXBjaV9zZWxlY3RfYmFycyhpbnN0YW5jZS0+cGRl
diwgSU9SRVNPVVJDRV9NRU0pKTsKCglyZXR1cm4gLUVJTlZBTDsKfQoKLyoqCiAqIG1lZ2FzYXNf
cmVsZWFzZV9tZmkgLQlSZXZlcnNlcyB0aGUgRlcgaW5pdGlhbGl6YXRpb24KICogQGludGFuY2U6
CQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAqLwpzdGF0aWMgdm9pZCBtZWdhc2FzX3JlbGVhc2VfbWZp
KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKewoJdTMyIHJlcGx5X3Ffc3ogPSBz
aXplb2YodTMyKSAqIChpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgKyAxKTsKCglwY2lfZnJlZV9jb25z
aXN0ZW50KGluc3RhbmNlLT5wZGV2LCByZXBseV9xX3N6LAoJCQkgICAgaW5zdGFuY2UtPnJlcGx5
X3F1ZXVlLCBpbnN0YW5jZS0+cmVwbHlfcXVldWVfaCk7CgoJbWVnYXNhc19mcmVlX2NtZHMoaW5z
dGFuY2UpOwoKCWlvdW5tYXAoaW5zdGFuY2UtPnJlZ19zZXQpOwoKCXBjaV9yZWxlYXNlX3NlbGVj
dGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsCgkJcGNpX3NlbGVjdF9iYXJzKGluc3RhbmNlLT5w
ZGV2LCBJT1JFU09VUkNFX01FTSkpOwp9CgovKioKICogbWVnYXNhc19nZXRfc2VxX251bSAtCUdl
dHMgbGF0ZXN0IGV2ZW50IHNlcXVlbmNlIG51bWJlcnMKICogQGluc3RhbmNlOgkJCUFkYXB0ZXIg
c29mdCBzdGF0ZQogKiBAZWxpOgkJCUZXIGV2ZW50IGxvZyBzZXF1ZW5jZSBudW1iZXJzIGluZm9y
bWF0aW9uCiAqCiAqIEZXIG1haW50YWlucyBhIGxvZyBvZiBhbGwgZXZlbnRzIGluIGEgbm9uLXZv
bGF0aWxlIGFyZWEuIFVwcGVyIGxheWVycyB3b3VsZAogKiB1c3VhbGx5IGZpbmQgb3V0IHRoZSBs
YXRlc3Qgc2VxdWVuY2UgbnVtYmVyIG9mIHRoZSBldmVudHMsIHRoZSBzZXEgbnVtYmVyIGF0CiAq
IHRoZSBib290IGV0Yy4gVGhleSB3b3VsZCAicmVhZCIgYWxsIHRoZSBldmVudHMgYmVsb3cgdGhl
IGxhdGVzdCBzZXEgbnVtYmVyCiAqIGJ5IGlzc3VpbmcgYSBkaXJlY3QgZncgY21kIChEQ01EKS4g
Rm9yIHRoZSBmdXR1cmUgZXZlbnRzIChiZXlvbmQgbGF0ZXN0IHNlcQogKiBudW1iZXIpLCB0aGV5
IHdvdWxkIHN1YnNyaWJlIHRvIEFFTiAoYXN5bmNocm9ub3VzIGV2ZW50IG5vdGlmaWNhdGlvbikg
YW5kCiAqIHdhaXQgZm9yIHRoZSBldmVudHMgdG8gaGFwcGVuLgogKi8Kc3RhdGljIGludAptZWdh
c2FzX2dldF9zZXFfbnVtKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKCQkgICAg
c3RydWN0IG1lZ2FzYXNfZXZ0X2xvZ19pbmZvICplbGkpCnsKCXN0cnVjdCBtZWdhc2FzX2NtZCAq
Y21kOwoJc3RydWN0IG1lZ2FzYXNfZGNtZF9mcmFtZSAqZGNtZDsKCXN0cnVjdCBtZWdhc2FzX2V2
dF9sb2dfaW5mbyAqZWxfaW5mbzsKCWRtYV9hZGRyX3QgZWxfaW5mb19oID0gMDsKCgljbWQgPSBt
ZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOwoKCWlmICghY21kKSB7CgkJcmV0dXJuIC1FTk9NRU07
Cgl9CgoJZGNtZCA9ICZjbWQtPmZyYW1lLT5kY21kOwoJZWxfaW5mbyA9IHBjaV9hbGxvY19jb25z
aXN0ZW50KGluc3RhbmNlLT5wZGV2LAoJCQkJICAgICAgIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19l
dnRfbG9nX2luZm8pLAoJCQkJICAgICAgICZlbF9pbmZvX2gpOwoKCWlmICghZWxfaW5mbykgewoJ
CW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwgY21kKTsKCQlyZXR1cm4gLUVOT01FTTsKCX0K
CgltZW1zZXQoZWxfaW5mbywgMCwgc2l6ZW9mKCplbF9pbmZvKSk7CgltZW1zZXQoZGNtZC0+bWJv
eC5iLCAwLCBNRklfTUJPWF9TSVpFKTsKCglkY21kLT5jbWQgPSBNRklfQ01EX0RDTUQ7CglkY21k
LT5jbWRfc3RhdHVzID0gMHgwOwoJZGNtZC0+c2dlX2NvdW50ID0gMTsKCWRjbWQtPmZsYWdzID0g
TUZJX0ZSQU1FX0RJUl9SRUFEOwoJZGNtZC0+dGltZW91dCA9IDA7CglkY21kLT5wYWRfMCA9IDA7
CglkY21kLT5kYXRhX3hmZXJfbGVuID0gc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2V2dF9sb2dfaW5m
byk7CglkY21kLT5vcGNvZGUgPSBNUl9EQ01EX0NUUkxfRVZFTlRfR0VUX0lORk87CglkY21kLT5z
Z2wuc2dlMzJbMF0ucGh5c19hZGRyID0gZWxfaW5mb19oOwoJZGNtZC0+c2dsLnNnZTMyWzBdLmxl
bmd0aCA9IHNpemVvZihzdHJ1Y3QgbWVnYXNhc19ldnRfbG9nX2luZm8pOwoKCW1lZ2FzYXNfaXNz
dWVfYmxvY2tlZF9jbWQoaW5zdGFuY2UsIGNtZCk7CgoJLyoKCSAqIENvcHkgdGhlIGRhdGEgYmFj
ayBpbnRvIGNhbGxlcnMgYnVmZmVyCgkgKi8KCW1lbWNweShlbGksIGVsX2luZm8sIHNpemVvZihz
dHJ1Y3QgbWVnYXNhc19ldnRfbG9nX2luZm8pKTsKCglwY2lfZnJlZV9jb25zaXN0ZW50KGluc3Rh
bmNlLT5wZGV2LCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfZXZ0X2xvZ19pbmZvKSwKCQkJICAgIGVs
X2luZm8sIGVsX2luZm9faCk7CgoJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwoK
CXJldHVybiAwOwp9CgovKioKICogbWVnYXNhc19yZWdpc3Rlcl9hZW4gLQlSZWdpc3RlcnMgZm9y
IGFzeW5jaHJvbm91cyBldmVudCBub3RpZmljYXRpb24KICogQGluc3RhbmNlOgkJCUFkYXB0ZXIg
c29mdCBzdGF0ZQogKiBAc2VxX251bToJCQlUaGUgc3RhcnRpbmcgc2VxdWVuY2UgbnVtYmVyCiAq
IEBjbGFzc19sb2NhbGU6CQlDbGFzcyBvZiB0aGUgZXZlbnQKICoKICogVGhpcyBmdW5jdGlvbiBz
dWJzY3JpYmVzIGZvciBBRU4gZm9yIGV2ZW50cyBiZXlvbmQgdGhlIEBzZXFfbnVtLiBJdCByZXF1
ZXN0cwogKiB0byBiZSBub3RpZmllZCBpZiBhbmQgb25seSBpZiB0aGUgZXZlbnQgaXMgb2YgdHlw
ZSBAY2xhc3NfbG9jYWxlCiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfcmVnaXN0ZXJfYWVuKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgdTMyIHNlcV9udW0sCgkJICAgICB1MzIgY2xh
c3NfbG9jYWxlX3dvcmQpCnsKCWludCByZXRfdmFsOwoJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7
CglzdHJ1Y3QgbWVnYXNhc19kY21kX2ZyYW1lICpkY21kOwoJdW5pb24gbWVnYXNhc19ldnRfY2xh
c3NfbG9jYWxlIGN1cnJfYWVuOwoJdW5pb24gbWVnYXNhc19ldnRfY2xhc3NfbG9jYWxlIHByZXZf
YWVuOwoKCS8qCgkgKiBJZiB0aGVyZSBhbiBBRU4gcGVuZGluZyBhbHJlYWR5IChhZW5fY21kKSwg
Y2hlY2sgaWYgdGhlCgkgKiBjbGFzc19sb2NhbGUgb2YgdGhhdCBwZW5kaW5nIEFFTiBpcyBpbmNs
dXNpdmUgb2YgdGhlIG5ldwoJICogQUVOIHJlcXVlc3Qgd2UgY3VycmVudGx5IGhhdmUuIElmIGl0
IGlzLCB0aGVuIHdlIGRvbid0IGhhdmUKCSAqIHRvIGRvIGFueXRoaW5nLiBJbiBvdGhlciB3b3Jk
cywgd2hpY2hldmVyIGV2ZW50cyB0aGUgY3VycmVudAoJICogQUVOIHJlcXVlc3QgaXMgc3Vic2Ny
aWJpbmcgdG8sIGhhdmUgYWxyZWFkeSBiZWVuIHN1YnNjcmliZWQKCSAqIHRvLgoJICoKCSAqIElm
IHRoZSBvbGRfY21kIGlzIF9ub3RfIGluY2x1c2l2ZSwgdGhlbiB3ZSBoYXZlIHRvIGFib3J0Cgkg
KiB0aGF0IGNvbW1hbmQsIGZvcm0gYSBjbGFzc19sb2NhbGUgdGhhdCBpcyBzdXBlcnNldCBvZiBi
b3RoCgkgKiBvbGQgYW5kIGN1cnJlbnQgYW5kIHJlLWlzc3VlIHRvIHRoZSBGVwoJICovCgoJY3Vy
cl9hZW4ud29yZCA9IGNsYXNzX2xvY2FsZV93b3JkOwoKCWlmIChpbnN0YW5jZS0+YWVuX2NtZCkg
ewoKCQlwcmV2X2Flbi53b3JkID0gaW5zdGFuY2UtPmFlbl9jbWQtPmZyYW1lLT5kY21kLm1ib3gu
d1sxXTsKCgkJLyoKCQkgKiBBIGNsYXNzIHdob3NlIGVudW0gdmFsdWUgaXMgc21hbGxlciBpcyBp
bmNsdXNpdmUgb2YgYWxsCgkJICogaGlnaGVyIHZhbHVlcy4gSWYgYSBQUk9HUkVTUyAoPSAtMSkg
d2FzIHByZXZpb3VzbHkKCQkgKiByZWdpc3RlcmVkLCB0aGVuIGEgbmV3IHJlZ2lzdHJhdGlvbiBy
ZXF1ZXN0cyBmb3IgaGlnaGVyCgkJICogY2xhc3NlcyBuZWVkIG5vdCBiZSBzZW50IHRvIEZXLiBU
aGV5IGFyZSBhdXRvbWF0aWNhbGx5CgkJICogaW5jbHVkZWQuCgkJICoKCQkgKiBMb2NhbGUgbnVt
YmVycyBkb24ndCBoYXZlIHN1Y2ggaGllcmFyY2h5LiBUaGV5IGFyZSBiaXRtYXAKCQkgKiB2YWx1
ZXMKCQkgKi8KCQlpZiAoKHByZXZfYWVuLm1lbWJlcnMuY2xhc3MgPD0gY3Vycl9hZW4ubWVtYmVy
cy5jbGFzcykgJiYKCQkgICAgISgocHJldl9hZW4ubWVtYmVycy5sb2NhbGUgJiBjdXJyX2Flbi5t
ZW1iZXJzLmxvY2FsZSkgXgoJCSAgICAgIGN1cnJfYWVuLm1lbWJlcnMubG9jYWxlKSkgewoJCQkv
KgoJCQkgKiBQcmV2aW91c2x5IGlzc3VlZCBldmVudCByZWdpc3RyYXRpb24gaW5jbHVkZXMKCQkJ
ICogY3VycmVudCByZXF1ZXN0LiBOb3RoaW5nIHRvIGRvLgoJCQkgKi8KCQkJcmV0dXJuIDA7CgkJ
fSBlbHNlIHsKCQkJY3Vycl9hZW4ubWVtYmVycy5sb2NhbGUgfD0gcHJldl9hZW4ubWVtYmVycy5s
b2NhbGU7CgoJCQlpZiAocHJldl9hZW4ubWVtYmVycy5jbGFzcyA8IGN1cnJfYWVuLm1lbWJlcnMu
Y2xhc3MpCgkJCQljdXJyX2Flbi5tZW1iZXJzLmNsYXNzID0gcHJldl9hZW4ubWVtYmVycy5jbGFz
czsKCgkJCWluc3RhbmNlLT5hZW5fY21kLT5hYm9ydF9hZW4gPSAxOwoJCQlyZXRfdmFsID0gbWVn
YXNhc19pc3N1ZV9ibG9ja2VkX2Fib3J0X2NtZChpbnN0YW5jZSwKCQkJCQkJCQkgIGluc3RhbmNl
LT4KCQkJCQkJCQkgIGFlbl9jbWQpOwoKCQkJaWYgKHJldF92YWwpIHsKCQkJCXByaW50ayhLRVJO
X0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gYWJvcnQgIgoJCQkJICAgICAgICJwcmV2aW91cyBB
RU4gY29tbWFuZFxuIik7CgkJCQlyZXR1cm4gcmV0X3ZhbDsKCQkJfQoJCX0KCX0KCgljbWQgPSBt
ZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOwoKCWlmICghY21kKQoJCXJldHVybiAtRU5PTUVNOwoK
CWRjbWQgPSAmY21kLT5mcmFtZS0+ZGNtZDsKCgltZW1zZXQoaW5zdGFuY2UtPmV2dF9kZXRhaWws
IDAsIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19ldnRfZGV0YWlsKSk7CgoJLyoKCSAqIFByZXBhcmUg
RENNRCBmb3IgYWVuIHJlZ2lzdHJhdGlvbgoJICovCgltZW1zZXQoZGNtZC0+bWJveC5iLCAwLCBN
RklfTUJPWF9TSVpFKTsKCglkY21kLT5jbWQgPSBNRklfQ01EX0RDTUQ7CglkY21kLT5jbWRfc3Rh
dHVzID0gMHgwOwoJZGNtZC0+c2dlX2NvdW50ID0gMTsKCWRjbWQtPmZsYWdzID0gTUZJX0ZSQU1F
X0RJUl9SRUFEOwoJZGNtZC0+dGltZW91dCA9IDA7CglkY21kLT5wYWRfMCA9IDA7CglpbnN0YW5j
ZS0+bGFzdF9zZXFfbnVtID0gc2VxX251bTsKCWRjbWQtPmRhdGFfeGZlcl9sZW4gPSBzaXplb2Yo
c3RydWN0IG1lZ2FzYXNfZXZ0X2RldGFpbCk7CglkY21kLT5vcGNvZGUgPSBNUl9EQ01EX0NUUkxf
RVZFTlRfV0FJVDsKCWRjbWQtPm1ib3gud1swXSA9IHNlcV9udW07CglkY21kLT5tYm94LndbMV0g
PSBjdXJyX2Flbi53b3JkOwoJZGNtZC0+c2dsLnNnZTMyWzBdLnBoeXNfYWRkciA9ICh1MzIpIGlu
c3RhbmNlLT5ldnRfZGV0YWlsX2g7CglkY21kLT5zZ2wuc2dlMzJbMF0ubGVuZ3RoID0gc2l6ZW9m
KHN0cnVjdCBtZWdhc2FzX2V2dF9kZXRhaWwpOwoKCWlmIChpbnN0YW5jZS0+YWVuX2NtZCAhPSBO
VUxMKSB7CgkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwoJCXJldHVybiAwOwoJ
fQoKCS8qCgkgKiBTdG9yZSByZWZlcmVuY2UgdG8gdGhlIGNtZCB1c2VkIHRvIHJlZ2lzdGVyIGZv
ciBBRU4uIFdoZW4gYW4KCSAqIGFwcGxpY2F0aW9uIHdhbnRzIHVzIHRvIHJlZ2lzdGVyIGZvciBB
RU4sIHdlIGhhdmUgdG8gYWJvcnQgdGhpcwoJICogY21kIGFuZCByZS1yZWdpc3RlciB3aXRoIGEg
bmV3IEVWRU5UIExPQ0FMRSBzdXBwbGllZCBieSB0aGF0IGFwcAoJICovCglpbnN0YW5jZS0+YWVu
X2NtZCA9IGNtZDsKCgkvKgoJICogSXNzdWUgdGhlIGFlbiByZWdpc3RyYXRpb24gZnJhbWUKCSAq
LwoJaW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCgkJCWNtZC0+ZnJhbWVf
cGh5c19hZGRyLCAwLCBpbnN0YW5jZS0+cmVnX3NldCk7CgoJcmV0dXJuIDA7Cn0KCi8qKgogKiBt
ZWdhc2FzX3N0YXJ0X2FlbiAtCVN1YnNjcmliZXMgdG8gQUVOIGR1cmluZyBkcml2ZXIgbG9hZCB0
aW1lCiAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogKi8Kc3RhdGljIGludCBtZWdh
c2FzX3N0YXJ0X2FlbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCnsKCXN0cnVj
dCBtZWdhc2FzX2V2dF9sb2dfaW5mbyBlbGk7Cgl1bmlvbiBtZWdhc2FzX2V2dF9jbGFzc19sb2Nh
bGUgY2xhc3NfbG9jYWxlOwoKCS8qCgkgKiBHZXQgdGhlIGxhdGVzdCBzZXF1ZW5jZSBudW1iZXIg
ZnJvbSBGVwoJICovCgltZW1zZXQoJmVsaSwgMCwgc2l6ZW9mKGVsaSkpOwoKCWlmIChtZWdhc2Fz
X2dldF9zZXFfbnVtKGluc3RhbmNlLCAmZWxpKSkKCQlyZXR1cm4gLTE7CgoJLyoKCSAqIFJlZ2lz
dGVyIEFFTiB3aXRoIEZXIGZvciBsYXRlc3Qgc2VxdWVuY2UgbnVtYmVyIHBsdXMgMQoJICovCglj
bGFzc19sb2NhbGUubWVtYmVycy5yZXNlcnZlZCA9IDA7CgljbGFzc19sb2NhbGUubWVtYmVycy5s
b2NhbGUgPSBNUl9FVlRfTE9DQUxFX0FMTDsKCWNsYXNzX2xvY2FsZS5tZW1iZXJzLmNsYXNzID0g
TVJfRVZUX0NMQVNTX0RFQlVHOwoKCXJldHVybiBtZWdhc2FzX3JlZ2lzdGVyX2FlbihpbnN0YW5j
ZSwgZWxpLm5ld2VzdF9zZXFfbnVtICsgMSwKCQkJCSAgICBjbGFzc19sb2NhbGUud29yZCk7Cn0K
Ci8qKgogKiBtZWdhc2FzX2lvX2F0dGFjaCAtCUF0dGFjaGVzIHRoaXMgZHJpdmVyIHRvIFNDU0kg
bWlkLWxheWVyCiAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogKi8Kc3RhdGljIGlu
dCBtZWdhc2FzX2lvX2F0dGFjaChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCnsK
CXN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBpbnN0YW5jZS0+aG9zdDsKCgkvKgoJICogRXhwb3J0
IHBhcmFtZXRlcnMgcmVxdWlyZWQgYnkgU0NTSSBtaWQtbGF5ZXIKCSAqLwoJaG9zdC0+aXJxID0g
aW5zdGFuY2UtPnBkZXYtPmlycTsKCWhvc3QtPnVuaXF1ZV9pZCA9IGluc3RhbmNlLT51bmlxdWVf
aWQ7CglpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfU0FT
MDA3M1NLSU5OWSkgfHwKCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lE
X0xTSV9TQVMwMDcxU0tJTk5ZKSkgewoJCWhvc3QtPmNhbl9xdWV1ZSA9CgkJCWluc3RhbmNlLT5t
YXhfZndfY21kcyAtIE1FR0FTQVNfU0tJTk5ZX0lOVF9DTURTOwoJfSBlbHNlCgkJaG9zdC0+Y2Fu
X3F1ZXVlID0KCQkJaW5zdGFuY2UtPm1heF9md19jbWRzIC0gTUVHQVNBU19JTlRfQ01EUzsKCWhv
c3QtPnRoaXNfaWQgPSBpbnN0YW5jZS0+aW5pdF9pZDsKCWhvc3QtPnNnX3RhYmxlc2l6ZSA9IGlu
c3RhbmNlLT5tYXhfbnVtX3NnZTsKCS8qCgkgKiBDaGVjayBpZiB0aGUgbW9kdWxlIHBhcmFtZXRl
ciB2YWx1ZSBmb3IgbWF4X3NlY3RvcnMgY2FuIGJlIHVzZWQKCSAqLwoJaWYgKG1heF9zZWN0b3Jz
ICYmIG1heF9zZWN0b3JzIDwgaW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9yZXEpCgkJaW5zdGFu
Y2UtPm1heF9zZWN0b3JzX3Blcl9yZXEgPSBtYXhfc2VjdG9yczsKCWVsc2UgewoJCWlmIChtYXhf
c2VjdG9ycykgewoJCQlpZiAoKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CgkJCQlQQ0lfREVW
SUNFX0lEX0xTSV9TQVMxMDc4R0VOMikgfHwKCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
CgkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDc5R0VOMikpICYmCgkJCQkobWF4X3NlY3RvcnMg
PD0gTUVHQVNBU19NQVhfU0VDVE9SUykpIHsKCQkJCWluc3RhbmNlLT5tYXhfc2VjdG9yc19wZXJf
cmVxID0gbWF4X3NlY3RvcnM7CgkJCX0gZWxzZSB7CgkJCXByaW50ayhLRVJOX0lORk8gIm1lZ2Fz
YXM6IG1heF9zZWN0b3JzIHNob3VsZCBiZSA+IDAiCgkJCQkiYW5kIDw9ICVkIChvciA8IDFNQiBm
b3IgR0VOMiBjb250cm9sbGVyKVxuIiwKCQkJCWluc3RhbmNlLT5tYXhfc2VjdG9yc19wZXJfcmVx
KTsKCQkJfQoJCX0KCX0KCglob3N0LT5tYXhfc2VjdG9ycyA9IGluc3RhbmNlLT5tYXhfc2VjdG9y
c19wZXJfcmVxOwoJaG9zdC0+Y21kX3Blcl9sdW4gPSAxMjg7Cglob3N0LT5tYXhfY2hhbm5lbCA9
IE1FR0FTQVNfTUFYX0NIQU5ORUxTIC0gMTsKCWhvc3QtPm1heF9pZCA9IE1FR0FTQVNfTUFYX0RF
Vl9QRVJfQ0hBTk5FTDsKCWhvc3QtPm1heF9sdW4gPSBNRUdBU0FTX01BWF9MVU47Cglob3N0LT5t
YXhfY21kX2xlbiA9IDE2OwoKCS8qCgkgKiBOb3RpZnkgdGhlIG1pZC1sYXllciBhYm91dCB0aGUg
bmV3IGNvbnRyb2xsZXIKCSAqLwoJaWYgKHNjc2lfYWRkX2hvc3QoaG9zdCwgJmluc3RhbmNlLT5w
ZGV2LT5kZXYpKSB7CgkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IHNjc2lfYWRkX2hvc3Qg
ZmFpbGVkXG4iKTsKCQlyZXR1cm4gLUVOT0RFVjsKCX0KCgkvKgoJICogVHJpZ2dlciBTQ1NJIHRv
IHNjYW4gb3VyIGRyaXZlcwoJICovCglzY3NpX3NjYW5faG9zdChob3N0KTsKCXJldHVybiAwOwp9
CgpzdGF0aWMgaW50Cm1lZ2FzYXNfc2V0X2RtYV9tYXNrKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQp7
CgkvKgoJICogQWxsIG91ciBjb250b2xsZXJzIGFyZSBjYXBhYmxlIG9mIHBlcmZvcm1pbmcgNjQt
Yml0IERNQQoJICovCglpZiAoSVNfRE1BNjQpIHsKCQlpZiAocGNpX3NldF9kbWFfbWFzayhwZGV2
LCBETUFfQklUX01BU0soNjQpKSAhPSAwKSB7CgoJCQlpZiAocGNpX3NldF9kbWFfbWFzayhwZGV2
LCBETUFfQklUX01BU0soMzIpKSAhPSAwKQoJCQkJZ290byBmYWlsX3NldF9kbWFfbWFzazsKCQl9
Cgl9IGVsc2UgewoJCWlmIChwY2lfc2V0X2RtYV9tYXNrKHBkZXYsIERNQV9CSVRfTUFTSygzMikp
ICE9IDApCgkJCWdvdG8gZmFpbF9zZXRfZG1hX21hc2s7Cgl9CglyZXR1cm4gMDsKCmZhaWxfc2V0
X2RtYV9tYXNrOgoJcmV0dXJuIDE7Cn0KCi8qKgogKiBtZWdhc2FzX3Byb2JlX29uZSAtCVBDSSBo
b3RwbHVnIGVudHJ5IHBvaW50CiAqIEBwZGV2OgkJUENJIGRldmljZSBzdHJ1Y3R1cmUKICogQGlk
OgkJCVBDSSBpZHMgb2Ygc3VwcG9ydGVkIGhvdHBsdWdnZWQgYWRhcHRlcgkKICovCnN0YXRpYyBp
bnQgX19kZXZpbml0Cm1lZ2FzYXNfcHJvYmVfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25z
dCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpCnsKCWludCBydmFsOwoJc3RydWN0IFNjc2lfSG9z
dCAqaG9zdDsKCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKCgkvKgoJICogQW5u
b3VuY2UgUENJIGluZm9ybWF0aW9uCgkgKi8KCXByaW50ayhLRVJOX0lORk8gIm1lZ2FzYXM6ICUj
NC4wNHg6JSM0LjA0eDolIzQuMDR4OiUjNC4wNHg6ICIsCgkgICAgICAgcGRldi0+dmVuZG9yLCBw
ZGV2LT5kZXZpY2UsIHBkZXYtPnN1YnN5c3RlbV92ZW5kb3IsCgkgICAgICAgcGRldi0+c3Vic3lz
dGVtX2RldmljZSk7CgoJcHJpbnRrKCJidXMgJWQ6c2xvdCAlZDpmdW5jICVkXG4iLAoJICAgICAg
IHBkZXYtPmJ1cy0+bnVtYmVyLCBQQ0lfU0xPVChwZGV2LT5kZXZmbiksIFBDSV9GVU5DKHBkZXYt
PmRldmZuKSk7CgoJLyoKCSAqIFBDSSBwcmVwcGluZzogZW5hYmxlIGRldmljZSBzZXQgYnVzIG1h
c3RlcmluZyBhbmQgZG1hIG1hc2sKCSAqLwoJcnZhbCA9IHBjaV9lbmFibGVfZGV2aWNlX21lbShw
ZGV2KTsKCglpZiAocnZhbCkgewoJCXJldHVybiBydmFsOwoJfQoKCXBjaV9zZXRfbWFzdGVyKHBk
ZXYpOwoKCWlmIChtZWdhc2FzX3NldF9kbWFfbWFzayhwZGV2KSkKCQlnb3RvIGZhaWxfc2V0X2Rt
YV9tYXNrOwoKCWhvc3QgPSBzY3NpX2hvc3RfYWxsb2MoJm1lZ2FzYXNfdGVtcGxhdGUsCgkJCSAg
ICAgICBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UpKTsKCglpZiAoIWhvc3QpIHsKCQlw
cmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogc2NzaV9ob3N0X2FsbG9jIGZhaWxlZFxuIik7CgkJ
Z290byBmYWlsX2FsbG9jX2luc3RhbmNlOwoJfQoKCWluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICopaG9zdC0+aG9zdGRhdGE7CgltZW1zZXQoaW5zdGFuY2UsIDAsIHNpemVvZigq
aW5zdGFuY2UpKTsKCWF0b21pY19zZXQoICZpbnN0YW5jZS0+ZndfcmVzZXRfbm9fcGNpX2FjY2Vz
cywgMCApOwoKCWluc3RhbmNlLT5wcm9kdWNlciA9IHBjaV9hbGxvY19jb25zaXN0ZW50KHBkZXYs
IHNpemVvZih1MzIpLAoJCQkJCQkgICZpbnN0YW5jZS0+cHJvZHVjZXJfaCk7CglpbnN0YW5jZS0+
Y29uc3VtZXIgPSBwY2lfYWxsb2NfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwKCQkJCQkJ
ICAmaW5zdGFuY2UtPmNvbnN1bWVyX2gpOwoKCWlmICghaW5zdGFuY2UtPnByb2R1Y2VyIHx8ICFp
bnN0YW5jZS0+Y29uc3VtZXIpIHsKCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRmFpbGVk
IHRvIGFsbG9jYXRlIG1lbW9yeSBmb3IgIgoJCSAgICAgICAicHJvZHVjZXIsIGNvbnN1bWVyXG4i
KTsKCQlnb3RvIGZhaWxfYWxsb2NfZG1hX2J1ZjsKCX0KCgkqaW5zdGFuY2UtPnByb2R1Y2VyID0g
MDsKCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAwOwoJbWVnYXNhc19wb2xsX3dhaXRfYWVuID0gMDsK
CWluc3RhbmNlLT5mbGFnX2llZWUgPSAwOwoJaW5zdGFuY2UtPmV2ID0gTlVMTDsKCWluc3RhbmNl
LT5pc3N1ZXBlbmRfZG9uZSA9IDE7CglpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPSBNRUdBU0FTX0hC
QV9PUEVSQVRJT05BTDsKCW1lZ2FzYXNfcG9sbF93YWl0X2FlbiA9IDA7CgoJaW5zdGFuY2UtPmV2
dF9kZXRhaWwgPSBwY2lfYWxsb2NfY29uc2lzdGVudChwZGV2LAoJCQkJCQkgICAgc2l6ZW9mKHN0
cnVjdAoJCQkJCQkJICAgbWVnYXNhc19ldnRfZGV0YWlsKSwKCQkJCQkJICAgICZpbnN0YW5jZS0+
ZXZ0X2RldGFpbF9oKTsKCglpZiAoIWluc3RhbmNlLT5ldnRfZGV0YWlsKSB7CgkJcHJpbnRrKEtF
Uk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBhbGxvY2F0ZSBtZW1vcnkgZm9yICIKCQkgICAg
ICAgImV2ZW50IGRldGFpbCBzdHJ1Y3R1cmVcbiIpOwoJCWdvdG8gZmFpbF9hbGxvY19kbWFfYnVm
OwoJfQoKCS8qCgkgKiBJbml0aWFsaXplIGxvY2tzIGFuZCBxdWV1ZXMKCSAqLwoJSU5JVF9MSVNU
X0hFQUQoJmluc3RhbmNlLT5jbWRfcG9vbCk7CglJTklUX0xJU1RfSEVBRCgmaW5zdGFuY2UtPmlu
dGVybmFsX3Jlc2V0X3BlbmRpbmdfcSk7CgoJYXRvbWljX3NldCgmaW5zdGFuY2UtPmZ3X291dHN0
YW5kaW5nLDApOwoKCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmluc3RhbmNlLT5pbnRfY21kX3dhaXRf
cSk7Cglpbml0X3dhaXRxdWV1ZV9oZWFkKCZpbnN0YW5jZS0+YWJvcnRfY21kX3dhaXRfcSk7CgoJ
c3Bpbl9sb2NrX2luaXQoJmluc3RhbmNlLT5jbWRfcG9vbF9sb2NrKTsKCXNwaW5fbG9ja19pbml0
KCZpbnN0YW5jZS0+aGJhX2xvY2spOwoJc3Bpbl9sb2NrX2luaXQoJmluc3RhbmNlLT5jb21wbGV0
aW9uX2xvY2spOwoJc3Bpbl9sb2NrX2luaXQoJnBvbGxfYWVuX2xvY2spOwoKCW11dGV4X2luaXQo
Jmluc3RhbmNlLT5hZW5fbXV0ZXgpOwoKCS8qCgkgKiBJbml0aWFsaXplIFBDSSByZWxhdGVkIGFu
ZCBtaXNjIHBhcmFtZXRlcnMKCSAqLwoJaW5zdGFuY2UtPnBkZXYgPSBwZGV2OwoJaW5zdGFuY2Ut
Pmhvc3QgPSBob3N0OwoJaW5zdGFuY2UtPnVuaXF1ZV9pZCA9IHBkZXYtPmJ1cy0+bnVtYmVyIDw8
IDggfCBwZGV2LT5kZXZmbjsKCWluc3RhbmNlLT5pbml0X2lkID0gTUVHQVNBU19ERUZBVUxUX0lO
SVRfSUQ7CgoJaWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJ
X1NBUzAwNzNTS0lOTlkpIHx8CgkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklD
RV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKCQlpbnN0YW5jZS0+ZmxhZ19pZWVlID0gMTsKCQlz
ZW1hX2luaXQoJmluc3RhbmNlLT5pb2N0bF9zZW0sIE1FR0FTQVNfU0tJTk5ZX0lOVF9DTURTKTsK
CX0gZWxzZQoJCXNlbWFfaW5pdCgmaW5zdGFuY2UtPmlvY3RsX3NlbSwgTUVHQVNBU19JTlRfQ01E
Uyk7CgoJbWVnYXNhc19kYmdfbHZsID0gMDsKCWluc3RhbmNlLT5mbGFnID0gMDsKCWluc3RhbmNl
LT51bmxvYWQgPSAxOwoJaW5zdGFuY2UtPmxhc3RfdGltZSA9IDA7CglpbnN0YW5jZS0+ZGlzYWJs
ZU9ubGluZUN0cmxSZXNldCA9IDE7CgoJSU5JVF9XT1JLKCZpbnN0YW5jZS0+d29ya19pbml0LCBw
cm9jZXNzX2Z3X3N0YXRlX2NoYW5nZV93cSk7CgoJLyoKCSAqIEluaXRpYWxpemUgTUZJIEZpcm13
YXJlCgkgKi8KCWlmIChtZWdhc2FzX2luaXRfbWZpKGluc3RhbmNlKSkKCQlnb3RvIGZhaWxfaW5p
dF9tZmk7CgoJLyoKCSAqIFJlZ2lzdGVyIElSUQoJICovCglpZiAocmVxdWVzdF9pcnEocGRldi0+
aXJxLCBtZWdhc2FzX2lzciwgSVJRRl9TSEFSRUQsICJtZWdhc2FzIiwgaW5zdGFuY2UpKSB7CgkJ
cHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byByZWdpc3RlciBJUlFcbiIpOwoJ
CWdvdG8gZmFpbF9pcnE7Cgl9CgoJaW5zdGFuY2UtPmluc3RhbmNldC0+ZW5hYmxlX2ludHIoaW5z
dGFuY2UtPnJlZ19zZXQpOwoKCS8qCgkgKiBTdG9yZSBpbnN0YW5jZSBpbiBQQ0kgc29mdHN0YXRl
CgkgKi8KCXBjaV9zZXRfZHJ2ZGF0YShwZGV2LCBpbnN0YW5jZSk7CgoJLyoKCSAqIEFkZCB0aGlz
IGNvbnRyb2xsZXIgdG8gbWVnYXNhc19tZ210X2luZm8gc3RydWN0dXJlIHNvIHRoYXQgaXQKCSAq
IGNhbiBiZSBleHBvcnRlZCB0byBtYW5hZ2VtZW50IGFwcGxpY2F0aW9ucwoJICovCgltZWdhc2Fz
X21nbXRfaW5mby5jb3VudCsrOwoJbWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbbWVnYXNhc19t
Z210X2luZm8ubWF4X2luZGV4XSA9IGluc3RhbmNlOwoJbWVnYXNhc19tZ210X2luZm8ubWF4X2lu
ZGV4Kys7CgoJLyoKCSAqIEluaXRpYXRlIEFFTiAoQXN5bmNocm9ub3VzIEV2ZW50IE5vdGlmaWNh
dGlvbikKCSAqLwoJaWYgKG1lZ2FzYXNfc3RhcnRfYWVuKGluc3RhbmNlKSkgewoJCXByaW50ayhL
RVJOX0RFQlVHICJtZWdhc2FzOiBzdGFydCBhZW4gZmFpbGVkXG4iKTsKCQlnb3RvIGZhaWxfc3Rh
cnRfYWVuOwoJfQoKCS8qCgkgKiBSZWdpc3RlciB3aXRoIFNDU0kgbWlkLWxheWVyCgkgKi8KCWlm
IChtZWdhc2FzX2lvX2F0dGFjaChpbnN0YW5jZSkpCgkJZ290byBmYWlsX2lvX2F0dGFjaDsKCglp
bnN0YW5jZS0+dW5sb2FkID0gMDsKCXJldHVybiAwOwoKICAgICAgZmFpbF9zdGFydF9hZW46CiAg
ICAgIGZhaWxfaW9fYXR0YWNoOgoJbWVnYXNhc19tZ210X2luZm8uY291bnQtLTsKCW1lZ2FzYXNf
bWdtdF9pbmZvLmluc3RhbmNlW21lZ2FzYXNfbWdtdF9pbmZvLm1heF9pbmRleF0gPSBOVUxMOwoJ
bWVnYXNhc19tZ210X2luZm8ubWF4X2luZGV4LS07CgoJcGNpX3NldF9kcnZkYXRhKHBkZXYsIE5V
TEwpOwoJaW5zdGFuY2UtPmluc3RhbmNldC0+ZGlzYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0
KTsKCWZyZWVfaXJxKGluc3RhbmNlLT5wZGV2LT5pcnEsIGluc3RhbmNlKTsKCgltZWdhc2FzX3Jl
bGVhc2VfbWZpKGluc3RhbmNlKTsKCiAgICAgIGZhaWxfaXJxOgogICAgICBmYWlsX2luaXRfbWZp
OgogICAgICBmYWlsX2FsbG9jX2RtYV9idWY6CglpZiAoaW5zdGFuY2UtPmV2dF9kZXRhaWwpCgkJ
cGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfZXZ0X2RldGFp
bCksCgkJCQkgICAgaW5zdGFuY2UtPmV2dF9kZXRhaWwsCgkJCQkgICAgaW5zdGFuY2UtPmV2dF9k
ZXRhaWxfaCk7CgoJaWYgKGluc3RhbmNlLT5wcm9kdWNlcikKCQlwY2lfZnJlZV9jb25zaXN0ZW50
KHBkZXYsIHNpemVvZih1MzIpLCBpbnN0YW5jZS0+cHJvZHVjZXIsCgkJCQkgICAgaW5zdGFuY2Ut
PnByb2R1Y2VyX2gpOwoJaWYgKGluc3RhbmNlLT5jb25zdW1lcikKCQlwY2lfZnJlZV9jb25zaXN0
ZW50KHBkZXYsIHNpemVvZih1MzIpLCBpbnN0YW5jZS0+Y29uc3VtZXIsCgkJCQkgICAgaW5zdGFu
Y2UtPmNvbnN1bWVyX2gpOwoJc2NzaV9ob3N0X3B1dChob3N0KTsKCiAgICAgIGZhaWxfYWxsb2Nf
aW5zdGFuY2U6CiAgICAgIGZhaWxfc2V0X2RtYV9tYXNrOgoJcGNpX2Rpc2FibGVfZGV2aWNlKHBk
ZXYpOwoKCXJldHVybiAtRU5PREVWOwp9CgovKioKICogbWVnYXNhc19mbHVzaF9jYWNoZSAtCVJl
cXVlc3RzIEZXIHRvIGZsdXNoIGFsbCBpdHMgY2FjaGVzCiAqIEBpbnN0YW5jZToJCQlBZGFwdGVy
IHNvZnQgc3RhdGUKICovCnN0YXRpYyB2b2lkIG1lZ2FzYXNfZmx1c2hfY2FjaGUoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQp7CglzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKCXN0
cnVjdCBtZWdhc2FzX2RjbWRfZnJhbWUgKmRjbWQ7CgoJaWYgKGluc3RhbmNlLT5hZHByZWNvdmVy
eSA9PSBNRUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SKQoJCXJldHVybjsKCgljbWQgPSBtZWdhc2Fz
X2dldF9jbWQoaW5zdGFuY2UpOwoKCWlmICghY21kKQoJCXJldHVybjsKCglkY21kID0gJmNtZC0+
ZnJhbWUtPmRjbWQ7CgoJbWVtc2V0KGRjbWQtPm1ib3guYiwgMCwgTUZJX01CT1hfU0laRSk7CgoJ
ZGNtZC0+Y21kID0gTUZJX0NNRF9EQ01EOwoJZGNtZC0+Y21kX3N0YXR1cyA9IDB4MDsKCWRjbWQt
PnNnZV9jb3VudCA9IDA7CglkY21kLT5mbGFncyA9IE1GSV9GUkFNRV9ESVJfTk9ORTsKCWRjbWQt
PnRpbWVvdXQgPSAwOwoJZGNtZC0+cGFkXzAgPSAwOwoJZGNtZC0+ZGF0YV94ZmVyX2xlbiA9IDA7
CglkY21kLT5vcGNvZGUgPSBNUl9EQ01EX0NUUkxfQ0FDSEVfRkxVU0g7CglkY21kLT5tYm94LmJb
MF0gPSBNUl9GTFVTSF9DVFJMX0NBQ0hFIHwgTVJfRkxVU0hfRElTS19DQUNIRTsKCgltZWdhc2Fz
X2lzc3VlX2Jsb2NrZWRfY21kKGluc3RhbmNlLCBjbWQpOwoKCW1lZ2FzYXNfcmV0dXJuX2NtZChp
bnN0YW5jZSwgY21kKTsKCglyZXR1cm47Cn0KCi8qKgogKiBtZWdhc2FzX3NodXRkb3duX2NvbnRy
b2xsZXIgLQlJbnN0cnVjdHMgRlcgdG8gc2h1dGRvd24gdGhlIGNvbnRyb2xsZXIKICogQGluc3Rh
bmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKICogQG9wY29kZToJCQkJU2h1dGRvd24vSGliZXJu
YXRlCiAqLwpzdGF0aWMgdm9pZCBtZWdhc2FzX3NodXRkb3duX2NvbnRyb2xsZXIoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAoJCQkJCXUzMiBvcGNvZGUpCnsKCXN0cnVjdCBtZWdh
c2FzX2NtZCAqY21kOwoJc3RydWN0IG1lZ2FzYXNfZGNtZF9mcmFtZSAqZGNtZDsKCglpZiAoaW5z
dGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1IpCgkJcmV0dXJu
OwoKCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CgoJaWYgKCFjbWQpCgkJcmV0dXJu
OwoKCWlmIChpbnN0YW5jZS0+YWVuX2NtZCkKCQltZWdhc2FzX2lzc3VlX2Jsb2NrZWRfYWJvcnRf
Y21kKGluc3RhbmNlLCBpbnN0YW5jZS0+YWVuX2NtZCk7CgoJZGNtZCA9ICZjbWQtPmZyYW1lLT5k
Y21kOwoKCW1lbXNldChkY21kLT5tYm94LmIsIDAsIE1GSV9NQk9YX1NJWkUpOwoKCWRjbWQtPmNt
ZCA9IE1GSV9DTURfRENNRDsKCWRjbWQtPmNtZF9zdGF0dXMgPSAweDA7CglkY21kLT5zZ2VfY291
bnQgPSAwOwoJZGNtZC0+ZmxhZ3MgPSBNRklfRlJBTUVfRElSX05PTkU7CglkY21kLT50aW1lb3V0
ID0gMDsKCWRjbWQtPnBhZF8wID0gMDsKCWRjbWQtPmRhdGFfeGZlcl9sZW4gPSAwOwoJZGNtZC0+
b3Bjb2RlID0gb3Bjb2RlOwoKCW1lZ2FzYXNfaXNzdWVfYmxvY2tlZF9jbWQoaW5zdGFuY2UsIGNt
ZCk7CgoJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwoKCXJldHVybjsKfQoKI2lm
ZGVmIENPTkZJR19QTQovKioKICogbWVnYXNhc19zdXNwZW5kIC0JZHJpdmVyIHN1c3BlbmQgZW50
cnkgcG9pbnQKICogQHBkZXY6CQlQQ0kgZGV2aWNlIHN0cnVjdHVyZQogKiBAc3RhdGU6CQlQQ0kg
cG93ZXIgc3RhdGUgdG8gc3VzcGVuZCByb3V0aW5lCiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfc3Vz
cGVuZChzdHJ1Y3QgcGNpX2RldiAqcGRldiwgcG1fbWVzc2FnZV90IHN0YXRlKQp7CglzdHJ1Y3Qg
U2NzaV9Ib3N0ICpob3N0OwoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOwoKCWlu
c3RhbmNlID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOwoJaG9zdCA9IGluc3RhbmNlLT5ob3N0OwoJ
aW5zdGFuY2UtPnVubG9hZCA9IDE7CgoJaWYgKHBvbGxfbW9kZV9pbykKCQlkZWxfdGltZXJfc3lu
YygmaW5zdGFuY2UtPmlvX2NvbXBsZXRpb25fdGltZXIpOwoKCW1lZ2FzYXNfZmx1c2hfY2FjaGUo
aW5zdGFuY2UpOwoJbWVnYXNhc19zaHV0ZG93bl9jb250cm9sbGVyKGluc3RhbmNlLCBNUl9EQ01E
X0hJQkVSTkFURV9TSFVURE9XTik7CgoJLyogY2FuY2VsIHRoZSBkZWxheWVkIHdvcmsgaWYgdGhp
cyB3b3JrIHN0aWxsIGluIHF1ZXVlICovCglpZiAoaW5zdGFuY2UtPmV2ICE9IE5VTEwpIHsKCQlz
dHJ1Y3QgbWVnYXNhc19hZW5fZXZlbnQgKmV2ID0gaW5zdGFuY2UtPmV2OwoJCWNhbmNlbF9kZWxh
eWVkX3dvcmsoCgkJCShzdHJ1Y3QgZGVsYXllZF93b3JrICopJmV2LT5ob3RwbHVnX3dvcmspOwoJ
CWZsdXNoX3NjaGVkdWxlZF93b3JrKCk7CgkJaW5zdGFuY2UtPmV2ID0gTlVMTDsKCX0KCgl0YXNr
bGV0X2tpbGwoJmluc3RhbmNlLT5pc3JfdGFza2xldCk7CgoJcGNpX3NldF9kcnZkYXRhKGluc3Rh
bmNlLT5wZGV2LCBpbnN0YW5jZSk7CglpbnN0YW5jZS0+aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIo
aW5zdGFuY2UtPnJlZ19zZXQpOwoJZnJlZV9pcnEoaW5zdGFuY2UtPnBkZXYtPmlycSwgaW5zdGFu
Y2UpOwoKCXBjaV9zYXZlX3N0YXRlKHBkZXYpOwoJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOwoK
CXBjaV9zZXRfcG93ZXJfc3RhdGUocGRldiwgcGNpX2Nob29zZV9zdGF0ZShwZGV2LCBzdGF0ZSkp
OwoKCXJldHVybiAwOwp9CgovKioKICogbWVnYXNhc19yZXN1bWUtICAgICAgZHJpdmVyIHJlc3Vt
ZSBlbnRyeSBwb2ludAogKiBAcGRldjogICAgICAgICAgICAgICBQQ0kgZGV2aWNlIHN0cnVjdHVy
ZQogKi8Kc3RhdGljIGludAptZWdhc2FzX3Jlc3VtZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKewoJ
aW50IHJ2YWw7CglzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0OwoJc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlOwoKCWluc3RhbmNlID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOwoJaG9zdCA9
IGluc3RhbmNlLT5ob3N0OwoJcGNpX3NldF9wb3dlcl9zdGF0ZShwZGV2LCBQQ0lfRDApOwoJcGNp
X2VuYWJsZV93YWtlKHBkZXYsIFBDSV9EMCwgMCk7CglwY2lfcmVzdG9yZV9zdGF0ZShwZGV2KTsK
CgkvKgoJICogUENJIHByZXBwaW5nOiBlbmFibGUgZGV2aWNlIHNldCBidXMgbWFzdGVyaW5nIGFu
ZCBkbWEgbWFzawoJICovCglydmFsID0gcGNpX2VuYWJsZV9kZXZpY2VfbWVtKHBkZXYpOwoKCWlm
IChydmFsKSB7CgkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBFbmFibGUgZGV2aWNlIGZhaWxl
ZFxuIik7CgkJcmV0dXJuIHJ2YWw7Cgl9CgoJcGNpX3NldF9tYXN0ZXIocGRldik7CgoJaWYgKG1l
Z2FzYXNfc2V0X2RtYV9tYXNrKHBkZXYpKQoJCWdvdG8gZmFpbF9zZXRfZG1hX21hc2s7CgoJLyoK
CSAqIEluaXRpYWxpemUgTUZJIEZpcm13YXJlCgkgKi8KCgkqaW5zdGFuY2UtPnByb2R1Y2VyID0g
MDsKCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAwOwoKCWF0b21pY19zZXQoJmluc3RhbmNlLT5md19v
dXRzdGFuZGluZywgMCk7CgoJLyoKCSAqIFdlIGV4cGVjdCB0aGUgRlcgc3RhdGUgdG8gYmUgUkVB
RFkKCSAqLwoJaWYgKG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShpbnN0YW5jZSkpCgkJZ290
byBmYWlsX3JlYWR5X3N0YXRlOwoKCWlmIChtZWdhc2FzX2lzc3VlX2luaXRfbWZpKGluc3RhbmNl
KSkKCQlnb3RvIGZhaWxfaW5pdF9tZmk7CgoJdGFza2xldF9pbml0KCZpbnN0YW5jZS0+aXNyX3Rh
c2tsZXQsIG1lZ2FzYXNfY29tcGxldGVfY21kX2RwYywKCQkJKHVuc2lnbmVkIGxvbmcpaW5zdGFu
Y2UpOwoKCS8qCgkgKiBSZWdpc3RlciBJUlEKCSAqLwoJaWYgKHJlcXVlc3RfaXJxKHBkZXYtPmly
cSwgbWVnYXNhc19pc3IsIElSUUZfU0hBUkVELAoJCSJtZWdhc2FzIiwgaW5zdGFuY2UpKSB7CgkJ
cHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBGYWlsZWQgdG8gcmVnaXN0ZXIgSVJRXG4iKTsKCQln
b3RvIGZhaWxfaXJxOwoJfQoKCWluc3RhbmNlLT5pbnN0YW5jZXQtPmVuYWJsZV9pbnRyKGluc3Rh
bmNlLT5yZWdfc2V0KTsKCgkvKgoJICogSW5pdGlhdGUgQUVOIChBc3luY2hyb25vdXMgRXZlbnQg
Tm90aWZpY2F0aW9uKQoJICovCglpZiAobWVnYXNhc19zdGFydF9hZW4oaW5zdGFuY2UpKQoJCXBy
aW50ayhLRVJOX0VSUiAibWVnYXNhczogU3RhcnQgQUVOIGZhaWxlZFxuIik7CgoJLyogSW5pdGlh
bGl6ZSB0aGUgY21kIGNvbXBsZXRpb24gdGltZXIgKi8KCWlmIChwb2xsX21vZGVfaW8pCgkJbWVn
YXNhc19zdGFydF90aW1lcihpbnN0YW5jZSwgJmluc3RhbmNlLT5pb19jb21wbGV0aW9uX3RpbWVy
LAoJCQkJbWVnYXNhc19pb19jb21wbGV0aW9uX3RpbWVyLAoJCQkJTUVHQVNBU19DT01QTEVUSU9O
X1RJTUVSX0lOVEVSVkFMKTsKCWluc3RhbmNlLT51bmxvYWQgPSAwOwoKCXJldHVybiAwOwoKZmFp
bF9pcnE6CmZhaWxfaW5pdF9tZmk6CglpZiAoaW5zdGFuY2UtPmV2dF9kZXRhaWwpCgkJcGNpX2Zy
ZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfZXZ0X2RldGFpbCksCgkJ
CQlpbnN0YW5jZS0+ZXZ0X2RldGFpbCwKCQkJCWluc3RhbmNlLT5ldnRfZGV0YWlsX2gpOwoKCWlm
IChpbnN0YW5jZS0+cHJvZHVjZXIpCgkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2Yo
dTMyKSwgaW5zdGFuY2UtPnByb2R1Y2VyLAoJCQkJaW5zdGFuY2UtPnByb2R1Y2VyX2gpOwoJaWYg
KGluc3RhbmNlLT5jb25zdW1lcikKCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1
MzIpLCBpbnN0YW5jZS0+Y29uc3VtZXIsCgkJCQlpbnN0YW5jZS0+Y29uc3VtZXJfaCk7CglzY3Np
X2hvc3RfcHV0KGhvc3QpOwoKZmFpbF9zZXRfZG1hX21hc2s6CmZhaWxfcmVhZHlfc3RhdGU6CgoJ
cGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOwoKCXJldHVybiAtRU5PREVWOwp9CiNlbHNlCiNkZWZp
bmUgbWVnYXNhc19zdXNwZW5kCU5VTEwKI2RlZmluZSBtZWdhc2FzX3Jlc3VtZQlOVUxMCiNlbmRp
ZgoKLyoqCiAqIG1lZ2FzYXNfZGV0YWNoX29uZSAtCVBDSSBob3QidW4icGx1ZyBlbnRyeSBwb2lu
dAogKiBAcGRldjoJCVBDSSBkZXZpY2Ugc3RydWN0dXJlCiAqLwpzdGF0aWMgdm9pZCBfX2RldmV4
aXQgbWVnYXNhc19kZXRhY2hfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQp7CglpbnQgaTsKCXN0
cnVjdCBTY3NpX0hvc3QgKmhvc3Q7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2U7
CgoJaW5zdGFuY2UgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7CglpbnN0YW5jZS0+dW5sb2FkID0g
MTsKCWhvc3QgPSBpbnN0YW5jZS0+aG9zdDsKCglpZiAocG9sbF9tb2RlX2lvKQoJCWRlbF90aW1l
cl9zeW5jKCZpbnN0YW5jZS0+aW9fY29tcGxldGlvbl90aW1lcik7CgoJc2NzaV9yZW1vdmVfaG9z
dChpbnN0YW5jZS0+aG9zdCk7CgltZWdhc2FzX2ZsdXNoX2NhY2hlKGluc3RhbmNlKTsKCW1lZ2Fz
YXNfc2h1dGRvd25fY29udHJvbGxlcihpbnN0YW5jZSwgTVJfRENNRF9DVFJMX1NIVVRET1dOKTsK
CgkvKiBjYW5jZWwgdGhlIGRlbGF5ZWQgd29yayBpZiB0aGlzIHdvcmsgc3RpbGwgaW4gcXVldWUq
LwoJaWYgKGluc3RhbmNlLT5ldiAhPSBOVUxMKSB7CgkJc3RydWN0IG1lZ2FzYXNfYWVuX2V2ZW50
ICpldiA9IGluc3RhbmNlLT5ldjsKCQljYW5jZWxfZGVsYXllZF93b3JrKAoJCQkoc3RydWN0IGRl
bGF5ZWRfd29yayAqKSZldi0+aG90cGx1Z193b3JrKTsKCQlmbHVzaF9zY2hlZHVsZWRfd29yaygp
OwoJCWluc3RhbmNlLT5ldiA9IE5VTEw7Cgl9CgoJdGFza2xldF9raWxsKCZpbnN0YW5jZS0+aXNy
X3Rhc2tsZXQpOwoKCS8qCgkgKiBUYWtlIHRoZSBpbnN0YW5jZSBvZmYgdGhlIGluc3RhbmNlIGFy
cmF5LiBOb3RlIHRoYXQgd2Ugd2lsbCBub3QKCSAqIGRlY3JlbWVudCB0aGUgbWF4X2luZGV4LiBX
ZSBsZXQgdGhpcyBhcnJheSBiZSBzcGFyc2UgYXJyYXkKCSAqLwoJZm9yIChpID0gMDsgaSA8IG1l
Z2FzYXNfbWdtdF9pbmZvLm1heF9pbmRleDsgaSsrKSB7CgkJaWYgKG1lZ2FzYXNfbWdtdF9pbmZv
Lmluc3RhbmNlW2ldID09IGluc3RhbmNlKSB7CgkJCW1lZ2FzYXNfbWdtdF9pbmZvLmNvdW50LS07
CgkJCW1lZ2FzYXNfbWdtdF9pbmZvLmluc3RhbmNlW2ldID0gTlVMTDsKCgkJCWJyZWFrOwoJCX0K
CX0KCglwY2lfc2V0X2RydmRhdGEoaW5zdGFuY2UtPnBkZXYsIE5VTEwpOwoKCWluc3RhbmNlLT5p
bnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7CgoJZnJlZV9pcnEoaW5z
dGFuY2UtPnBkZXYtPmlycSwgaW5zdGFuY2UpOwoKCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFu
Y2UpOwoKCXBjaV9mcmVlX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2V2
dF9kZXRhaWwpLAoJCQkgICAgaW5zdGFuY2UtPmV2dF9kZXRhaWwsIGluc3RhbmNlLT5ldnRfZGV0
YWlsX2gpOwoKCXBjaV9mcmVlX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksIGluc3RhbmNl
LT5wcm9kdWNlciwKCQkJICAgIGluc3RhbmNlLT5wcm9kdWNlcl9oKTsKCglwY2lfZnJlZV9jb25z
aXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLCBpbnN0YW5jZS0+Y29uc3VtZXIsCgkJCSAgICBpbnN0
YW5jZS0+Y29uc3VtZXJfaCk7CgoJc2NzaV9ob3N0X3B1dChob3N0KTsKCglwY2lfc2V0X2RydmRh
dGEocGRldiwgTlVMTCk7CgoJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOwoKCXJldHVybjsKfQoK
LyoqCiAqIG1lZ2FzYXNfc2h1dGRvd24gLQlTaHV0ZG93biBlbnRyeSBwb2ludAogKiBAZGV2aWNl
OgkJR2VuZXJpYyBkZXZpY2Ugc3RydWN0dXJlCiAqLwpzdGF0aWMgdm9pZCBtZWdhc2FzX3NodXRk
b3duKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQp7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7CglpbnN0YW5jZS0+dW5sb2FkID0gMTsKCW1l
Z2FzYXNfZmx1c2hfY2FjaGUoaW5zdGFuY2UpOwoJbWVnYXNhc19zaHV0ZG93bl9jb250cm9sbGVy
KGluc3RhbmNlLCBNUl9EQ01EX0NUUkxfU0hVVERPV04pOwp9CgovKioKICogbWVnYXNhc19tZ210
X29wZW4gLQljaGFyIG5vZGUgIm9wZW4iIGVudHJ5IHBvaW50CiAqLwpzdGF0aWMgaW50IG1lZ2Fz
YXNfbWdtdF9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlcCkKewoJ
Y3ljbGVfa2VybmVsX2xvY2soKTsKCS8qCgkgKiBBbGxvdyBvbmx5IHRob3NlIHVzZXJzIHdpdGgg
YWRtaW4gcmlnaHRzCgkgKi8KCWlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSkKCQlyZXR1cm4g
LUVBQ0NFUzsKCglyZXR1cm4gMDsKfQoKLyoqCiAqIG1lZ2FzYXNfbWdtdF9mYXN5bmMgLQlBc3lu
YyBub3RpZmllciByZWdpc3RyYXRpb24gZnJvbSBhcHBsaWNhdGlvbnMKICoKICogVGhpcyBmdW5j
dGlvbiBhZGRzIHRoZSBjYWxsaW5nIHByb2Nlc3MgdG8gYSBkcml2ZXIgZ2xvYmFsIHF1ZXVlLiBX
aGVuIGFuCiAqIGV2ZW50IG9jY3VycywgU0lHSU8gd2lsbCBiZSBzZW50IHRvIGFsbCBwcm9jZXNz
ZXMgaW4gdGhpcyBxdWV1ZS4KICovCnN0YXRpYyBpbnQgbWVnYXNhc19tZ210X2Zhc3luYyhpbnQg
ZmQsIHN0cnVjdCBmaWxlICpmaWxlcCwgaW50IG1vZGUpCnsKCWludCByYzsKCgltdXRleF9sb2Nr
KCZtZWdhc2FzX2FzeW5jX3F1ZXVlX211dGV4KTsKCglyYyA9IGZhc3luY19oZWxwZXIoZmQsIGZp
bGVwLCBtb2RlLCAmbWVnYXNhc19hc3luY19xdWV1ZSk7CgoJbXV0ZXhfdW5sb2NrKCZtZWdhc2Fz
X2FzeW5jX3F1ZXVlX211dGV4KTsKCglpZiAocmMgPj0gMCkgewoJCS8qIEZvciBzYW5pdHkgY2hl
Y2sgd2hlbiB3ZSBnZXQgaW9jdGwgKi8KCQlmaWxlcC0+cHJpdmF0ZV9kYXRhID0gZmlsZXA7CgkJ
cmV0dXJuIDA7Cgl9CgoJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IGZhc3luY19oZWxwZXIg
ZmFpbGVkIFslZF1cbiIsIHJjKTsKCglyZXR1cm4gcmM7Cn0KCi8qKgogKiBtZWdhc2FzX21nbXRf
cG9sbCAtICBjaGFyIG5vZGUgInBvbGwiIGVudHJ5IHBvaW50CiAqICovCnN0YXRpYyB1bnNpZ25l
ZCBpbnQgbWVnYXNhc19tZ210X3BvbGwoc3RydWN0IGZpbGUgKmZpbGUsIHBvbGxfdGFibGUgKndh
aXQpCnsKCXVuc2lnbmVkIGludCBtYXNrOwoJdW5zaWduZWQgbG9uZyBmbGFnczsKCXBvbGxfd2Fp
dChmaWxlLCAmbWVnYXNhc19wb2xsX3dhaXQsIHdhaXQpOwoJc3Bpbl9sb2NrX2lycXNhdmUoJnBv
bGxfYWVuX2xvY2ssIGZsYWdzKTsKCWlmIChtZWdhc2FzX3BvbGxfd2FpdF9hZW4pCgkJbWFzayA9
ICAgKFBPTExJTiB8IFBPTExSRE5PUk0pOwoJZWxzZQoJCW1hc2sgPSAwOwoJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmcG9sbF9hZW5fbG9jaywgZmxhZ3MpOwoJcmV0dXJuIG1hc2s7Cn0KCi8qKgog
KiBtZWdhc2FzX21nbXRfZndfaW9jdGwgLQlJc3N1ZXMgbWFuYWdlbWVudCBpb2N0bHMgdG8gRlcK
ICogQGluc3RhbmNlOgkJCUFkYXB0ZXIgc29mdCBzdGF0ZQogKiBAYXJncDoJCQlVc2VyJ3MgaW9j
dGwgcGFja2V0CiAqLwpzdGF0aWMgaW50Cm1lZ2FzYXNfbWdtdF9md19pb2N0bChzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCgkJICAgICAgc3RydWN0IG1lZ2FzYXNfaW9jcGFja2V0
IF9fdXNlciAqIHVzZXJfaW9jLAoJCSAgICAgIHN0cnVjdCBtZWdhc2FzX2lvY3BhY2tldCAqaW9j
KQp7CglzdHJ1Y3QgbWVnYXNhc19zZ2UzMiAqa2Vybl9zZ2UzMjsKCXN0cnVjdCBtZWdhc2FzX2Nt
ZCAqY21kOwoJdm9pZCAqa2J1ZmZfYXJyW01BWF9JT0NUTF9TR0VdOwoJZG1hX2FkZHJfdCBidWZf
aGFuZGxlID0gMDsKCWludCBlcnJvciA9IDAsIGk7Cgl2b2lkICpzZW5zZSA9IE5VTEw7CglkbWFf
YWRkcl90IHNlbnNlX2hhbmRsZTsKCXVuc2lnbmVkIGxvbmcgKnNlbnNlX3B0cjsKCgltZW1zZXQo
a2J1ZmZfYXJyLCAwLCBzaXplb2Yoa2J1ZmZfYXJyKSk7CgoJaWYgKGlvYy0+c2dlX2NvdW50ID4g
TUFYX0lPQ1RMX1NHRSkgewoJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBTR0UgY291bnQg
WyVkXSA+ICBtYXggbGltaXQgWyVkXVxuIiwKCQkgICAgICAgaW9jLT5zZ2VfY291bnQsIE1BWF9J
T0NUTF9TR0UpOwoJCXJldHVybiAtRUlOVkFMOwoJfQoKCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZChp
bnN0YW5jZSk7CglpZiAoIWNtZCkgewoJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWls
ZWQgdG8gZ2V0IGEgY21kIHBhY2tldFxuIik7CgkJcmV0dXJuIC1FTk9NRU07Cgl9CgoJLyoKCSAq
IFVzZXIncyBJT0NUTCBwYWNrZXQgaGFzIDIgZnJhbWVzIChtYXhpbXVtKS4gQ29weSB0aG9zZSB0
d28KCSAqIGZyYW1lcyBpbnRvIG91ciBjbWQncyBmcmFtZXMuIGNtZC0+ZnJhbWUncyBjb250ZXh0
IHdpbGwgZ2V0CgkgKiBvdmVyd3JpdHRlbiB3aGVuIHdlIGNvcHkgZnJvbSB1c2VyJ3MgZnJhbWVz
LiBTbyBzZXQgdGhhdCB2YWx1ZQoJICogYWxvbmUgc2VwYXJhdGVseQoJICovCgltZW1jcHkoY21k
LT5mcmFtZSwgaW9jLT5mcmFtZS5yYXcsIDIgKiBNRUdBTUZJX0ZSQU1FX1NJWkUpOwoJY21kLT5m
cmFtZS0+aGRyLmNvbnRleHQgPSBjbWQtPmluZGV4OwoJY21kLT5mcmFtZS0+aGRyLnBhZF8wID0g
MDsKCgkvKgoJICogVGhlIG1hbmFnZW1lbnQgaW50ZXJmYWNlIGJldHdlZW4gYXBwbGljYXRpb25z
IGFuZCB0aGUgZncgdXNlcwoJICogTUZJIGZyYW1lcy4gRS5nLCBSQUlEIGNvbmZpZ3VyYXRpb24g
Y2hhbmdlcywgTEQgcHJvcGVydHkgY2hhbmdlcwoJICogZXRjIGFyZSBhY2NvbXBsaXNoZXMgdGhy
b3VnaCBkaWZmZXJlbnQga2luZHMgb2YgTUZJIGZyYW1lcy4gVGhlCgkgKiBkcml2ZXIgbmVlZHMg
dG8gY2FyZSBvbmx5IGFib3V0IHN1YnN0aXR1dGluZyB1c2VyIGJ1ZmZlcnMgd2l0aAoJICoga2Vy
bmVsIGJ1ZmZlcnMgaW4gU0dMcy4gVGhlIGxvY2F0aW9uIG9mIFNHTCBpcyBlbWJlZGRlZCBpbiB0
aGUKCSAqIHN0cnVjdCBpb2NwYWNrZXQgaXRzZWxmLgoJICovCglrZXJuX3NnZTMyID0gKHN0cnVj
dCBtZWdhc2FzX3NnZTMyICopCgkgICAgKCh1bnNpZ25lZCBsb25nKWNtZC0+ZnJhbWUgKyBpb2Mt
PnNnbF9vZmYpOwoKCS8qCgkgKiBGb3IgZWFjaCB1c2VyIGJ1ZmZlciwgY3JlYXRlIGEgbWlycm9y
IGJ1ZmZlciBhbmQgY29weSBpbgoJICovCglmb3IgKGkgPSAwOyBpIDwgaW9jLT5zZ2VfY291bnQ7
IGkrKykgewoJCWtidWZmX2FycltpXSA9IGRtYV9hbGxvY19jb2hlcmVudCgmaW5zdGFuY2UtPnBk
ZXYtPmRldiwKCQkJCQkJICAgIGlvYy0+c2dsW2ldLmlvdl9sZW4sCgkJCQkJCSAgICAmYnVmX2hh
bmRsZSwgR0ZQX0tFUk5FTCk7CgkJaWYgKCFrYnVmZl9hcnJbaV0pIHsKCQkJcHJpbnRrKEtFUk5f
REVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBhbGxvYyAiCgkJCSAgICAgICAia2VybmVsIFNHTCBi
dWZmZXIgZm9yIElPQ1RMIFxuIik7CgkJCWVycm9yID0gLUVOT01FTTsKCQkJZ290byBvdXQ7CgkJ
fQoKCQkvKgoJCSAqIFdlIGRvbid0IGNoYW5nZSB0aGUgZG1hX2NvaGVyZW50X21hc2ssIHNvCgkJ
ICogcGNpX2FsbG9jX2NvbnNpc3RlbnQgb25seSByZXR1cm5zIDMyYml0IGFkZHJlc3NlcwoJCSAq
LwoJCWtlcm5fc2dlMzJbaV0ucGh5c19hZGRyID0gKHUzMikgYnVmX2hhbmRsZTsKCQlrZXJuX3Nn
ZTMyW2ldLmxlbmd0aCA9IGlvYy0+c2dsW2ldLmlvdl9sZW47CgoJCS8qCgkJICogV2UgY3JlYXRl
ZCBhIGtlcm5lbCBidWZmZXIgY29ycmVzcG9uZGluZyB0byB0aGUKCQkgKiB1c2VyIGJ1ZmZlci4g
Tm93IGNvcHkgaW4gZnJvbSB0aGUgdXNlciBidWZmZXIKCQkgKi8KCQlpZiAoY29weV9mcm9tX3Vz
ZXIoa2J1ZmZfYXJyW2ldLCBpb2MtPnNnbFtpXS5pb3ZfYmFzZSwKCQkJCSAgICh1MzIpIChpb2Mt
PnNnbFtpXS5pb3ZfbGVuKSkpIHsKCQkJZXJyb3IgPSAtRUZBVUxUOwoJCQlnb3RvIG91dDsKCQl9
Cgl9CgoJaWYgKGlvYy0+c2Vuc2VfbGVuKSB7CgkJc2Vuc2UgPSBkbWFfYWxsb2NfY29oZXJlbnQo
Jmluc3RhbmNlLT5wZGV2LT5kZXYsIGlvYy0+c2Vuc2VfbGVuLAoJCQkJCSAgICAgJnNlbnNlX2hh
bmRsZSwgR0ZQX0tFUk5FTCk7CgkJaWYgKCFzZW5zZSkgewoJCQllcnJvciA9IC1FTk9NRU07CgkJ
CWdvdG8gb3V0OwoJCX0KCgkJc2Vuc2VfcHRyID0KCQkodW5zaWduZWQgbG9uZyAqKSAoKHVuc2ln
bmVkIGxvbmcpY21kLT5mcmFtZSArIGlvYy0+c2Vuc2Vfb2ZmKTsKCQkqc2Vuc2VfcHRyID0gc2Vu
c2VfaGFuZGxlOwoJfQoKCS8qCgkgKiBTZXQgdGhlIHN5bmNfY21kIGZsYWcgc28gdGhhdCB0aGUg
SVNSIGtub3dzIG5vdCB0byBjb21wbGV0ZSB0aGlzCgkgKiBjbWQgdG8gdGhlIFNDU0kgbWlkLWxh
eWVyCgkgKi8KCWNtZC0+c3luY19jbWQgPSAxOwoJbWVnYXNhc19pc3N1ZV9ibG9ja2VkX2NtZChp
bnN0YW5jZSwgY21kKTsKCWNtZC0+c3luY19jbWQgPSAwOwoKCS8qCgkgKiBjb3B5IG91dCB0aGUg
a2VybmVsIGJ1ZmZlcnMgdG8gdXNlciBidWZmZXJzCgkgKi8KCWZvciAoaSA9IDA7IGkgPCBpb2Mt
PnNnZV9jb3VudDsgaSsrKSB7CgkJaWYgKGNvcHlfdG9fdXNlcihpb2MtPnNnbFtpXS5pb3ZfYmFz
ZSwga2J1ZmZfYXJyW2ldLAoJCQkJIGlvYy0+c2dsW2ldLmlvdl9sZW4pKSB7CgkJCWVycm9yID0g
LUVGQVVMVDsKCQkJZ290byBvdXQ7CgkJfQoJfQoKCS8qCgkgKiBjb3B5IG91dCB0aGUgc2Vuc2UK
CSAqLwoJaWYgKGlvYy0+c2Vuc2VfbGVuKSB7CgkJLyoKCQkgKiBzZW5zZV9wdHIgcG9pbnRzIHRv
IHRoZSBsb2NhdGlvbiB0aGF0IGhhcyB0aGUgdXNlcgoJCSAqIHNlbnNlIGJ1ZmZlciBhZGRyZXNz
CgkJICovCgkJc2Vuc2VfcHRyID0gKHVuc2lnbmVkIGxvbmcgKikgKCh1bnNpZ25lZCBsb25nKWlv
Yy0+ZnJhbWUucmF3ICsKCQkJCWlvYy0+c2Vuc2Vfb2ZmKTsKCgkJaWYgKGNvcHlfdG9fdXNlcigo
dm9pZCBfX3VzZXIgKikoKHVuc2lnbmVkIGxvbmcpKCpzZW5zZV9wdHIpKSwKCQkJCSBzZW5zZSwg
aW9jLT5zZW5zZV9sZW4pKSB7CgkJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogRmFpbGVkIHRv
IGNvcHkgb3V0IHRvIHVzZXIgIgoJCQkJCSJzZW5zZSBkYXRhXG4iKTsKCQkJZXJyb3IgPSAtRUZB
VUxUOwoJCQlnb3RvIG91dDsKCQl9Cgl9CgoJLyoKCSAqIGNvcHkgdGhlIHN0YXR1cyBjb2RlcyBy
ZXR1cm5lZCBieSB0aGUgZncKCSAqLwoJaWYgKGNvcHlfdG9fdXNlcigmdXNlcl9pb2MtPmZyYW1l
Lmhkci5jbWRfc3RhdHVzLAoJCQkgJmNtZC0+ZnJhbWUtPmhkci5jbWRfc3RhdHVzLCBzaXplb2Yo
dTgpKSkgewoJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBFcnJvciBjb3B5aW5nIG91dCBj
bWRfc3RhdHVzXG4iKTsKCQllcnJvciA9IC1FRkFVTFQ7Cgl9CgogICAgICBvdXQ6CglpZiAoc2Vu
c2UpIHsKCQlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwgaW9jLT5zZW5z
ZV9sZW4sCgkJCQkgICAgc2Vuc2UsIHNlbnNlX2hhbmRsZSk7Cgl9CgoJZm9yIChpID0gMDsgaSA8
IGlvYy0+c2dlX2NvdW50ICYmIGtidWZmX2FycltpXTsgaSsrKSB7CgkJZG1hX2ZyZWVfY29oZXJl
bnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsCgkJCQkgICAga2Vybl9zZ2UzMltpXS5sZW5ndGgsCgkJ
CQkgICAga2J1ZmZfYXJyW2ldLCBrZXJuX3NnZTMyW2ldLnBoeXNfYWRkcik7Cgl9CgoJbWVnYXNh
c19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwoJcmV0dXJuIGVycm9yOwp9CgpzdGF0aWMgaW50
IG1lZ2FzYXNfbWdtdF9pb2N0bF9mdyhzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5zaWduZWQgbG9uZyBh
cmcpCnsKCXN0cnVjdCBtZWdhc2FzX2lvY3BhY2tldCBfX3VzZXIgKnVzZXJfaW9jID0KCSAgICAo
c3RydWN0IG1lZ2FzYXNfaW9jcGFja2V0IF9fdXNlciAqKWFyZzsKCXN0cnVjdCBtZWdhc2FzX2lv
Y3BhY2tldCAqaW9jOwoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOwoJaW50IGVy
cm9yOwoJaW50IGk7Cgl1bnNpZ25lZCBsb25nIGZsYWdzOwoJdTMyIHdhaXRfdGltZSA9IE1FR0FT
QVNfUkVTRVRfV0FJVF9USU1FOwoKCWlvYyA9IGttYWxsb2Moc2l6ZW9mKCppb2MpLCBHRlBfS0VS
TkVMKTsKCWlmICghaW9jKQoJCXJldHVybiAtRU5PTUVNOwoKCWlmIChjb3B5X2Zyb21fdXNlcihp
b2MsIHVzZXJfaW9jLCBzaXplb2YoKmlvYykpKSB7CgkJZXJyb3IgPSAtRUZBVUxUOwoJCWdvdG8g
b3V0X2tmcmVlX2lvYzsKCX0KCglpbnN0YW5jZSA9IG1lZ2FzYXNfbG9va3VwX2luc3RhbmNlKGlv
Yy0+aG9zdF9ubyk7CglpZiAoIWluc3RhbmNlKSB7CgkJZXJyb3IgPSAtRU5PREVWOwoJCWdvdG8g
b3V0X2tmcmVlX2lvYzsKCX0KCglpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNf
SFdfQ1JJVElDQUxfRVJST1IpIHsKCQlwcmludGsoS0VSTl9FUlIgIkNvbnRyb2xsZXIgaW4gY3Jp
dCBlcnJvclxuIik7CgkJZXJyb3IgPSAtRU5PREVWOwoJCWdvdG8gb3V0X2tmcmVlX2lvYzsKCX0K
CglpZiAoaW5zdGFuY2UtPnVubG9hZCA9PSAxKSB7CgkJZXJyb3IgPSAtRU5PREVWOwoJCWdvdG8g
b3V0X2tmcmVlX2lvYzsKCX0KCgkvKgoJICogV2Ugd2lsbCBhbGxvdyBvbmx5IE1FR0FTQVNfSU5U
X0NNRFMgbnVtYmVyIG9mIHBhcmFsbGVsIGlvY3RsIGNtZHMKCSAqLwoJaWYgKGRvd25faW50ZXJy
dXB0aWJsZSgmaW5zdGFuY2UtPmlvY3RsX3NlbSkpIHsKCQllcnJvciA9IC1FUkVTVEFSVFNZUzsK
CQlnb3RvIG91dF9rZnJlZV9pb2M7Cgl9CgoJZm9yIChpID0gMDsgaSA8IHdhaXRfdGltZTsgaSsr
KSB7CgoJCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKCQlp
ZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNfSEJBX09QRVJBVElPTkFMKSB7CgkJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoJCQli
cmVhazsKCQl9CgkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBm
bGFncyk7CgoJCWlmICghKGkgJSBNRUdBU0FTX1JFU0VUX05PVElDRV9JTlRFUlZBTCkpIHsKCQkJ
cHJpbnRrKEtFUk5fTk9USUNFICJtZWdhc2FzOiB3YWl0aW5nIgoJCQkJImZvciBjb250cm9sbGVy
IHJlc2V0IHRvIGZpbmlzaFxuIik7CgkJfQoKCQltc2xlZXAoMTAwMCk7Cgl9CgoJc3Bpbl9sb2Nr
X2lycXNhdmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoJaWYgKGluc3RhbmNlLT5hZHBy
ZWNvdmVyeSAhPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTCkgewoJCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwoKCQlwcmludGsoS0VSTl9FUlIgIm1l
Z2FyYWlkX3NhczogdGltZWQgb3V0IHdoaWxlIgoJCQkid2FpdGluZyBmb3IgSEJBIHRvIHJlY292
ZXJcbiIpOwoJCWVycm9yID0gLUVOT0RFVjsKCQlnb3RvIG91dF9rZnJlZV9pb2M7Cgl9CglzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKCgllcnJvciA9
IG1lZ2FzYXNfbWdtdF9md19pb2N0bChpbnN0YW5jZSwgdXNlcl9pb2MsIGlvYyk7Cgl1cCgmaW5z
dGFuY2UtPmlvY3RsX3NlbSk7CgogICAgICBvdXRfa2ZyZWVfaW9jOgoJa2ZyZWUoaW9jKTsKCXJl
dHVybiBlcnJvcjsKfQoKc3RhdGljIGludCBtZWdhc2FzX21nbXRfaW9jdGxfYWVuKHN0cnVjdCBm
aWxlICpmaWxlLCB1bnNpZ25lZCBsb25nIGFyZykKewoJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlOwoJc3RydWN0IG1lZ2FzYXNfYWVuIGFlbjsKCWludCBlcnJvcjsKCWludCBpOwoJ
dW5zaWduZWQgbG9uZyBmbGFnczsKCXUzMiB3YWl0X3RpbWUgPSBNRUdBU0FTX1JFU0VUX1dBSVRf
VElNRTsKCglpZiAoZmlsZS0+cHJpdmF0ZV9kYXRhICE9IGZpbGUpIHsKCQlwcmludGsoS0VSTl9E
RUJVRyAibWVnYXNhczogZmFzeW5jX2hlbHBlciB3YXMgbm90ICIKCQkgICAgICAgImNhbGxlZCBm
aXJzdFxuIik7CgkJcmV0dXJuIC1FSU5WQUw7Cgl9CgoJaWYgKGNvcHlfZnJvbV91c2VyKCZhZW4s
ICh2b2lkIF9fdXNlciAqKWFyZywgc2l6ZW9mKGFlbikpKQoJCXJldHVybiAtRUZBVUxUOwoKCWlu
c3RhbmNlID0gbWVnYXNhc19sb29rdXBfaW5zdGFuY2UoYWVuLmhvc3Rfbm8pOwoKCWlmICghaW5z
dGFuY2UpCgkJcmV0dXJuIC1FTk9ERVY7CgoJaWYgKGluc3RhbmNlLT5hZHByZWNvdmVyeSA9PSBN
RUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SKSB7CgkJcmV0dXJuIC1FTk9ERVY7Cgl9CgoJaWYgKGlu
c3RhbmNlLT51bmxvYWQgPT0gMSkgewoJCXJldHVybiAtRU5PREVWOwoJfQoKCWZvciAoaSA9IDA7
IGkgPCB3YWl0X3RpbWU7IGkrKykgewoKCQlzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmhi
YV9sb2NrLCBmbGFncyk7CgkJaWYgKGluc3RhbmNlLT5hZHByZWNvdmVyeSA9PSBNRUdBU0FTX0hC
QV9PUEVSQVRJT05BTCkgewoJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5jZS0+aGJh
X2xvY2ssCgkJCQkJCWZsYWdzKTsKCQkJYnJlYWs7CgkJfQoKCQlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKCgkJaWYgKCEoaSAlIE1FR0FTQVNfUkVT
RVRfTk9USUNFX0lOVEVSVkFMKSkgewoJCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FzYXM6IHdh
aXRpbmcgZm9yIgoJCQkJImNvbnRyb2xsZXIgcmVzZXQgdG8gZmluaXNoXG4iKTsKCQl9CgoJCW1z
bGVlcCgxMDAwKTsKCX0KCglzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBm
bGFncyk7CglpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ICE9IE1FR0FTQVNfSEJBX09QRVJBVElP
TkFMKSB7CgkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFn
cyk7CgkJcHJpbnRrKEtFUk5fRVJSICJtZWdhcmFpZF9zYXM6IHRpbWVkIG91dCB3aGlsZSB3YWl0
aW5nIgoJCQkJImZvciBIQkEgdG8gcmVjb3Zlci5cbiIpOwoJCXJldHVybiAtRU5PREVWOwoJfQoJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CgoJbXV0
ZXhfbG9jaygmaW5zdGFuY2UtPmFlbl9tdXRleCk7CgllcnJvciA9IG1lZ2FzYXNfcmVnaXN0ZXJf
YWVuKGluc3RhbmNlLCBhZW4uc2VxX251bSwKCQkJCSAgICAgYWVuLmNsYXNzX2xvY2FsZV93b3Jk
KTsKCW11dGV4X3VubG9jaygmaW5zdGFuY2UtPmFlbl9tdXRleCk7CglyZXR1cm4gZXJyb3I7Cn0K
Ci8qKgogKiBtZWdhc2FzX21nbXRfaW9jdGwgLQljaGFyIG5vZGUgaW9jdGwgZW50cnkgcG9pbnQK
ICovCnN0YXRpYyBsb25nCm1lZ2FzYXNfbWdtdF9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5z
aWduZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpCnsKCXN3aXRjaCAoY21kKSB7CgljYXNl
IE1FR0FTQVNfSU9DX0ZJUk1XQVJFOgoJCXJldHVybiBtZWdhc2FzX21nbXRfaW9jdGxfZncoZmls
ZSwgYXJnKTsKCgljYXNlIE1FR0FTQVNfSU9DX0dFVF9BRU46CgkJcmV0dXJuIG1lZ2FzYXNfbWdt
dF9pb2N0bF9hZW4oZmlsZSwgYXJnKTsKCX0KCglyZXR1cm4gLUVOT1RUWTsKfQoKI2lmZGVmIENP
TkZJR19DT01QQVQKc3RhdGljIGludCBtZWdhc2FzX21nbXRfY29tcGF0X2lvY3RsX2Z3KHN0cnVj
dCBmaWxlICpmaWxlLCB1bnNpZ25lZCBsb25nIGFyZykKewoJc3RydWN0IGNvbXBhdF9tZWdhc2Fz
X2lvY3BhY2tldCBfX3VzZXIgKmNpb2MgPQoJICAgIChzdHJ1Y3QgY29tcGF0X21lZ2FzYXNfaW9j
cGFja2V0IF9fdXNlciAqKWFyZzsKCXN0cnVjdCBtZWdhc2FzX2lvY3BhY2tldCBfX3VzZXIgKmlv
YyA9CgkgICAgY29tcGF0X2FsbG9jX3VzZXJfc3BhY2Uoc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2lv
Y3BhY2tldCkpOwoJaW50IGk7CglpbnQgZXJyb3IgPSAwOwoJY29tcGF0X3VwdHJfdCBwdHI7CgoJ
aWYgKGNsZWFyX3VzZXIoaW9jLCBzaXplb2YoKmlvYykpKQoJCXJldHVybiAtRUZBVUxUOwoKCWlm
IChjb3B5X2luX3VzZXIoJmlvYy0+aG9zdF9ubywgJmNpb2MtPmhvc3Rfbm8sIHNpemVvZih1MTYp
KSB8fAoJICAgIGNvcHlfaW5fdXNlcigmaW9jLT5zZ2xfb2ZmLCAmY2lvYy0+c2dsX29mZiwgc2l6
ZW9mKHUzMikpIHx8CgkgICAgY29weV9pbl91c2VyKCZpb2MtPnNlbnNlX29mZiwgJmNpb2MtPnNl
bnNlX29mZiwgc2l6ZW9mKHUzMikpIHx8CgkgICAgY29weV9pbl91c2VyKCZpb2MtPnNlbnNlX2xl
biwgJmNpb2MtPnNlbnNlX2xlbiwgc2l6ZW9mKHUzMikpIHx8CgkgICAgY29weV9pbl91c2VyKGlv
Yy0+ZnJhbWUucmF3LCBjaW9jLT5mcmFtZS5yYXcsIDEyOCkgfHwKCSAgICBjb3B5X2luX3VzZXIo
JmlvYy0+c2dlX2NvdW50LCAmY2lvYy0+c2dlX2NvdW50LCBzaXplb2YodTMyKSkpCgkJcmV0dXJu
IC1FRkFVTFQ7CgoJLyoKCSAqIFRoZSBzZW5zZV9wdHIgaXMgdXNlZCBpbiBtZWdhc2FzX21nbXRf
ZndfaW9jdGwgb25seSB3aGVuCgkgKiBzZW5zZV9sZW4gaXMgbm90IG51bGwsIHNvIHByZXBhcmUg
dGhlIDY0Yml0IHZhbHVlIHVuZGVyCgkgKiB0aGUgc2FtZSBjb25kaXRpb24uCgkgKi8KCWlmIChp
b2MtPnNlbnNlX2xlbikgewoJCXZvaWQgX191c2VyICoqc2Vuc2VfaW9jX3B0ciA9CgkJCSh2b2lk
IF9fdXNlciAqKikoaW9jLT5mcmFtZS5yYXcgKyBpb2MtPnNlbnNlX29mZik7CgkJY29tcGF0X3Vw
dHJfdCAqc2Vuc2VfY2lvY19wdHIgPQoJCQkoY29tcGF0X3VwdHJfdCAqKShjaW9jLT5mcmFtZS5y
YXcgKyBjaW9jLT5zZW5zZV9vZmYpOwoJCWlmIChnZXRfdXNlcihwdHIsIHNlbnNlX2Npb2NfcHRy
KSB8fAoJCSAgICBwdXRfdXNlcihjb21wYXRfcHRyKHB0ciksIHNlbnNlX2lvY19wdHIpKQoJCQly
ZXR1cm4gLUVGQVVMVDsKCX0KCglmb3IgKGkgPSAwOyBpIDwgTUFYX0lPQ1RMX1NHRTsgaSsrKSB7
CgkJaWYgKGdldF91c2VyKHB0ciwgJmNpb2MtPnNnbFtpXS5pb3ZfYmFzZSkgfHwKCQkgICAgcHV0
X3VzZXIoY29tcGF0X3B0cihwdHIpLCAmaW9jLT5zZ2xbaV0uaW92X2Jhc2UpIHx8CgkJICAgIGNv
cHlfaW5fdXNlcigmaW9jLT5zZ2xbaV0uaW92X2xlbiwKCQkJCSAmY2lvYy0+c2dsW2ldLmlvdl9s
ZW4sIHNpemVvZihjb21wYXRfc2l6ZV90KSkpCgkJCXJldHVybiAtRUZBVUxUOwoJfQoKCWVycm9y
ID0gbWVnYXNhc19tZ210X2lvY3RsX2Z3KGZpbGUsICh1bnNpZ25lZCBsb25nKWlvYyk7CgoJaWYg
KGNvcHlfaW5fdXNlcigmY2lvYy0+ZnJhbWUuaGRyLmNtZF9zdGF0dXMsCgkJCSAmaW9jLT5mcmFt
ZS5oZHIuY21kX3N0YXR1cywgc2l6ZW9mKHU4KSkpIHsKCQlwcmludGsoS0VSTl9ERUJVRyAibWVn
YXNhczogZXJyb3IgY29weV9pbl91c2VyIGNtZF9zdGF0dXNcbiIpOwoJCXJldHVybiAtRUZBVUxU
OwoJfQoJcmV0dXJuIGVycm9yOwp9CgpzdGF0aWMgbG9uZwptZWdhc2FzX21nbXRfY29tcGF0X2lv
Y3RsKHN0cnVjdCBmaWxlICpmaWxlLCB1bnNpZ25lZCBpbnQgY21kLAoJCQkgIHVuc2lnbmVkIGxv
bmcgYXJnKQp7Cglzd2l0Y2ggKGNtZCkgewoJY2FzZSBNRUdBU0FTX0lPQ19GSVJNV0FSRTMyOgoJ
CXJldHVybiBtZWdhc2FzX21nbXRfY29tcGF0X2lvY3RsX2Z3KGZpbGUsIGFyZyk7CgljYXNlIE1F
R0FTQVNfSU9DX0dFVF9BRU46CgkJcmV0dXJuIG1lZ2FzYXNfbWdtdF9pb2N0bF9hZW4oZmlsZSwg
YXJnKTsKCX0KCglyZXR1cm4gLUVOT1RUWTsKfQojZW5kaWYKCi8qCiAqIEZpbGUgb3BlcmF0aW9u
cyBzdHJ1Y3R1cmUgZm9yIG1hbmFnZW1lbnQgaW50ZXJmYWNlCiAqLwpzdGF0aWMgY29uc3Qgc3Ry
dWN0IGZpbGVfb3BlcmF0aW9ucyBtZWdhc2FzX21nbXRfZm9wcyA9IHsKCS5vd25lciA9IFRISVNf
TU9EVUxFLAoJLm9wZW4gPSBtZWdhc2FzX21nbXRfb3BlbiwKCS5mYXN5bmMgPSBtZWdhc2FzX21n
bXRfZmFzeW5jLAoJLnVubG9ja2VkX2lvY3RsID0gbWVnYXNhc19tZ210X2lvY3RsLAoJLnBvbGwg
PSBtZWdhc2FzX21nbXRfcG9sbCwKI2lmZGVmIENPTkZJR19DT01QQVQKCS5jb21wYXRfaW9jdGwg
PSBtZWdhc2FzX21nbXRfY29tcGF0X2lvY3RsLAojZW5kaWYKfTsKCi8qCiAqIFBDSSBob3RwbHVn
IHN1cHBvcnQgcmVnaXN0cmF0aW9uIHN0cnVjdHVyZQogKi8Kc3RhdGljIHN0cnVjdCBwY2lfZHJp
dmVyIG1lZ2FzYXNfcGNpX2RyaXZlciA9IHsKCgkubmFtZSA9ICJtZWdhcmFpZF9zYXMiLAoJLmlk
X3RhYmxlID0gbWVnYXNhc19wY2lfdGFibGUsCgkucHJvYmUgPSBtZWdhc2FzX3Byb2JlX29uZSwK
CS5yZW1vdmUgPSBfX2RldmV4aXRfcChtZWdhc2FzX2RldGFjaF9vbmUpLAoJLnN1c3BlbmQgPSBt
ZWdhc2FzX3N1c3BlbmQsCgkucmVzdW1lID0gbWVnYXNhc19yZXN1bWUsCgkuc2h1dGRvd24gPSBt
ZWdhc2FzX3NodXRkb3duLAp9OwoKLyoKICogU3lzZnMgZHJpdmVyIGF0dHJpYnV0ZXMKICovCnN0
YXRpYyBzc2l6ZV90IG1lZ2FzYXNfc3lzZnNfc2hvd192ZXJzaW9uKHN0cnVjdCBkZXZpY2VfZHJp
dmVyICpkZCwgY2hhciAqYnVmKQp7CglyZXR1cm4gc25wcmludGYoYnVmLCBzdHJsZW4oTUVHQVNB
U19WRVJTSU9OKSArIDIsICIlc1xuIiwKCQkJTUVHQVNBU19WRVJTSU9OKTsKfQoKc3RhdGljIERS
SVZFUl9BVFRSKHZlcnNpb24sIFNfSVJVR08sIG1lZ2FzYXNfc3lzZnNfc2hvd192ZXJzaW9uLCBO
VUxMKTsKCnN0YXRpYyBzc2l6ZV90Cm1lZ2FzYXNfc3lzZnNfc2hvd19yZWxlYXNlX2RhdGUoc3Ry
dWN0IGRldmljZV9kcml2ZXIgKmRkLCBjaGFyICpidWYpCnsKCXJldHVybiBzbnByaW50ZihidWYs
IHN0cmxlbihNRUdBU0FTX1JFTERBVEUpICsgMiwgIiVzXG4iLAoJCQlNRUdBU0FTX1JFTERBVEUp
Owp9CgpzdGF0aWMgRFJJVkVSX0FUVFIocmVsZWFzZV9kYXRlLCBTX0lSVUdPLCBtZWdhc2FzX3N5
c2ZzX3Nob3dfcmVsZWFzZV9kYXRlLAoJCSAgIE5VTEwpOwoKc3RhdGljIHNzaXplX3QKbWVnYXNh
c19zeXNmc19zaG93X3N1cHBvcnRfcG9sbF9mb3JfZXZlbnQoc3RydWN0IGRldmljZV9kcml2ZXIg
KmRkLCBjaGFyICpidWYpCnsKCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiV1XG4iLCBzdXBwb3J0X3Bv
bGxfZm9yX2V2ZW50KTsKfQoKc3RhdGljIERSSVZFUl9BVFRSKHN1cHBvcnRfcG9sbF9mb3JfZXZl
bnQsIFNfSVJVR08sCgkJCW1lZ2FzYXNfc3lzZnNfc2hvd19zdXBwb3J0X3BvbGxfZm9yX2V2ZW50
LCBOVUxMKTsKCiBzdGF0aWMgc3NpemVfdAptZWdhc2FzX3N5c2ZzX3Nob3dfc3VwcG9ydF9kZXZp
Y2VfY2hhbmdlKHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkZCwgY2hhciAqYnVmKQp7CglyZXR1cm4g
c3ByaW50ZihidWYsICIldVxuIiwgc3VwcG9ydF9kZXZpY2VfY2hhbmdlKTsKfQoKc3RhdGljIERS
SVZFUl9BVFRSKHN1cHBvcnRfZGV2aWNlX2NoYW5nZSwgU19JUlVHTywKCQkJbWVnYXNhc19zeXNm
c19zaG93X3N1cHBvcnRfZGV2aWNlX2NoYW5nZSwgTlVMTCk7CgpzdGF0aWMgc3NpemVfdAptZWdh
c2FzX3N5c2ZzX3Nob3dfZGJnX2x2bChzdHJ1Y3QgZGV2aWNlX2RyaXZlciAqZGQsIGNoYXIgKmJ1
ZikKewoJcmV0dXJuIHNwcmludGYoYnVmLCAiJXVcbiIsIG1lZ2FzYXNfZGJnX2x2bCk7Cn0KCnN0
YXRpYyBzc2l6ZV90Cm1lZ2FzYXNfc3lzZnNfc2V0X2RiZ19sdmwoc3RydWN0IGRldmljZV9kcml2
ZXIgKmRkLCBjb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKewoJaW50IHJldHZhbCA9IGNv
dW50OwoJaWYoc3NjYW5mKGJ1ZiwiJXUiLCZtZWdhc2FzX2RiZ19sdmwpPDEpewoJCXByaW50ayhL
RVJOX0VSUiAibWVnYXNhczogY291bGQgbm90IHNldCBkYmdfbHZsXG4iKTsKCQlyZXR2YWwgPSAt
RUlOVkFMOwoJfQoJcmV0dXJuIHJldHZhbDsKfQoKc3RhdGljIERSSVZFUl9BVFRSKGRiZ19sdmws
IFNfSVJVR098U19JV1VTUiwgbWVnYXNhc19zeXNmc19zaG93X2RiZ19sdmwsCgkJbWVnYXNhc19z
eXNmc19zZXRfZGJnX2x2bCk7CgpzdGF0aWMgc3NpemVfdAptZWdhc2FzX3N5c2ZzX3Nob3dfcG9s
bF9tb2RlX2lvKHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkZCwgY2hhciAqYnVmKQp7CglyZXR1cm4g
c3ByaW50ZihidWYsICIldVxuIiwgcG9sbF9tb2RlX2lvKTsKfQoKc3RhdGljIHNzaXplX3QKbWVn
YXNhc19zeXNmc19zZXRfcG9sbF9tb2RlX2lvKHN0cnVjdCBkZXZpY2VfZHJpdmVyICpkZCwKCQkJ
CWNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KQp7CglpbnQgcmV0dmFsID0gY291bnQ7Cglp
bnQgdG1wID0gcG9sbF9tb2RlX2lvOwoJaW50IGk7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2U7CgoJaWYgKHNzY2FuZihidWYsICIldSIsICZwb2xsX21vZGVfaW8pIDwgMSkgewoJ
CXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogY291bGQgbm90IHNldCBwb2xsX21vZGVfaW9cbiIp
OwoJCXJldHZhbCA9IC1FSU5WQUw7Cgl9CgoJLyoKCSAqIENoZWNrIGlmIHBvbGxfbW9kZV9pbyBp
cyBhbHJlYWR5IHNldCBvciBpcyBzYW1lIGFzIHByZXZpb3VzIHZhbHVlCgkgKi8KCWlmICgodG1w
ICYmIHBvbGxfbW9kZV9pbykgfHwgKHRtcCA9PSBwb2xsX21vZGVfaW8pKQoJCWdvdG8gb3V0OwoK
CWlmIChwb2xsX21vZGVfaW8pIHsKCQkvKgoJCSAqIFN0YXJ0IHRpbWVycyBmb3IgYWxsIGFkYXB0
ZXJzCgkJICovCgkJZm9yIChpID0gMDsgaSA8IG1lZ2FzYXNfbWdtdF9pbmZvLm1heF9pbmRleDsg
aSsrKSB7CgkJCWluc3RhbmNlID0gbWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbaV07CgkJCWlm
IChpbnN0YW5jZSkgewoJCQkJbWVnYXNhc19zdGFydF90aW1lcihpbnN0YW5jZSwKCQkJCQkmaW5z
dGFuY2UtPmlvX2NvbXBsZXRpb25fdGltZXIsCgkJCQkJbWVnYXNhc19pb19jb21wbGV0aW9uX3Rp
bWVyLAoJCQkJCU1FR0FTQVNfQ09NUExFVElPTl9USU1FUl9JTlRFUlZBTCk7CgkJCX0KCQl9Cgl9
IGVsc2UgewoJCS8qCgkJICogRGVsZXRlIHRpbWVycyBmb3IgYWxsIGFkYXB0ZXJzCgkJICovCgkJ
Zm9yIChpID0gMDsgaSA8IG1lZ2FzYXNfbWdtdF9pbmZvLm1heF9pbmRleDsgaSsrKSB7CgkJCWlu
c3RhbmNlID0gbWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbaV07CgkJCWlmIChpbnN0YW5jZSkK
CQkJCWRlbF90aW1lcl9zeW5jKCZpbnN0YW5jZS0+aW9fY29tcGxldGlvbl90aW1lcik7CgkJfQoJ
fQoKb3V0OgoJcmV0dXJuIHJldHZhbDsKfQoKc3RhdGljIHZvaWQKbWVnYXNhc19hZW5fcG9sbGlu
ZyhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCnsKCXN0cnVjdCBtZWdhc2FzX2Flbl9ldmVudCAq
ZXYgPQoJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgbWVnYXNhc19hZW5fZXZlbnQsIGhvdHBs
dWdfd29yayk7CglzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UgPSBldi0+aW5zdGFu
Y2U7Cgl1bmlvbiBtZWdhc2FzX2V2dF9jbGFzc19sb2NhbGUgY2xhc3NfbG9jYWxlOwoJc3RydWN0
ICBTY3NpX0hvc3QgKmhvc3Q7CglzdHJ1Y3QgIHNjc2lfZGV2aWNlICpzZGV2MTsKCXUxNiAgICAg
cGRfaW5kZXggPSAwOwoJdTE2CWxkX2luZGV4ID0gMDsKCWludCAgICAgaSwgaiwgZG9zY2FuID0g
MDsKCXUzMiBzZXFfbnVtOwoJaW50IGVycm9yOwoKCWlmICghaW5zdGFuY2UpIHsKCQlwcmludGso
S0VSTl9FUlIgImludmFsaWQgaW5zdGFuY2UhXG4iKTsKCQlrZnJlZShldik7CgkJcmV0dXJuOwoJ
fQoJaW5zdGFuY2UtPmV2ID0gTlVMTDsKCWhvc3QgPSBpbnN0YW5jZS0+aG9zdDsKCWlmIChpbnN0
YW5jZS0+ZXZ0X2RldGFpbCkgewoKCQlzd2l0Y2ggKGluc3RhbmNlLT5ldnRfZGV0YWlsLT5jb2Rl
KSB7CgkJY2FzZSBNUl9FVlRfUERfSU5TRVJURUQ6CgkJCWlmIChtZWdhc2FzX2dldF9wZF9saXN0
KGluc3RhbmNlKSA9PSAwKSB7CgkJCWZvciAoaSA9IDA7IGkgPCBNRUdBU0FTX01BWF9QRF9DSEFO
TkVMUzsgaSsrKSB7CgkJCQlmb3IgKGogPSAwOwoJCQkJaiA8IE1FR0FTQVNfTUFYX0RFVl9QRVJf
Q0hBTk5FTDsKCQkJCWorKykgewoKCQkJCXBkX2luZGV4ID0KCQkJCShpICogTUVHQVNBU19NQVhf
REVWX1BFUl9DSEFOTkVMKSArIGo7CgoJCQkJc2RldjEgPQoJCQkJc2NzaV9kZXZpY2VfbG9va3Vw
KGhvc3QsIGksIGosIDApOwoKCQkJCWlmIChpbnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJp
dmVTdGF0ZQoJCQkJCQk9PSBNUl9QRF9TVEFURV9TWVNURU0pIHsKCQkJCQkJaWYgKCFzZGV2MSkg
ewoJCQkJCQlzY3NpX2FkZF9kZXZpY2UoaG9zdCwgaSwgaiwgMCk7CgkJCQkJCX0KCgkJCQkJaWYg
KHNkZXYxKQoJCQkJCQlzY3NpX2RldmljZV9wdXQoc2RldjEpOwoJCQkJCX0KCQkJCX0KCQkJfQoJ
CQl9CgkJCWRvc2NhbiA9IDA7CgkJCWJyZWFrOwoKCQljYXNlIE1SX0VWVF9QRF9SRU1PVkVEOgoJ
CQlpZiAobWVnYXNhc19nZXRfcGRfbGlzdChpbnN0YW5jZSkgPT0gMCkgewoJCQltZWdhc2FzX2dl
dF9wZF9saXN0KGluc3RhbmNlKTsKCQkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfTUFYX1BEX0NI
QU5ORUxTOyBpKyspIHsKCQkJCWZvciAoaiA9IDA7CgkJCQlqIDwgTUVHQVNBU19NQVhfREVWX1BF
Ul9DSEFOTkVMOwoJCQkJaisrKSB7CgoJCQkJcGRfaW5kZXggPQoJCQkJKGkgKiBNRUdBU0FTX01B
WF9ERVZfUEVSX0NIQU5ORUwpICsgajsKCgkJCQlzZGV2MSA9CgkJCQlzY3NpX2RldmljZV9sb29r
dXAoaG9zdCwgaSwgaiwgMCk7CgoJCQkJaWYgKGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5k
cml2ZVN0YXRlCgkJCQkJPT0gTVJfUERfU1RBVEVfU1lTVEVNKSB7CgkJCQkJaWYgKHNkZXYxKSB7
CgkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2MSk7CgkJCQkJfQoJCQkJfSBlbHNlIHsKCQkJCQlp
ZiAoc2RldjEpIHsKCQkJCQkJc2NzaV9yZW1vdmVfZGV2aWNlKHNkZXYxKTsKCQkJCQkJc2NzaV9k
ZXZpY2VfcHV0KHNkZXYxKTsKCQkJCQl9CgkJCQl9CgkJCQl9CgkJCX0KCQkJfQoJCQlkb3NjYW4g
PSAwOwoJCQlicmVhazsKCgkJY2FzZSBNUl9FVlRfTERfT0ZGTElORToKCQljYXNlIE1SX0VWVF9M
RF9ERUxFVEVEOgoJCQltZWdhc2FzX2dldF9sZF9saXN0KGluc3RhbmNlKTsKCQkJZm9yIChpID0g
MDsgaSA8IE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxTOyBpKyspIHsKCQkJCWZvciAoaiA9IDA7CgkJ
CQlqIDwgTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMOwoJCQkJaisrKSB7CgoJCQkJbGRfaW5k
ZXggPQoJCQkJKGkgKiBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpICsgajsKCgkJCQlzZGV2
MSA9IHNjc2lfZGV2aWNlX2xvb2t1cChob3N0LAoJCQkJCWkgKyBNRUdBU0FTX01BWF9MRF9DSEFO
TkVMUywKCQkJCQlqLAoJCQkJCTApOwoKCQkJCWlmIChpbnN0YW5jZS0+bGRfaWRzW2xkX2luZGV4
XSAhPSAweGZmKSB7CgkJCQkJaWYgKHNkZXYxKSB7CgkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2
MSk7CgkJCQkJfQoJCQkJfSBlbHNlIHsKCQkJCQlpZiAoc2RldjEpIHsKCQkJCQkJc2NzaV9yZW1v
dmVfZGV2aWNlKHNkZXYxKTsKCQkJCQkJc2NzaV9kZXZpY2VfcHV0KHNkZXYxKTsKCQkJCQl9CgkJ
CQl9CgkJCQl9CgkJCX0KCQkJZG9zY2FuID0gMDsKCQkJYnJlYWs7CgkJY2FzZSBNUl9FVlRfTERf
Q1JFQVRFRDoKCQkJbWVnYXNhc19nZXRfbGRfbGlzdChpbnN0YW5jZSk7CgkJCWZvciAoaSA9IDA7
IGkgPCBNRUdBU0FTX01BWF9MRF9DSEFOTkVMUzsgaSsrKSB7CgkJCQlmb3IgKGogPSAwOwoJCQkJ
CWogPCBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUw7CgkJCQkJaisrKSB7CgkJCQkJbGRfaW5k
ZXggPQoJCQkJCShpICogTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKSArIGo7CgoJCQkJCXNk
ZXYxID0gc2NzaV9kZXZpY2VfbG9va3VwKGhvc3QsCgkJCQkJCWkrTUVHQVNBU19NQVhfTERfQ0hB
Tk5FTFMsCgkJCQkJCWosIDApOwoKCQkJCQlpZiAoaW5zdGFuY2UtPmxkX2lkc1tsZF9pbmRleF0g
IT0KCQkJCQkJCQkweGZmKSB7CgkJCQkJCWlmICghc2RldjEpIHsKCQkJCQkJCXNjc2lfYWRkX2Rl
dmljZShob3N0LAoJCQkJCQkJCWkgKyAyLAoJCQkJCQkJCWosIDApOwoJCQkJCQl9CgkJCQkJfQoJ
CQkJCWlmIChzZGV2MSkgewoJCQkJCQlzY3NpX2RldmljZV9wdXQoc2RldjEpOwoJCQkJCX0KCQkJ
CX0KCQkJfQoJCQlkb3NjYW4gPSAwOwoJCQlicmVhazsKCQljYXNlIE1SX0VWVF9DVFJMX0hPU1Rf
QlVTX1NDQU5fUkVRVUVTVEVEOgoJCWNhc2UgTVJfRVZUX0ZPUkVJR05fQ0ZHX0lNUE9SVEVEOgoJ
CQlkb3NjYW4gPSAxOwoJCQlicmVhazsKCQlkZWZhdWx0OgoJCQlkb3NjYW4gPSAwOwoJCQlicmVh
azsKCQl9Cgl9IGVsc2UgewoJCXByaW50ayhLRVJOX0VSUiAiaW52YWxpZCBldnRfZGV0YWlsIVxu
Iik7CgkJa2ZyZWUoZXYpOwoJCXJldHVybjsKCX0KCglpZiAoZG9zY2FuKSB7CgkJcHJpbnRrKEtF
Uk5fSU5GTyAic2Nhbm5pbmcgLi4uXG4iKTsKCQltZWdhc2FzX2dldF9wZF9saXN0KGluc3RhbmNl
KTsKCQlmb3IgKGkgPSAwOyBpIDwgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFM7IGkrKykgewoJCQlm
b3IgKGogPSAwOyBqIDwgTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMOyBqKyspIHsKCQkJCXBk
X2luZGV4ID0gaSpNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwgKyBqOwoJCQkJc2RldjEgPSBz
Y3NpX2RldmljZV9sb29rdXAoaG9zdCwgaSwgaiwgMCk7CgkJCQlpZiAoaW5zdGFuY2UtPnBkX2xp
c3RbcGRfaW5kZXhdLmRyaXZlU3RhdGUgPT0KCQkJCQkJCU1SX1BEX1NUQVRFX1NZU1RFTSkgewoJ
CQkJCWlmICghc2RldjEpIHsKCQkJCQkJc2NzaV9hZGRfZGV2aWNlKGhvc3QsIGksIGosIDApOwoJ
CQkJCX0KCQkJCQlpZiAoc2RldjEpCgkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2MSk7CgkJCQl9
IGVsc2UgewoJCQkJCWlmIChzZGV2MSkgewoJCQkJCQlzY3NpX3JlbW92ZV9kZXZpY2Uoc2RldjEp
OwoJCQkJCQlzY3NpX2RldmljZV9wdXQoc2RldjEpOwoJCQkJCX0KCQkJCX0KCQkJfQoJCX0KCgkJ
bWVnYXNhc19nZXRfbGRfbGlzdChpbnN0YW5jZSk7CgkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNf
TUFYX0xEX0NIQU5ORUxTOyBpKyspIHsKCQkJZm9yIChqID0gMDsgaiA8IE1FR0FTQVNfTUFYX0RF
Vl9QRVJfQ0hBTk5FTDsgaisrKSB7CgkJCQlsZF9pbmRleCA9CgkJCQkoaSAqIE1FR0FTQVNfTUFY
X0RFVl9QRVJfQ0hBTk5FTCkgKyBqOwoKCQkJCXNkZXYxID0gc2NzaV9kZXZpY2VfbG9va3VwKGhv
c3QsCgkJCQkJaStNRUdBU0FTX01BWF9MRF9DSEFOTkVMUywgaiwgMCk7CgkJCQlpZiAoaW5zdGFu
Y2UtPmxkX2lkc1tsZF9pbmRleF0gIT0gMHhmZikgewoJCQkJCWlmICghc2RldjEpIHsKCQkJCQkJ
c2NzaV9hZGRfZGV2aWNlKGhvc3QsCgkJCQkJCQkJaSsyLAoJCQkJCQkJCWosIDApOwoJCQkJCX0g
ZWxzZSB7CgkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2MSk7CgkJCQkJfQoJCQkJfSBlbHNlIHsK
CQkJCQlpZiAoc2RldjEpIHsKCQkJCQkJc2NzaV9yZW1vdmVfZGV2aWNlKHNkZXYxKTsKCQkJCQkJ
c2NzaV9kZXZpY2VfcHV0KHNkZXYxKTsKCQkJCQl9CgkJCQl9CgkJCX0KCQl9Cgl9CgoJaWYgKCBp
bnN0YW5jZS0+YWVuX2NtZCAhPSBOVUxMICkgewoJCWtmcmVlKGV2KTsKCQlyZXR1cm4gOwoJfQoK
CXNlcV9udW0gPSBpbnN0YW5jZS0+ZXZ0X2RldGFpbC0+c2VxX251bSArIDE7CgoJLyogUmVnaXN0
ZXIgQUVOIHdpdGggRlcgZm9yIGxhdGVzdCBzZXF1ZW5jZSBudW1iZXIgcGx1cyAxICovCgljbGFz
c19sb2NhbGUubWVtYmVycy5yZXNlcnZlZCA9IDA7CgljbGFzc19sb2NhbGUubWVtYmVycy5sb2Nh
bGUgPSBNUl9FVlRfTE9DQUxFX0FMTDsKCWNsYXNzX2xvY2FsZS5tZW1iZXJzLmNsYXNzID0gTVJf
RVZUX0NMQVNTX0RFQlVHOwoJbXV0ZXhfbG9jaygmaW5zdGFuY2UtPmFlbl9tdXRleCk7CgllcnJv
ciA9IG1lZ2FzYXNfcmVnaXN0ZXJfYWVuKGluc3RhbmNlLCBzZXFfbnVtLAoJCQkJCWNsYXNzX2xv
Y2FsZS53b3JkKTsKCW11dGV4X3VubG9jaygmaW5zdGFuY2UtPmFlbl9tdXRleCk7CgoJaWYgKGVy
cm9yKQoJCXByaW50ayhLRVJOX0VSUiAicmVnaXN0ZXIgYWVuIGZhaWxlZCBlcnJvciAleFxuIiwg
ZXJyb3IpOwoKCWtmcmVlKGV2KTsKfQoKCnN0YXRpYyBEUklWRVJfQVRUUihwb2xsX21vZGVfaW8s
IFNfSVJVR098U19JV1VTUiwKCQltZWdhc2FzX3N5c2ZzX3Nob3dfcG9sbF9tb2RlX2lvLAoJCW1l
Z2FzYXNfc3lzZnNfc2V0X3BvbGxfbW9kZV9pbyk7CgovKioKICogbWVnYXNhc19pbml0IC0gRHJp
dmVyIGxvYWQgZW50cnkgcG9pbnQKICovCnN0YXRpYyBpbnQgX19pbml0IG1lZ2FzYXNfaW5pdCh2
b2lkKQp7CglpbnQgcnZhbDsKCgkvKgoJICogQW5ub3VuY2UgZHJpdmVyIHZlcnNpb24gYW5kIG90
aGVyIGluZm9ybWF0aW9uCgkgKi8KCXByaW50ayhLRVJOX0lORk8gIm1lZ2FzYXM6ICVzICVzXG4i
LCBNRUdBU0FTX1ZFUlNJT04sCgkgICAgICAgTUVHQVNBU19FWFRfVkVSU0lPTik7CgoJc3VwcG9y
dF9wb2xsX2Zvcl9ldmVudCA9IDI7CglzdXBwb3J0X2RldmljZV9jaGFuZ2UgPSAxOwoKCW1lbXNl
dCgmbWVnYXNhc19tZ210X2luZm8sIDAsIHNpemVvZihtZWdhc2FzX21nbXRfaW5mbykpOwoKCS8q
CgkgKiBSZWdpc3RlciBjaGFyYWN0ZXIgZGV2aWNlIG5vZGUKCSAqLwoJcnZhbCA9IHJlZ2lzdGVy
X2NocmRldigwLCAibWVnYXJhaWRfc2FzX2lvY3RsIiwgJm1lZ2FzYXNfbWdtdF9mb3BzKTsKCglp
ZiAocnZhbCA8IDApIHsKCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogZmFpbGVkIHRvIG9w
ZW4gZGV2aWNlIG5vZGVcbiIpOwoJCXJldHVybiBydmFsOwoJfQoKCW1lZ2FzYXNfbWdtdF9tYWpv
cm5vID0gcnZhbDsKCgkvKgoJICogUmVnaXN0ZXIgb3Vyc2VsdmVzIGFzIFBDSSBob3RwbHVnIG1v
ZHVsZQoJICovCglydmFsID0gcGNpX3JlZ2lzdGVyX2RyaXZlcigmbWVnYXNhc19wY2lfZHJpdmVy
KTsKCglpZiAocnZhbCkgewoJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBQQ0kgaG90cGx1
ZyByZWdpc3JhdGlvbiBmYWlsZWQgXG4iKTsKCQlnb3RvIGVycl9wY2lkcnY7Cgl9CgoJcnZhbCA9
IGRyaXZlcl9jcmVhdGVfZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVyLmRyaXZlciwKCQkJCSAgJmRy
aXZlcl9hdHRyX3ZlcnNpb24pOwoJaWYgKHJ2YWwpCgkJZ290byBlcnJfZGNmX2F0dHJfdmVyOwoJ
cnZhbCA9IGRyaXZlcl9jcmVhdGVfZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVyLmRyaXZlciwKCQkJ
CSAgJmRyaXZlcl9hdHRyX3JlbGVhc2VfZGF0ZSk7CglpZiAocnZhbCkKCQlnb3RvIGVycl9kY2Zf
cmVsX2RhdGU7CgoJcnZhbCA9IGRyaXZlcl9jcmVhdGVfZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVy
LmRyaXZlciwKCQkJCSZkcml2ZXJfYXR0cl9zdXBwb3J0X3BvbGxfZm9yX2V2ZW50KTsKCWlmIChy
dmFsKQoJCWdvdG8gZXJyX2RjZl9zdXBwb3J0X3BvbGxfZm9yX2V2ZW50OwoKCXJ2YWwgPSBkcml2
ZXJfY3JlYXRlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCgkJCQkgICZkcml2ZXJf
YXR0cl9kYmdfbHZsKTsKCWlmIChydmFsKQoJCWdvdG8gZXJyX2RjZl9kYmdfbHZsOwoJcnZhbCA9
IGRyaXZlcl9jcmVhdGVfZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVyLmRyaXZlciwKCQkJCSAgJmRy
aXZlcl9hdHRyX3BvbGxfbW9kZV9pbyk7CglpZiAocnZhbCkKCQlnb3RvIGVycl9kY2ZfcG9sbF9t
b2RlX2lvOwoKCXJ2YWwgPSBkcml2ZXJfY3JlYXRlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5k
cml2ZXIsCgkJCQkmZHJpdmVyX2F0dHJfc3VwcG9ydF9kZXZpY2VfY2hhbmdlKTsKCWlmIChydmFs
KQoJCWdvdG8gZXJyX2RjZl9zdXBwb3J0X2RldmljZV9jaGFuZ2U7CgoJcmV0dXJuIHJ2YWw7Cgpl
cnJfZGNmX3N1cHBvcnRfZGV2aWNlX2NoYW5nZToKCWRyaXZlcl9yZW1vdmVfZmlsZSgmbWVnYXNh
c19wY2lfZHJpdmVyLmRyaXZlciwKCQkgICZkcml2ZXJfYXR0cl9wb2xsX21vZGVfaW8pOwoKZXJy
X2RjZl9wb2xsX21vZGVfaW86Cglkcml2ZXJfcmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZl
ci5kcml2ZXIsCgkJCSAgICZkcml2ZXJfYXR0cl9kYmdfbHZsKTsKZXJyX2RjZl9kYmdfbHZsOgoJ
ZHJpdmVyX3JlbW92ZV9maWxlKCZtZWdhc2FzX3BjaV9kcml2ZXIuZHJpdmVyLAoJCQkmZHJpdmVy
X2F0dHJfc3VwcG9ydF9wb2xsX2Zvcl9ldmVudCk7CgplcnJfZGNmX3N1cHBvcnRfcG9sbF9mb3Jf
ZXZlbnQ6Cglkcml2ZXJfcmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCgkJ
CSAgICZkcml2ZXJfYXR0cl9yZWxlYXNlX2RhdGUpOwoKZXJyX2RjZl9yZWxfZGF0ZToKCWRyaXZl
cl9yZW1vdmVfZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVyLmRyaXZlciwgJmRyaXZlcl9hdHRyX3Zl
cnNpb24pOwplcnJfZGNmX2F0dHJfdmVyOgoJcGNpX3VucmVnaXN0ZXJfZHJpdmVyKCZtZWdhc2Fz
X3BjaV9kcml2ZXIpOwplcnJfcGNpZHJ2OgoJdW5yZWdpc3Rlcl9jaHJkZXYobWVnYXNhc19tZ210
X21ham9ybm8sICJtZWdhcmFpZF9zYXNfaW9jdGwiKTsKICAJcmV0dXJuIHJ2YWw7Cn0KCi8qKgog
KiBtZWdhc2FzX2V4aXQgLSBEcml2ZXIgdW5sb2FkIGVudHJ5IHBvaW50CiAqLwpzdGF0aWMgdm9p
ZCBfX2V4aXQgbWVnYXNhc19leGl0KHZvaWQpCnsKCWRyaXZlcl9yZW1vdmVfZmlsZSgmbWVnYXNh
c19wY2lfZHJpdmVyLmRyaXZlciwKCQkJICAgJmRyaXZlcl9hdHRyX3BvbGxfbW9kZV9pbyk7Cglk
cml2ZXJfcmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsCgkJCSAgICZkcml2
ZXJfYXR0cl9kYmdfbHZsKTsKCWRyaXZlcl9yZW1vdmVfZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVy
LmRyaXZlciwKCQkJJmRyaXZlcl9hdHRyX3N1cHBvcnRfcG9sbF9mb3JfZXZlbnQpOwoJZHJpdmVy
X3JlbW92ZV9maWxlKCZtZWdhc2FzX3BjaV9kcml2ZXIuZHJpdmVyLAoJCQkmZHJpdmVyX2F0dHJf
c3VwcG9ydF9kZXZpY2VfY2hhbmdlKTsKCWRyaXZlcl9yZW1vdmVfZmlsZSgmbWVnYXNhc19wY2lf
ZHJpdmVyLmRyaXZlciwKCQkJICAgJmRyaXZlcl9hdHRyX3JlbGVhc2VfZGF0ZSk7Cglkcml2ZXJf
cmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsICZkcml2ZXJfYXR0cl92ZXJz
aW9uKTsKCglwY2lfdW5yZWdpc3Rlcl9kcml2ZXIoJm1lZ2FzYXNfcGNpX2RyaXZlcik7Cgl1bnJl
Z2lzdGVyX2NocmRldihtZWdhc2FzX21nbXRfbWFqb3JubywgIm1lZ2FyYWlkX3Nhc19pb2N0bCIp
Owp9Cgptb2R1bGVfaW5pdChtZWdhc2FzX2luaXQpOwptb2R1bGVfZXhpdChtZWdhc2FzX2V4aXQp
Owo=

--_003_4B6A08C587958942AA3002690DD4F8C3DBEF4AD0cosmail02lsicom_--
