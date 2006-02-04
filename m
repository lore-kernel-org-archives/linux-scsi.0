From: Michael Reed <mdr@sgi.com>
Subject: Re: qla2xxx: Shutdown Hang / OOPS with 2.6.16-rc1 + qla2xxx driver
 via mm4 patch
Date: Sat, 04 Feb 2006 13:57:23 -0600
Message-ID: <43E50723.8010404@sgi.com>
References: <43DFE02F.4030705@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:17639 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S964792AbWBDT53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2006 14:57:29 -0500
In-Reply-To: <43DFE02F.4030705@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Michael Reed <mdr@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Gary Hagensen <gwh@sgi.com>

Andrew,

I was able to repeat the OOPS with 2.6.16-rc2.  Here' another backtrace and
more info.  This happened with a switchdisable / switchenable sequence.

Let me know if I can help.  If at all possible, SGI would like to have a
resolution that makes it into SuSE's sles10.

Regards and thanks,
 Mike


qla2300 0012:00:02.1: LOOP DOWN detected (2).
qla2300 0012:00:01.1: LOOP DOWN detected (2).
qla2300 0012:00:02.0: LOOP DOWN detected (2).
qla2300 0012:00:01.0: LOOP DOWN detected (2).
qla2300 0002:01:04.0: LOOP DOWN detected (2).
qla2300 0002:01:06.1: LOOP DOWN detected (2).
qla2300 0002:01:04.1: LOOP DOWN detected (2).
qla2300 0002:01:06.0: LOOP DOWN detected (2).
qla2300 0002:01:04.1: LIP reset occured (f7f7).
qla2300 0012:00:02.1: LIP reset occured (f7f7).
qla2300 0012:00:01.1: LIP reset occured (f7f7).
qla2300 0012:00:02.0: LIP reset occured (f7f7).
qla2300 0002:01:06.1: LIP reset occured (f7f7).
qla2300 0002:01:04.0: LIP reset occured (f7f7).
qla2300 0012:00:01.0: LIP reset occured (f7f7).
qla2300 0002:01:06.0: LIP reset occured (f7f7).
qla2300 0002:01:04.1: LIP reset occured (f7f7).
qla2300 0012:00:02.1: LIP reset occured (f7f7).
qla2300 0002:01:06.1: LIP reset occured (f7f7).
qla2300 0012:00:02.0: LIP reset occured (f7f7).
qla2300 0002:01:06.0: LIP reset occured (f7f7).
qla2300 0012:00:01.0: LIP reset occured (f7f7).
qla2300 0012:00:01.1: LIP reset occured (f7f7).
qla2300 0002:01:04.0: LIP reset occured (f7f7).
qla2300 0012:00:02.1: LOOP UP detected (2 Gbps).
qla2300 0012:00:02.0: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.0: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
Unable to handle kernel NULL pointer dereference (address 000000000000003c)
scsi_wq_6[1447]: Oops 11012296146944 [1]
Modules linked in: ipv6 nfs lockd sunrpc sg

Pid: 1447, CPU 0, comm:            scsi_wq_6
psr : 0000121008022018 ifs : 800000000000050c ip  : [<a00000010055fa01>]    Not tainted
ip is at qla2x00_queuecommand+0x301/0x360
unat: 0000000000000000 pfs : 000000000000050c rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000005941
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010055f760 b6  : a00000010055f700 b7  : a000000100537520
f6  : 000000000000000000000 f7  : 1003e0000000000000015
f8  : 1003e0000000000000100 f9  : 10002a000000000000000
f10 : 1003e0000000000001000 f11 : 1003e0000000000000003
r1  : a000000100cdaaa0 r2  : a000000100af0be8 r3  : e00000b024ced528
r8  : 0000000000000001 r9  : 0000000000041163 r10 : 0000000000041162
r11 : 0000000000041162 r12 : e0000034f69bfbb0 r13 : e0000034f69b8000
r14 : 0000000000000002 r15 : 000000000000003c r16 : e0000034f6348890
r17 : e00000b003a5c140 r18 : e00000309b485f48 r19 : 0000000000041163
r20 : 0000000000041162 r21 : 0000000000041162 r22 : e00000309b485f65
r23 : 00000000000000a0 r24 : a00000010055f700 r25 : a000000100977f58
r26 : a000000100977f20 r27 : e00000b003a5c0e8 r28 : a000000100af0a68
r29 : e0000034f6348800 r30 : 000000000000000c r31 : a000000100af0f9d

