From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Drivers accessors latest version
Date: Tue, 30 Oct 2007 19:49:45 +0200
Message-ID: <47276EB9.7070603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3473 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115AbXJ3Rty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 13:49:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi

lots of drivers changed yet again do to latest SG API fixes.
There is no use me sending all of them again. They are available
on a public git tree.

you can pull them from:
git-pull git://bhalevy.com/open-osd accessors

They are based on todays scsi-misc tree. If you want that I preform
any changes before you pull please just ask.

shortlog below

b6f2026... isd200.c: use one-element sg list in issuing commands
6b3727d... usb: transport - convert to accessors and !use_sg code path removal
3439a91... usb: protocol.c - convert to accessors and !use_sg code path removal
8739148... usb: shuttle_usbat.c - convert to accessors and !use_sg code path removal
a5207db... usb: freecom.c & sddr09.c - convert to accessors and !use_sg cleanup
1390243... NCR5380 familly convert to accessors & !use_sg cleanup
cdd77de... arm: scsi convert to accessors and !use_sg cleanup
9bc7373... nsp_cs.c convert to data accessors and !use_sg cleanup
b82e0e9... eata_pio.c: convert to accessors and !use_sg cleanup
2761373... a2091.c: convert to accessors and !use_sg cleanup
7f8e3b0... a3000.c: convert to accessors and !use_sg cleanup
36f4896... aha1542.c: convert to accessors and !use_sg cleanup
707fe55... atp870u.c: convert to accessors and !use_sg cleanup
2fb56c0... fd_mcs.c: convert to accessors and !use_sg cleanup
80736b1... imm.c: convert to accessors and !use_sg cleanup
25a55f7... ppa.c: convert to accessors and !use_sg cleanup
f9fb2ad... wd33c93.c: convert to accessors and !use_sg cleanup
ac0b49c... qlogicpti.c: convert to accessors and !use_sg cleanup
2f5cb3d... in2000.c: convert to accessors and !use_sg cleanup
cb23b86... scsi_debug: convert to use the data buffer accessors
f7e0b4d... wd7000.c - proper fix for boards without sg support
9cd3d65... Remove psi240i driver from kernel
4dcf751... Remove of seagate.c driver

there is also a scsi_data_buffer branch on the same tree.
The last version I sent had a stupid but fatal bug which
is now fixed.

Thanks
Boaz
