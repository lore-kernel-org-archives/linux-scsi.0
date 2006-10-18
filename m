From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: RE: [aacraid] Adaptec 2820SA Crash
Date: Tue, 17 Oct 2006 17:20:28 -0700
Message-ID: <1161130828.15035.4.camel@home-desk>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F02CE35B6@otce2k03.adaptec.com>
	 <1159574928.3889.176.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:28852 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1751290AbWJRAU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 20:20:29 -0400
In-Reply-To: <1159574928.3889.176.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 2006-09-29 at 17:08 -0700, Sean Bruno wrote:

> The system in question is an ASUS M2N32WS motherboard running an
> Dual-Core Athlon64.
> 
> The 2820SA was tested with firmware revisions 9194 and 8832.  
> 
> The running o/s is Fedora Core 6 Test 3 with their latest renditions of
> 2.6.18.  I also compiled and tested vanilla 2.6.18 with the kernel
> configuration from Fedora's kernels.
> 
> The driver version of aacraid reports as 1.1-5[2409]-mh2.
> 
> 
> udevd[541]: add_to_rules: invalid rule
> '/etc/udev/rules.d/50-udev.rules:153'
> Unable to handle kernel paging request at ffffc20010084044 RIP:
>  [<ffffffff88169501>] :aacraid:aac_rkt_intr+0x1a/0x122
> PGD 3fc1a067 PUD 3fc1b067 PMD 3fdf7067 PTE 0
> Oops: 0000 [1] SMP
> last sysfs file: /class/net/lo/type
> CPU 0
> Modules linked in: i2c_nforce2 ohci1394 i2c_core ieee1394 floppy aacraid
> pcspkrdPid: 743, comm: modprobe Not tainted 2.6.18-1.2693.fc6 #1
> RIP: 0010:[<ffffffff88169501>]
> [<ffffffff88169501>] :aacraid:aac_rkt_intr+0x1a2RSP:
> 0018:ffffffff80716ef8  EFLAGS: 00010002
> RAX: 0000000000000000 RBX: ffff81003c61b138 RCX: ffffc20010084000
> RDX: ffff81003d4af9e8 RSI: ffff81003bbe26d8 RDI: 00000000000000b1
> RBP: ffffffff80716f08 R08: ffffffff80716f28 R09: 0000000000000001
> R10: ffffffff802c238e R11: ffffffff806be440 R12: ffff81003bbe26d8
> R13: 0000000000000000 R14: 00000000000000b1 R15: ffff81003d4af9e8
> FS:  00002aaaaaab6240(0000) GS:ffffffff8069b000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffc20010084044 CR3: 000000003ce1f000 CR4: 00000000000006e0
> Process modprobe (pid: 743, threadinfo ffff81003d4ae000, task
> ffff81003ee510c0)


It looks suspiciously like the Motherboard itself is hosed in a subtle
way.  Putting a plain Jane 29160 in the PCI-X slot of the Mobo causes
the system to pretty much lockup instead of panic.

Sean