Call Trace:
 [<a000000100012ae0>] show_stack+0x40/0xa0
                                sp=e0000034f69bf740 bsp=e0000034f69b95c0
 [<a0000001000133f0>] show_regs+0x850/0x8a0
                                sp=e0000034f69bf910 bsp=e0000034f69b9568
 [<a000000100037630>] die+0x210/0x2a0
                                sp=e0000034f69bf910 bsp=e0000034f69b9520
 [<a00000010005bb90>] ia64_do_page_fault+0xa10/0xba0
                                sp=e0000034f69bf930 bsp=e0000034f69b94d0
 [<a00000010000bbe0>] ia64_leave_kernel+0x0/0x290
                                sp=e0000034f69bf9e0 bsp=e0000034f69b94d0
 [<a00000010055fa00>] qla2x00_queuecommand+0x300/0x360
                                sp=e0000034f69bfbb0 bsp=e0000034f69b9470
 [<a00000010052a720>] scsi_dispatch_cmd+0x480/0x540
                                sp=e0000034f69bfbb0 bsp=e0000034f69b9430
 [<a000000100537350>] scsi_request_fn+0x650/0x820
                                sp=e0000034f69bfbb0 bsp=e0000034f69b93e0
 [<a0000001003cd670>] __generic_unplug_device+0x90/0xc0
                                sp=e0000034f69bfbb0 bsp=e0000034f69b93c0
 [<a0000001003cdbb0>] generic_unplug_device+0x30/0x60
                                sp=e0000034f69bfbb0 bsp=e0000034f69b9398
 [<a0000001003cdc60>] blk_execute_rq_nowait+0x80/0xa0
                                sp=e0000034f69bfbb0 bsp=e0000034f69b9358
 [<a0000001003cdde0>] blk_execute_rq+0x160/0x1e0
                                sp=e0000034f69bfbb0 bsp=e0000034f69b92f8
 [<a0000001005368b0>] scsi_execute+0x170/0x1c0
                                sp=e0000034f69bfc60 bsp=e0000034f69b92a0
 [<a0000001005369f0>] scsi_execute_req+0xf0/0x180
                                sp=e0000034f69bfc60 bsp=e0000034f69b9238
 [<a00000010053aed0>] __scsi_scan_target+0x4b0/0xb60
                                sp=e0000034f69bfc70 bsp=e0000034f69b91c8
 [<a00000010053bb50>] scsi_scan_target+0xd0/0x100
                                sp=e0000034f69bfcd0 bsp=e0000034f69b9178
 [<a000000100548810>] fc_scsi_scan_rport+0x50/0x80
                                sp=e0000034f69bfcd0 bsp=e0000034f69b9150
 [<a0000001000c9040>] run_workqueue+0x1c0/0x280
                                sp=e0000034f69bfcd0 bsp=e0000034f69b9110
 [<a0000001000ca130>] worker_thread+0x1d0/0x260
                                sp=e0000034f69bfcd0 bsp=e0000034f69b90e0
 [<a0000001000d1f00>] kthread+0x220/0x2a0
                                sp=e0000034f69bfd50 bsp=e0000034f69b9098
 [<a000000100011070>] kernel_thread_helper+0xd0/0x100
                                sp=e0000034f69bfe30 bsp=e0000034f69b9070
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f69bfe30 bsp=e0000034f69b9070
 <6>note: scsi_wq_6[1447] exited with preempt_count 1
