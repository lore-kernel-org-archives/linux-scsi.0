From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Tue, 14 Sep 2010 18:36:30 +0400
Message-ID: <4C8F886E.2080407@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi All,

Please review this second iteration of the patch set of the new (although, perhaps, the oldest) SCSI target framework for Linux SCST with a set of dev handlers and 2 target drivers: for local access (scst_local) and for Infiniband SRP (srpt).

SCST is the most advanced and features rich SCSI target subsystem for Linux. It allows to build the highest performing devices and clusters delivering millions of IOPS. Many companies are using it as a foundation for their storage products and solutions. List of some of them you can find on http://scst.sourceforge.net/users.html. There are also many other who not yet added there or prefer for some reasons to not be listed on this page.

Detail description of SCST, its drivers and utilities you can find on SCST home page http://scst.sourceforge.net. Detail features list and comparison with other Linux target subsystems you can find on http://scst.sourceforge.net/comparison.html. Description of the SCST processing flow you can find in http://scst.sourceforge.net/scst_pg.html (especially see picture "The commands processing flow").

The previous iteration of the SCST patch set you can find on http://lkml.org/lkml/2010/4/13/146. The first: http://lkml.org/lkml/2008/12/10/245.

We believe that this iteration is fully mainline ready. The only piece missed for the drop in replacement for STGT is port of ibmvstgt driver to SCST. Bart Van Assche is working on it. You can find intermediate versions of it in the SCST SVN. You can find instructions how to have access to it on the SCST downloads page http://scst.sourceforge.net/downloads.html.

This iteration for simplicity contains only 2 target drivers: for local access (scst_local) and SRP (ib_srpt). If SCST accepted, we will prepare and submit patches for other target drivers: for iSCSI, FCoE, QLogic Fibre Channel QLA 2xxx, Emulex Fibre Channel and FCoE, Marvell 88SE63xx/64xx/68xx/94xx SAS hardware.

This patchset is for kernel 2.6.35. On request we will rebase it for any other kernel tree. Since SCST is quite self-contained and almost doesn't touch outside kernel code, there are no problems in it.

Thanks,
Vlad
