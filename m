From: Jurij Smakov <jurijus@wooyd.org>
Subject: Re: qla1280 driver not working on AlphaStation 600 5/266
Date: Sat, 25 Mar 2006 17:33:59 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0603251725120.4221@bobcat>
References: <Pine.NEB.4.58.0603112006270.25114@kepler.ccac.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mouth.voxel.net ([69.9.180.118]:45201 "EHLO mail.squishy.cc")
	by vger.kernel.org with ESMTP id S1751273AbWCZBeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Mar 2006 20:34:03 -0500
In-Reply-To: <Pine.NEB.4.58.0603112006270.25114@kepler.ccac.rwth-aachen.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alfred Arnold <alfred@ccac.rwth-aachen.de>
Cc: Christoph Hellwig <hch@relay.sgi.com>, linux-scsi@vger.kernel.org, 313552@bugs.debian.org

On Sat, 11 Mar 2006, Alfred Arnold wrote:

> Hi,
>
> I have a Digital AlphaStation 600 5/266, and I am trying to get kernel
> 2.6.15.3 running on it.  I have however a problem with the qla1280 driver
> for the SCSI controller.  The only output I get is
>
> qla1280: QLA1040 found on PCI bus 1, dev 2
> qla1280: Failed mbox check
> qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 =
> 0x4003, istatus = 0x0000
> m0 4003, m1 aaaa, m2 0000, m3 aa55
> m4 55aa, m5 a5a5, m6 a5a5, m7 a5a5
>
> ...and booting naturally ends with a kernel panic because it cannot mount
> the root filesystem.

We have received a similar bug report with nearly identical symptoms in 
Debian: http://bugs.debian.org/313552. Submitter reports that qla1280 
driver fails on 2.6 kernels with messages:

qla1280: QLA1040 found on PCI bus 1, dev 1
PCI: Setting latency timer of device 0000:01:01.0 to 64
qla1280: Failed mbox check
qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 
0x4003, istatus = 0x0000
m0 4003, m1 aaaa, m2 0000, m3 aa55
m4 55aa, m5 a5a5, m6 a5a5, m7 a5a5
scsi(0): Failed checksum
scsi(0): initialize: pci probe failed!
qla1x160: Failed to initialize adapter
qla1280: QLA1040 found on PCI bus 1, dev 2
PCI: Setting latency timer of device 0000:01:02.0 to 64
qla1280: Failed mbox check
qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 
0x4003, istatus = 0x0000
m0 4003, m1 aaaa, m2 0000, m3 aa55
m4 55aa, m5 a5a5, m6 a5a5, m7 a5a5
scsi(1): Failed checksum
scsi(1): initialize: pci probe failed!
qla1x160: Failed to initialize adapter

I took the liberty to CC Christoph Hellwig, the author of the qla1280 
driver (hope it's ok!). Any ideas on how to fix this will be greatly 
appreciated.

Thanks and best regards,

Jurij Smakov                                        jurij@wooyd.org
Debian Kernel Team
Key: http://www.wooyd.org/pgpkey/                   KeyID: C99E03CC