BUG: scsi_wq_6/1447, lock held at task exit time!
 [e00000b003a5c060] {scsi_host_alloc}
.. held by:         scsi_wq_6: 1447 [e0000034f69b8000, 110]
... acquired at:               scsi_scan_target+0x90/0x100
BUG: soft lockup detected on CPU#0!
Modules linked in: ipv6 nfs lockd sunrpc sg

Pid: 8611, CPU 0, comm:                 tcsh
psr : 0000101008026018 ifs : 8000000000000286 ip  : [<a0000001006fcf40>]    Not tainted
ip is at _spin_lock_irqsave+0x120/0x180
unat: 0000000000000000 pfs : 0000000000000286 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : a5655666a9996565
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001006fced0 b6  : a0000001005330a0 b7  : a000000100010420
f6  : 1003e0000000000000bba f7  : 1003e0044b82fa09b5a53
f8  : 1003e00000000002bb29f f9  : 1003e0000000000000445
f10 : 1003e00000000000fe82a f11 : 1003e0044b82fa09b5a53
r1  : a000000100cdaaa0 r2  : 0000000000000001 r3  : 0000000000000000
r8  : e00000b00bf89010 r9  : e00000b00bf89020 r10 : 0000000000004000
r11 : 0000000000000001 r12 : e00000b00bf8fc30 r13 : e00000b00bf88000
r14 : e00000b00bf89020 r15 : e00000b003a5c054 r16 : 0000000000000001
r17 : e00000b00bf8fc40 r18 : e00000309b485f88 r19 : e000003003106478
r20 : e00000b00bf8fc40 r21 : a000000100adb760 r22 : e000003003105f10
r23 : 0000000100365757 r24 : 0000000100365756 r25 : 0000000000000056
r26 : e00000309b485f88 r27 : e00000b00bf8fc40 r28 : e000003003106480
r29 : e00000b00bf8fc48 r30 : e00000309b485f90 r31 : e00000b00bf8fc40

