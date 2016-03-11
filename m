From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 00/11] SCSI smpboot thread conversion
Date: Fri, 11 Mar 2016 16:28:52 +0100
Message-ID: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37892 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbcCKP3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de

This series converts fcoe, bnx2i and bnx2fc to smpboot thread instead
of their own magic. The fcoe driver ended in more patches than I wanted
but that way it is easier to find the individual code blocks which were
used in the final patch.

The overall diffstat:
  8 files changed, 253 insertions(+), 478 deletions(-)

Sebastian

