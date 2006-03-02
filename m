From: Dave Jones <davej@redhat.com>
Subject: Attempting to use SCSI tape drive triggers kernel BUG
Date: Thu, 2 Mar 2006 00:08:52 -0500
Message-ID: <20060302050852.GA1034@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28032 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750748AbWCBFI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 00:08:59 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id k2258xF3003528
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 00:08:59 -0500
Received: from nwo.kernelslacker.org (vpn83-121.boston.redhat.com [172.16.83.121])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id k2258r125916
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 00:08:53 -0500
Received: from nwo.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by nwo.kernelslacker.org (8.13.5/8.13.5) with ESMTP id k2258rnn002338
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 00:08:53 -0500
Received: (from davej@localhost)
	by nwo.kernelslacker.org (8.13.5/8.13.5/Submit) id k2258rvu002337
	for linux-scsi@vger.kernel.org; Thu, 2 Mar 2006 00:08:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This has been around for a while, and is still there with latest
rc5-git's.

		Dave


--G4iJoqBmSsgzjUCe
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <apache@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.1.0 (2005-09-13) on
	nwo.kernelslacker.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00,
	NO_REAL_NAME autolearn=ham version=3.1.0
Received: from 172.16.58.1 [172.16.58.1]
	by nwo.kernelslacker.org with IMAP (fetchmail-6.3.2)
	for <davej@localhost> (single-drop); Tue, 28 Feb 2006 12:58:56 -0500 (EST)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by devserv.devel.redhat.com (8.12.11/8.12.11) with ESMTP id k1SHwMbK017943
	for <davej@devserv.devel.redhat.com>; Tue, 28 Feb 2006 12:58:22 -0500
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id k1SHwM116576
	for <davej@redhat.com>; Tue, 28 Feb 2006 12:58:22 -0500
Received: from www.beta.redhat.com (beta.redhat.com [172.16.48.203])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id k1SHwM4A031869
	for <davej@redhat.com>; Tue, 28 Feb 2006 12:58:22 -0500
Received: from www.beta.redhat.com (localhost.localdomain [127.0.0.1])
	by www.beta.redhat.com (8.12.11/8.12.10) with ESMTP id k1SHr0Kq020842
	for <davej@redhat.com>; Tue, 28 Feb 2006 12:53:00 -0500
Received: (from apache@localhost)
	by www.beta.redhat.com (8.12.11/8.12.11/Submit) id k1SHr0UF020840;
	Tue, 28 Feb 2006 12:53:00 -0500
Date: Tue, 28 Feb 2006 12:53:00 -0500
Message-Id: <200602281753.k1SHr0UF020840@www.beta.redhat.com>
From: bugzilla@redhat.com
To: davej@redhat.com
Subject: [Bug 180389] Attempting to use SCSI tape drive triggers kernel BUG
Content-type: text/plain; charset=utf-8
In-Reply-To: <bug-180389-150705@bugzilla.redhat.com>
X-Loop: bugzilla@redhat.com
X-BeenThere: bugzilla@redhat.com
X-Bugzilla-Product: Fedora Core
X-Bugzilla-Version: devel
X-Bugzilla-Component: kernel
X-Bugzilla-Comment: Public
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Changed-Fields: Status Status 

Please do not reply directly to this email. All additional
comments should be made in the comments box of this bug report.

Summary: Attempting to use SCSI tape drive triggers kernel BUG


https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=180389


fenlason@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEEDINFO_REPORTER           |ASSIGNED
             Status|NEEDINFO_REPORTER           |ASSIGNED




------- Additional Comments From fenlason@redhat.com  2006-02-28 12:52 EST -------
2.6.15-1.1991_FC5smp still fails 
 
