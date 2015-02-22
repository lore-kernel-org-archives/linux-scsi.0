From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.19+ merge window
Date: Sat, 21 Feb 2015 18:51:04 -0800
Message-ID: <1424573464.2146.53.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47065 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbbBVCvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2015 21:51:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a short patch set representing a couple of left overs from the
merge window (debug leftover removal and MAINTAINER changes) plus one
merge window regression (the local workqueue for hpsa) and a set of bug
fixes for several issues (two for scsi-mq and the rest an assortment of
long standing stuff, all cc'd to stable).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Don Brace (1):
      hpsa: correct compiler warnings introduced by hpsa-add-local-workqueue patch

Hannes Reinecke (1):
      am53c974: remove left-over debugging code

Minh Duc Tran (1):
      fixed invalid assignment of 64bit mask to host dma_boundary for scatter gather segment boundary limit.

Ondrej Zary (1):
      wd719x: add missing .module to wd719x_template

Robert Love (1):
      fcoe: Transition maintainership to Vasu

Tony Battersby (3):
      sg: fix EWOULDBLOCK errors with scsi-mq
      sg: fix unkillable I/O wait deadlock with scsi-mq
      sg: fix read() error reporting

And the diffstat

 MAINTAINERS                     |  2 +-
 drivers/scsi/am53c974.c         |  6 ------
 drivers/scsi/be2iscsi/be_main.c |  1 -
 drivers/scsi/hpsa.c             |  4 +---
 drivers/scsi/sg.c               | 40 +++++++++++++++++++++++++++++++++-------
 drivers/scsi/wd719x.c           |  1 +
 6 files changed, 36 insertions(+), 18 deletions(-)

James


