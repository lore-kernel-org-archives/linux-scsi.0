From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: BK: scsi-misc cs inconsistencies?
Date: Wed, 14 Jul 2004 12:24:29 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0407141209450.2892@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:27023 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267353AbUGNK1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 06:27:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Hello

I've searched scsi-misc cs-entries on bk, and they don't seem to be quite 
consistent:

Linux kernel tree Search results for "tmscsim" in ChangeSet comments

Filename  Rev		Match

ChangeSet 1.1861	[PATCH] tmscsim: kernel bugzilla bug #2139 
ChangeSet 1.1760.31.6	[PATCH] kill obsolete typedefs and wrappers from tmscsim 
ChangeSet 1.1760.31.5	[PATCH] some tmscsim consolidation 
(6)
ChangeSet 1.1760.31.5	> I've looked through my old tmscsim patch queue and found this one: 
(7)
ChangeSet 1.1739.2.17	[PATCH] tmscsim: host_lock use in LLD 
(1)
ChangeSet 1.1739.2.17	While reviewing tmscsim, I noticed something, I didn't quite like / 
(2)
ChangeSet 1.1739.2.16	[PATCH] tmscsim: init / exit cleanup 
ChangeSet 1.1722.73.26	[PATCH] tmscsim: 64-bit cleanup 
(3)
ChangeSet 1.1722.73.26	tmscsim.c. 
(4)
ChangeSet 1.1722.73.5	[PATCH] tmscsim: Store pDCB in device->hostdata 
ChangeSet 1.1722.45.17	[PATCH] tmscsim: convert to slave_... 
ChangeSet 1.1722.45.15	[PATCH] tmscsim: remove DeviceCnt 
ChangeSet 1.1722.45.14	[PATCH] tmscsim: Update version after "new API" 
ChangeSet 1.1612.6.20	[PATCH] tmscsim: trivial updates 
ChangeSet 1.1612.6.14	[PATCH] tmscsim: remove legacy and void code 
ChangeSet 1.1612.6.13	tmscsim: remove procfs write support from tmscsim 
ChangeSet 1.1612.6.11	[PATCH] tmscsim: no internal queue 
ChangeSet 1.1612.6.9	[PATCH] tmscsim: 64-bit cleanup 
(5)
ChangeSet 1.1371.1.378	[PATCH] Fix tmscsim on amd64 
ChangeSet 1.1371.94.3	SCSI: Fix tmscsim driver 
ChangeSet 1.1046.250.59	PCI: remove pci_present() from drivers/scsi/tmscsim.c

Here, (6), (7); (1), (2); and (3), (4) have the same cs-number, (3) and 
(5) have the same description. Is it a problem with the BK itself, or with 
the way these entries have been committed? In the former case I can 
forward this to Larry / BitMover support / whatever. Or is just my 
understanding wrong and all those fields do not have to be unique?...

Thanks
Guennadi
---
Guennadi Liakhovetski

