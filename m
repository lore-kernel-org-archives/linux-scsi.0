From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4077] New: kernel oops with Fusion MPT SCSI
 driver
Date: Fri, 21 Jan 2005 15:32:14 -0800
Message-ID: <20050121153214.2468cbc5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:11149 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262601AbVAUX12 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2005 18:27:28 -0500
Received: from akpm.pao.digeo.com (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id j0LNRRl14401
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2005 15:27:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Fri, 21 Jan 2005 10:59:36 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4077] New: kernel oops with Fusion MPT SCSI driver


http://bugme.osdl.org/show_bug.cgi?id=4077

           Summary: kernel oops with Fusion MPT SCSI driver
    Kernel Version: 2.6.10
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: jd@ts.ray.fi


Distribution:   gentoo 2004.3
Hardware Environment:   ppc64/PowerMac G5
Software Environment:
Problem Description:
    kernel oops/hang with Fusion MPT/mptscsih driver and 
    LSI22320/LSI21320 SCSI-card

Steps to reproduce:

   modprobe -a mptscsih

  result:

    Oops: Kernel access of bad area, sig: 11 [#3]
    SMP NR_CPUS=2 POWERMAC 
    NIP: C00000000007F94C XER: 0000000000000000 LR: C00000000007FAD8
    REGS: c00000000ff8f900 TRAP: 0300   Not tainted  (2.6.10-pristine-noide-snd)
    MSR: 9000000000001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
    DAR: 000000013d762008, DSISR: 0000000042000000
    TASK: c00000003ef887b0[6] 'events/0' THREAD: c00000000ff8c000 CPU: 0
    GPR00: 0000000000000038 C00000000FF8FB80 C00000000060AC98 C00000003EFD0B80 
    GPR04: C00000003EFD1410 C00000003D6F4028 0000000000100100 C00000000066B400 
    GPR08: 0000000000200200 000000013D762000 C00000003EB52000 C00000003D6F4280 
    GPR12: C00000003D6F4000 C0000000004D2800 0000000000000000 0000000000000000 
    GPR16: 0000000001400000 C000000000475990 0000000001872FA0 0000000001872FA0 
    GPR20: BFFFFFFFFEC00000 C000000000489000 C00000003EFD07B8 0000000000100100 
    GPR24: C00000003EFD0BB8 C00000003EFD1410 0000000000000018 C00000003EFD0B98 
    GPR28: 000000000000000D C00000003EFD0B80 C0000000004F8258 C00000000FF8FB80 
    NIP [c00000000007f94c] .free_block+0xf0/0x1b8
    LR [c00000000007fad8] .drain_array_locked+0xc4/0x138
    Call Trace:
    [c00000000ff8fb80] [c00000000ff8fc20] 0xc00000000ff8fc20 (unreliable)
    [c00000000ff8fc30] [c00000000007fad8] .drain_array_locked+0xc4/0x138
    [c00000000ff8fcd0] [c000000000081100] .cache_reap+0xc4/0x2b4
    [c00000000ff8fdb0] [c0000000000610a4] .worker_thread+0x254/0x320
    [c00000000ff8fee0] [c000000000067964] .kthread+0x168/0x1bc
    [c00000000ff8ff90] [c000000000013ee0] .kernel_thread+0x4c/0x6c

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