st0: Block limits 2 - 16777215 bytes. 
kfree_debugcheck: out of range ptr fffffffch. 
------------[ cut here ]------------ 
kernel BUG at mm/slab.c:2490! 
invalid opcode: 0000 [#1] 
SMP  
last sysfs file: /block/sda/sda1/size 
Modules linked in: nfsd exportfs lockd nfs_acl ipv6 ppdev autofs4 rfcomm l2cap 
b 
luetooth sunrpc lp parport_pc parport floppy nvram uhci_hcd st sg snd_cmipci 
gam 
eport snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss 
snd_mixer 
_oss snd_pcm snd_page_alloc matroxfb_base snd_opl3_lib matroxfb_DAC1064 
snd_time 
r matroxfb_accel snd_hwdep matroxfb_Ti3026 snd_mpu401_uart matroxfb_g450 
snd_raw 
midi g450_pll snd_seq_device snd matroxfb_misc soundcore matrox_w1 wire e100 
mii 
 i2c_piix4 i2c_core dm_snapshot dm_zero dm_mirror dm_mod ext3 jbd aic7xxx 
scsi_t 
ransport_spi sd_mod scsi_mod 
CPU:    0 
EIP:    0060:[<c015f311>]    Not tainted VLI 
EFLAGS: 00010086   (2.6.15-1.1991_FC5smp #1)  
EIP is at kfree_debugcheck+0x20/0x51 
eax: 00000031   ebx: 0003ffff   ecx: d4018dfc   edx: c0315f6d 
esi: fffffffc   edi: fffffffc   ebp: 00000246   esp: d4018df8 
ds: 007b   es: 007b   ss: 0068 
Process amcheck (pid: 2568, threadinfo=d4018000 task=d46d03b0) 
Stack: <0>c0315f6d fffffffc 00000000 dffdeb00 c015fa51 c0149d2e 00000000 
dffdeb0 
0  
       dffdcb70 00000246 c0161559 dfd6c9d0 c1770170 00000000 de613598 c0149d2e  
       d463cea0 c1770170 d463cea0 c016822d 00000a00 00000000 c01680e8 e0842418  
Call Trace: 
 [<c015fa51>] cache_free_debugcheck+0x1b/0x1b9     [<c0149d2e>] 
mempool_free+0x5 
f/0x63 
 [<c0161559>] kmem_cache_free+0x2a/0x5c     [<c0149d2e>] 
mempool_free+0x5f/0x63 
 [<c016822d>] bio_free+0x25/0x30     [<c01680e8>] bio_put+0x28/0x29 
 [<e0842418>] scsi_execute_async+0x13f/0x317 [scsi_mod]     [<e0a38677>] 
st_do_s 
csi+0x1d3/0x228 [st] 
 [<e0a3a4f9>] st_sleep_done+0x0/0x3a [st]     [<e0a3c439>] st_read+0x2fb/0x78b 
[ 
st] 
 [<e0a3c13e>] st_read+0x0/0x78b [st]     [<c01641c9>] vfs_read+0x9f/0x13e 
 [<c0164615>] sys_read+0x3c/0x63     [<c0103d81>] syscall_call+0x7/0xb 
Code: 26 0a cc 5e 31 c0 58 5b 5e 5f c3 56 53 89 c6 8d 98 00 00 00 40 c1 eb 0c 
3b 
 1d 00 23 48 c0 72 15 50 68 6d 5f 31 c0 e8 16 48 fc ff <0f> 0b ba 09 cc 5e 31 
c0 
 58 5a 6b c3 28 03 05 10 23 48 c0 8b 00  
Continuing in 1 seconds.    
 <3>Debug: sleeping function called from invalid context at 
include/linux/rwsem. 
h:43 
in_atomic():0, irqs_disabled():1 
 [<c0124881>] profile_task_exit+0x13/0x48     [<c01261a3>] do_exit+0x1c/0x6fc 
 [<c010526c>] register_die_notifier+0x0/0x2f     [<c010584e>] 
do_invalid_op+0x0/ 
0x9d 
 [<c01058df>] do_invalid_op+0x91/0x9d     [<c015f311>] 
kfree_debugcheck+0x20/0x5 
1 
 [<c0123993>] vprintk+0x195/0x329     [<c0149d69>] mempool_alloc+0x37/0xd3 
 [<c0160050>] kmem_cache_alloc+0x7f/0x89     [<c0149d69>] 
mempool_alloc+0x37/0xd 
3 
 [<c0149d69>] mempool_alloc+0x37/0xd3     [<c01d2d5a>] 
cfq_set_request+0x318/0x4 
3a 
 [<c01048a7>] error_code+0x4f/0x54     [<c015f311>] kfree_debugcheck+0x20/0x51 
 [<c015fa51>] cache_free_debugcheck+0x1b/0x1b9     [<c0149d2e>] 
mempool_free+0x5 
f/0x63 
 [<c0161559>] kmem_cache_free+0x2a/0x5c     [<c0149d2e>] 
mempool_free+0x5f/0x63 
 [<c016822d>] bio_free+0x25/0x30     [<c01680e8>] bio_put+0x28/0x29 
 [<e0842418>] scsi_execute_async+0x13f/0x317 [scsi_mod]     [<e0a38677>] 
st_do_s 
csi+0x1d3/0x228 [st] 
 [<e0a3a4f9>] st_sleep_done+0x0/0x3a [st]     [<e0a3c439>] st_read+0x2fb/0x78b 
[ 
st] 
 [<e0a3c13e>] st_read+0x0/0x78b [st]     [<c01641c9>] vfs_read+0x9f/0x13e 
 [<c0164615>] sys_read+0x3c/0x63     [<c0103d81>] syscall_call+0x7/0xb 
 

-- 
Configure bugmail: https://bugzilla.redhat.com/bugzilla/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

--G4iJoqBmSsgzjUCe--