Call Trace:
 [<a000000100012ae0>] show_stack+0x40/0xa0
                                sp=e00000b00bf8f890 bsp=e00000b00bf89628
 [<a0000001000133f0>] show_regs+0x850/0x8a0
                                sp=e00000b00bf8fa60 bsp=e00000b00bf895c8
 [<a0000001000f1790>] softlockup_tick+0x130/0x160
                                sp=e00000b00bf8fa60 bsp=e00000b00bf895a0
 [<a0000001000b9770>] do_timer+0x9b0/0x9e0
                                sp=e00000b00bf8fa60 bsp=e00000b00bf89560
 [<a0000001000370f0>] timer_interrupt+0x1b0/0x2e0
                                sp=e00000b00bf8fa60 bsp=e00000b00bf89520
 [<a0000001000f1960>] handle_IRQ_event+0xa0/0x140
                                sp=e00000b00bf8fa60 bsp=e00000b00bf894e0
 [<a0000001000f1b30>] __do_IRQ+0x130/0x3a0
                                sp=e00000b00bf8fa60 bsp=e00000b00bf89498
 [<a000000100010160>] ia64_handle_irq+0xa0/0x140
                                sp=e00000b00bf8fa60 bsp=e00000b00bf89468
 [<a00000010000bbe0>] ia64_leave_kernel+0x0/0x290
                                sp=e00000b00bf8fa60 bsp=e00000b00bf89468
 [<a0000001006fcf40>] _spin_lock_irqsave+0x120/0x180
                                sp=e00000b00bf8fc30 bsp=e00000b00bf89438
 [<a000000100532f60>] scsi_eh_scmd_add+0x60/0x1a0
                                sp=e00000b00bf8fc30 bsp=e00000b00bf893f0
 [<a0000001005331c0>] scsi_times_out+0x120/0x1a0
                                sp=e00000b00bf8fc30 bsp=e00000b00bf893d0
 [<a0000001000b87a0>] run_timer_softirq+0x2e0/0x420
                                sp=e00000b00bf8fc30 bsp=e00000b00bf893a0
 [<a0000001000ae050>] __do_softirq+0xd0/0x220
                                sp=e00000b00bf8fc40 bsp=e00000b00bf89328
 [<a0000001000ae210>] do_softirq+0x70/0xc0
                                sp=e00000b00bf8fc40 bsp=e00000b00bf892c8
 [<a0000001000ae2e0>] irq_exit+0x80/0xc0
                                sp=e00000b00bf8fc40 bsp=e00000b00bf892b0
 [<a0000001000101e0>] ia64_handle_irq+0x120/0x140
                                sp=e00000b00bf8fc40 bsp=e00000b00bf89280
 [<a00000010000bbe0>] ia64_leave_kernel+0x0/0x290
                                sp=e00000b00bf8fc40 bsp=e00000b00bf89280
 [<a0000001006fe040>] lock_kernel+0x160/0x200
                                sp=e00000b00bf8fe10 bsp=e00000b00bf89258
 [<a000000100177e40>] do_ioctl+0xe0/0x180
                                sp=e00000b00bf8fe10 bsp=e00000b00bf89218
 [<a000000100178760>] vfs_ioctl+0x880/0x8e0
                                sp=e00000b00bf8fe10 bsp=e00000b00bf891c8
 [<a000000100178820>] sys_ioctl+0x60/0xc0
                                sp=e00000b00bf8fe20 bsp=e00000b00bf89150
 [<a00000010000ba40>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000b00bf8fe30 bsp=e00000b00bf89150
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000b00bf90000 bsp=e00000b00bf89150

(I thought system was completely dead at this point.  It turns out
I was wrong.  It spit this out.  It also still responds to ping.
It is not possible to login.)

qla2300 0012:00:01.1: scsi(7:208:0): Abort command issued -- 42279 2002.
qla2300 0012:00:01.1: scsi(7:208:0): Abort command issued -- 42279 2002.
qla2300 0012:00:01.1: scsi(7:208:0): Abort command issued -- 42278 2002.
qla2300 0012:00:01.1: scsi(7:208:0): Abort command issued -- 42278 2002.
sd 7:0:208:0: scsi: Device offlined - not ready after error recovery
sd 7:0:208:0: scsi: Device offlined - not ready after error recovery
sd 7:0:208:0: rejecting I/O to offline device
sd 7:0:208:0: rejecting I/O to offline device
sd 7:0:208:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:209:0): Abort command issued -- 4227b 2002.
qla2300 0012:00:01.1: scsi(7:209:0): Abort command issued -- 4227b 2002.
qla2300 0012:00:01.1: scsi(7:209:0): Abort command issued -- 4227a 2002.
qla2300 0012:00:01.1: scsi(7:209:0): Abort command issued -- 4227a 2002.
sd 7:0:209:0: scsi: Device offlined - not ready after error recovery
sd 7:0:209:0: scsi: Device offlined - not ready after error recovery
sd 7:0:209:0: rejecting I/O to offline device
sd 7:0:209:0: rejecting I/O to offline device
sd 7:0:209:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:210:0): Abort command issued -- 4227d 2002.
qla2300 0012:00:01.1: scsi(7:210:0): Abort command issued -- 4227d 2002.
qla2300 0012:00:01.1: scsi(7:210:0): Abort command issued -- 4227c 2002.
qla2300 0012:00:01.1: scsi(7:210:0): Abort command issued -- 4227c 2002.
sd 7:0:210:0: scsi: Device offlined - not ready after error recovery
sd 7:0:210:0: scsi: Device offlined - not ready after error recovery
sd 7:0:210:0: rejecting I/O to offline device
sd 7:0:210:0: rejecting I/O to offline device
sd 7:0:210:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:211:0): Abort command issued -- 4227f 2002.
qla2300 0012:00:01.1: scsi(7:211:0): Abort command issued -- 4227f 2002.
qla2300 0012:00:01.1: scsi(7:211:0): Abort command issued -- 4227e 2002.
qla2300 0012:00:01.1: scsi(7:211:0): Abort command issued -- 4227e 2002.
sd 7:0:211:0: scsi: Device offlined - not ready after error recovery
sd 7:0:211:0: scsi: Device offlined - not ready after error recovery
sd 7:0:211:0: rejecting I/O to offline device
sd 7:0:211:0: rejecting I/O to offline device
sd 7:0:211:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:212:0): Abort command issued -- 42281 2002.
qla2300 0012:00:01.1: scsi(7:212:0): Abort command issued -- 42281 2002.
qla2300 0012:00:01.1: scsi(7:212:0): Abort command issued -- 42280 2002.
qla2300 0012:00:01.1: scsi(7:212:0): Abort command issued -- 42280 2002.
sd 7:0:212:0: scsi: Device offlined - not ready after error recovery
sd 7:0:212:0: scsi: Device offlined - not ready after error recovery
sd 7:0:212:0: rejecting I/O to offline device
sd 7:0:212:0: rejecting I/O to offline device
sd 7:0:212:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:213:0): Abort command issued -- 42283 2002.
qla2300 0012:00:01.1: scsi(7:213:0): Abort command issued -- 42283 2002.
qla2300 0012:00:01.1: scsi(7:213:0): Abort command issued -- 42282 2002.
qla2300 0012:00:01.1: scsi(7:213:0): Abort command issued -- 42282 2002.
sd 7:0:213:0: scsi: Device offlined - not ready after error recovery
sd 7:0:213:0: scsi: Device offlined - not ready after error recovery
sd 7:0:213:0: rejecting I/O to offline device
sd 7:0:213:0: rejecting I/O to offline device
sd 7:0:213:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:214:0): Abort command issued -- 42285 2002.
qla2300 0012:00:01.1: scsi(7:214:0): Abort command issued -- 42285 2002.
qla2300 0012:00:01.1: scsi(7:214:0): Abort command issued -- 42284 2002.
qla2300 0012:00:01.1: scsi(7:214:0): Abort command issued -- 42284 2002.
sd 7:0:214:0: scsi: Device offlined - not ready after error recovery
sd 7:0:214:0: scsi: Device offlined - not ready after error recovery
sd 7:0:214:0: rejecting I/O to offline device
sd 7:0:214:0: rejecting I/O to offline device
sd 7:0:214:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:215:0): Abort command issued -- 42287 2002.
qla2300 0012:00:01.1: scsi(7:215:0): Abort command issued -- 42287 2002.
qla2300 0012:00:01.1: scsi(7:215:0): Abort command issued -- 42286 2002.
qla2300 0012:00:01.1: scsi(7:215:0): Abort command issued -- 42286 2002.
sd 7:0:215:0: scsi: Device offlined - not ready after error recovery
sd 7:0:215:0: scsi: Device offlined - not ready after error recovery
sd 7:0:215:0: rejecting I/O to offline device
sd 7:0:215:0: rejecting I/O to offline device
sd 7:0:215:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:217:0): Abort command issued -- 4228c 2002.
qla2300 0012:00:01.1: scsi(7:217:0): Abort command issued -- 4228c 2002.
qla2300 0012:00:01.1: scsi(7:217:0): Abort command issued -- 4228b 2002.
qla2300 0012:00:01.1: scsi(7:217:0): Abort command issued -- 4228b 2002.
sd 7:0:217:0: scsi: Device offlined - not ready after error recovery
sd 7:0:217:0: scsi: Device offlined - not ready after error recovery
sd 7:0:217:0: rejecting I/O to offline device
sd 7:0:217:0: rejecting I/O to offline device
sd 7:0:217:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:219:0): Abort command issued -- 4229a 2002.
qla2300 0012:00:01.1: scsi(7:219:0): Abort command issued -- 4229a 2002.
qla2300 0012:00:01.1: scsi(7:219:0): Abort command issued -- 42299 2002.
qla2300 0012:00:01.1: scsi(7:219:0): Abort command issued -- 42299 2002.
sd 7:0:219:0: scsi: Device offlined - not ready after error recovery
sd 7:0:219:0: scsi: Device offlined - not ready after error recovery
sd 7:0:219:0: rejecting I/O to offline device
sd 7:0:219:0: rejecting I/O to offline device
sd 7:0:219:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:221:0): Abort command issued -- 422b5 2002.
qla2300 0012:00:01.1: scsi(7:221:0): Abort command issued -- 422b5 2002.
qla2300 0012:00:01.1: scsi(7:221:0): Abort command issued -- 422b4 2002.
qla2300 0012:00:01.1: scsi(7:221:0): Abort command issued -- 422b4 2002.
sd 7:0:221:0: scsi: Device offlined - not ready after error recovery
sd 7:0:221:0: scsi: Device offlined - not ready after error recovery
sd 7:0:221:0: rejecting I/O to offline device
sd 7:0:221:0: rejecting I/O to offline device
sd 7:0:221:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:222:0): Abort command issued -- 422ed 2002.
qla2300 0012:00:01.1: scsi(7:222:0): Abort command issued -- 422ed 2002.
qla2300 0012:00:01.1: scsi(7:222:0): Abort command issued -- 422ec 2002.
qla2300 0012:00:01.1: scsi(7:222:0): Abort command issued -- 422ec 2002.
sd 7:0:222:0: scsi: Device offlined - not ready after error recovery
sd 7:0:222:0: scsi: Device offlined - not ready after error recovery
sd 7:0:222:0: rejecting I/O to offline device
sd 7:0:222:0: rejecting I/O to offline device
sd 7:0:222:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:223:0): Abort command issued -- 422ef 2002.
qla2300 0012:00:01.1: scsi(7:223:0): Abort command issued -- 422ef 2002.
qla2300 0012:00:01.1: scsi(7:223:0): Abort command issued -- 422ee 2002.
qla2300 0012:00:01.1: scsi(7:223:0): Abort command issued -- 422ee 2002.
sd 7:0:223:0: scsi: Device offlined - not ready after error recovery
sd 7:0:223:0: scsi: Device offlined - not ready after error recovery
sd 7:0:223:0: rejecting I/O to offline device
sd 7:0:223:0: rejecting I/O to offline device
sd 7:0:223:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:224:0): Abort command issued -- 422f1 2002.
qla2300 0012:00:01.1: scsi(7:224:0): Abort command issued -- 422f1 2002.
qla2300 0012:00:01.1: scsi(7:224:0): Abort command issued -- 422f0 2002.
qla2300 0012:00:01.1: scsi(7:224:0): Abort command issued -- 422f0 2002.
sd 7:0:224:0: scsi: Device offlined - not ready after error recovery
sd 7:0:224:0: scsi: Device offlined - not ready after error recovery
sd 7:0:224:0: rejecting I/O to offline device
sd 7:0:224:0: rejecting I/O to offline device
sd 7:0:224:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:225:0): Abort command issued -- 422f3 2002.
qla2300 0012:00:01.1: scsi(7:225:0): Abort command issued -- 422f3 2002.
qla2300 0012:00:01.1: scsi(7:225:0): Abort command issued -- 422f2 2002.
qla2300 0012:00:01.1: scsi(7:225:0): Abort command issued -- 422f2 2002.
sd 7:0:225:0: scsi: Device offlined - not ready after error recovery
sd 7:0:225:0: scsi: Device offlined - not ready after error recovery
sd 7:0:225:0: rejecting I/O to offline device
sd 7:0:225:0: rejecting I/O to offline device
sd 7:0:225:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:226:0): Abort command issued -- 422f5 2002.
qla2300 0012:00:01.1: scsi(7:226:0): Abort command issued -- 422f5 2002.
qla2300 0012:00:01.1: scsi(7:226:0): Abort command issued -- 422f4 2002.
qla2300 0012:00:01.1: scsi(7:226:0): Abort command issued -- 422f4 2002.
sd 7:0:226:0: scsi: Device offlined - not ready after error recovery
sd 7:0:226:0: scsi: Device offlined - not ready after error recovery
sd 7:0:226:0: rejecting I/O to offline device
sd 7:0:226:0: rejecting I/O to offline device
sd 7:0:226:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:227:0): Abort command issued -- 422f7 2002.
qla2300 0012:00:01.1: scsi(7:227:0): Abort command issued -- 422f7 2002.
qla2300 0012:00:01.1: scsi(7:227:0): Abort command issued -- 422f6 2002.
qla2300 0012:00:01.1: scsi(7:227:0): Abort command issued -- 422f6 2002.
sd 7:0:227:0: scsi: Device offlined - not ready after error recovery
sd 7:0:227:0: scsi: Device offlined - not ready after error recovery
sd 7:0:227:0: rejecting I/O to offline device
sd 7:0:227:0: rejecting I/O to offline device
sd 7:0:227:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:228:0): Abort command issued -- 422f9 2002.
qla2300 0012:00:01.1: scsi(7:228:0): Abort command issued -- 422f9 2002.
qla2300 0012:00:01.1: scsi(7:228:0): Abort command issued -- 422f8 2002.
qla2300 0012:00:01.1: scsi(7:228:0): Abort command issued -- 422f8 2002.
sd 7:0:228:0: scsi: Device offlined - not ready after error recovery
sd 7:0:228:0: scsi: Device offlined - not ready after error recovery
sd 7:0:228:0: rejecting I/O to offline device
sd 7:0:228:0: rejecting I/O to offline device
sd 7:0:228:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:229:0): Abort command issued -- 422fb 2002.
qla2300 0012:00:01.1: scsi(7:229:0): Abort command issued -- 422fb 2002.
qla2300 0012:00:01.1: scsi(7:229:0): Abort command issued -- 422fa 2002.
qla2300 0012:00:01.1: scsi(7:229:0): Abort command issued -- 422fa 2002.
sd 7:0:229:0: scsi: Device offlined - not ready after error recovery
sd 7:0:229:0: scsi: Device offlined - not ready after error recovery
sd 7:0:229:0: rejecting I/O to offline device
sd 7:0:229:0: rejecting I/O to offline device
sd 7:0:229:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:230:0): Abort command issued -- 422fd 2002.
qla2300 0012:00:01.1: scsi(7:230:0): Abort command issued -- 422fd 2002.
qla2300 0012:00:01.1: scsi(7:230:0): Abort command issued -- 422fc 2002.
qla2300 0012:00:01.1: scsi(7:230:0): Abort command issued -- 422fc 2002.
sd 7:0:230:0: scsi: Device offlined - not ready after error recovery
sd 7:0:230:0: scsi: Device offlined - not ready after error recovery
sd 7:0:230:0: rejecting I/O to offline device
sd 7:0:230:0: rejecting I/O to offline device
sd 7:0:230:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:231:0): Abort command issued -- 422ff 2002.
qla2300 0012:00:01.1: scsi(7:231:0): Abort command issued -- 422ff 2002.
qla2300 0012:00:01.1: scsi(7:231:0): Abort command issued -- 422fe 2002.
qla2300 0012:00:01.1: scsi(7:231:0): Abort command issued -- 422fe 2002.
sd 7:0:231:0: scsi: Device offlined - not ready after error recovery
sd 7:0:231:0: scsi: Device offlined - not ready after error recovery
sd 7:0:231:0: rejecting I/O to offline device
sd 7:0:231:0: rejecting I/O to offline device
sd 7:0:231:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:233:0): Abort command issued -- 42304 2002.
qla2300 0012:00:01.1: scsi(7:233:0): Abort command issued -- 42304 2002.
qla2300 0012:00:01.1: scsi(7:233:0): Abort command issued -- 42303 2002.
qla2300 0012:00:01.1: scsi(7:233:0): Abort command issued -- 42303 2002.
sd 7:0:233:0: scsi: Device offlined - not ready after error recovery
sd 7:0:233:0: scsi: Device offlined - not ready after error recovery
sd 7:0:233:0: rejecting I/O to offline device
sd 7:0:233:0: rejecting I/O to offline device
sd 7:0:233:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42329 2002.
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42329 2002.
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42328 2002.
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42328 2002.
sd 7:0:235:0: scsi: Device offlined - not ready after error recovery
sd 7:0:235:0: scsi: Device offlined - not ready after error recovery
sd 7:0:235:0: rejecting I/O to offline device
sd 7:0:235:0: rejecting I/O to offline device
sd 7:0:235:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:233:0): Abort command issued -- 42303 2002.
qla2300 0012:00:01.1: scsi(7:233:0): Abort command issued -- 42303 2002.
sd 7:0:233:0: scsi: Device offlined - not ready after error recovery
sd 7:0:233:0: scsi: Device offlined - not ready after error recovery
sd 7:0:233:0: rejecting I/O to offline device
sd 7:0:233:0: rejecting I/O to offline device
sd 7:0:233:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42329 2002.
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42329 2002.
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42328 2002.
qla2300 0012:00:01.1: scsi(7:235:0): Abort command issued -- 42328 2002.
sd 7:0:235:0: scsi: Device offlined - not ready after error recovery
sd 7:0:235:0: scsi: Device offlined - not ready after error recovery
sd 7:0:235:0: rejecting I/O to offline device
sd 7:0:235:0: rejecting I/O to offline device
sd 7:0:235:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:237:0): Abort command issued -- 42362 2002.
qla2300 0012:00:01.1: scsi(7:237:0): Abort command issued -- 42362 2002.
qla2300 0012:00:01.1: scsi(7:237:0): Abort command issued -- 42361 2002.
qla2300 0012:00:01.1: scsi(7:237:0): Abort command issued -- 42361 2002.
sd 7:0:237:0: scsi: Device offlined - not ready after error recovery
sd 7:0:237:0: scsi: Device offlined - not ready after error recovery
sd 7:0:237:0: rejecting I/O to offline device
sd 7:0:237:0: rejecting I/O to offline device
sd 7:0:237:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:238:0): Abort command issued -- 42398 2002.
qla2300 0012:00:01.1: scsi(7:238:0): Abort command issued -- 42398 2002.
qla2300 0012:00:01.1: scsi(7:238:0): Abort command issued -- 42397 2002.
qla2300 0012:00:01.1: scsi(7:238:0): Abort command issued -- 42397 2002.
sd 7:0:238:0: scsi: Device offlined - not ready after error recovery
sd 7:0:238:0: scsi: Device offlined - not ready after error recovery
sd 7:0:238:0: rejecting I/O to offline device
sd 7:0:238:0: rejecting I/O to offline device
sd 7:0:238:0: rejecting I/O to offline device
qla2300 0012:00:01.1: scsi(7:239:0): Abort command issued -- 4239a 2002.
qla2300 0012:00:01.1: scsi(7:239:0): Abort command issued -- 4239a 2002.
qla2300 0012:00:01.1: scsi(7:239:0): Abort command issued -- 42399 2002.
qla2300 0012:00:01.1: scsi(7:239:0): Abort command issued -- 42399 2002.
sd 7:0:239:0: scsi: Device offlined - not ready after error recovery
sd 7:0:239:0: scsi: Device offlined - not ready after error recovery
sd 7:0:239:0: rejecting I/O to offline device
sd 7:0:239:0: rejecting I/O to offline device
sd 7:0:239:0: rejecting I/O to offline device
