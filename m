From: David Howells <dhowells@redhat.com>
Subject: UAPI: What remains to be pulled: SCSI and FCoE
Date: Thu, 20 Dec 2012 18:16:51 +0000
Message-ID: <2145.1356027411@warthog.procyon.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2LTSSH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2012 13:18:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, robert.w.love@intel.com, torvalds@osdl.org, hpa@zytor.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, devel@open-fcoe.org, linux-scsi@vger.kernel.org


Assuming Linus pulls the fbdev branch that I've sent him, all that remains to
be pulled of the UAPI changes are the SCSI and the FCoE bits.

Barring Kbuild updates, the SCSI patch just moves three files and the FCoE
patch just moves four files.  No actual header changes are made.  Is it
possible to get these in in this merge window?

I talked to James about the SCSI patch, but it didn't get picked up; I haven't
heard from Robert about the FCoE patch at all.

Below are two git pull requests, one for SCSI and one for FCoE.  I can resend
them separately to their mailing lists if need be.

Merry Christmas!
David
---
The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-scsi-20121219

for you to fetch changes up to ee7afd717c26299c85675d84c7ff89a9c989f4fa:

  UAPI: (Scripted) Disintegrate include/scsi (2012-12-19 16:07:23 +0000)

----------------------------------------------------------------
UAPI Disintegration 2012-12-19

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/scsi

 include/scsi/Kbuild                       | 3 ---
 include/uapi/scsi/Kbuild                  | 3 +++
 include/{ => uapi}/scsi/scsi_bsg_fc.h     | 0
 include/{ => uapi}/scsi/scsi_netlink.h    | 0
 include/{ => uapi}/scsi/scsi_netlink_fc.h | 0
 5 files changed, 3 insertions(+), 3 deletions(-)
 rename include/{ => uapi}/scsi/scsi_bsg_fc.h (100%)
 rename include/{ => uapi}/scsi/scsi_netlink.h (100%)
 rename include/{ => uapi}/scsi/scsi_netlink_fc.h (100%)

---
The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-fc-20121219

for you to fetch changes up to 6973d441bb53bdf58693c9e54493fc609d9e37cf:

  UAPI: (Scripted) Disintegrate include/scsi/fc (2012-12-19 16:07:25 +0000)

----------------------------------------------------------------
UAPI Disintegration 2012-12-19

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate include/scsi/fc

 include/scsi/fc/Kbuild              | 4 ----
 include/uapi/scsi/fc/Kbuild         | 4 ++++
 include/{ => uapi}/scsi/fc/fc_els.h | 0
 include/{ => uapi}/scsi/fc/fc_fs.h  | 0
 include/{ => uapi}/scsi/fc/fc_gs.h  | 0
 include/{ => uapi}/scsi/fc/fc_ns.h  | 0
 6 files changed, 4 insertions(+), 4 deletions(-)
 rename include/{ => uapi}/scsi/fc/fc_els.h (100%)
 rename include/{ => uapi}/scsi/fc/fc_fs.h (100%)
 rename include/{ => uapi}/scsi/fc/fc_gs.h (100%)
 rename include/{ => uapi}/scsi/fc/fc_ns.h (100%)
