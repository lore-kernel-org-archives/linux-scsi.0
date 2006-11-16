From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] final SCSI fixes for 2.6.19-rc6
Date: Thu, 16 Nov 2006 10:23:14 -0600
Message-ID: <1163694194.3464.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34709 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1424270AbWKPQXW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 11:23:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

These are the dump of the final -rc fixes I've been collecting. The
patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The Short Changelog is:

<malahal:us.ibm.com>:
  o aic94xx SCSI timeout fix: SMP retry fix
  o aic94xx SCSI timeout fix

adam radford:
  o 3ware 9000 add support for 9650SE

Adrian Bunk:
  o psi240i.c: fix an array overrun

Douglas Gilbert:
  o sg: fix incorrect last scatg length

Jean Delvare:
  o gdth: Fix && typos

Mike Christie:
  o iscsi class: update version
  o iscsi_tcp: fix xmittask oops

Pete Wyckoff:
  o iscsi: add newlines to debug messages
  o iscsi: always release crypto

and the diffstat:

 3w-9xxx.c              |  141 +++++++++++++++++++++++++++++--------------------
 3w-9xxx.h              |   14 +++-
 aic94xx/aic94xx_hwi.c  |   18 ++++++
 aic94xx/aic94xx_hwi.h  |   12 ++++
 aic94xx/aic94xx_init.c |    2 
 aic94xx/aic94xx_sas.h  |    1 
 aic94xx/aic94xx_scb.c  |   72 +++++++++++++++++++++++++
 aic94xx/aic94xx_seq.c  |    5 -
 aic94xx/aic94xx_seq.h  |    2 
 gdth.c                 |    4 -
 iscsi_tcp.c            |   22 +++----
 libiscsi.c             |    9 +--
 libsas/sas_expander.c  |   90 +++++++++++++++++--------------
 psi240i.c              |    2 
 scsi_transport_iscsi.c |    2 
 sg.c                   |   25 ++++----
 16 files changed, 281 insertions(+), 140 deletions(-)

James


