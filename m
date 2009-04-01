From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] SCSI resends for merge
Date: Wed, 01 Apr 2009 15:00:09 +0100
Message-ID: <20090401135952.22599.26719.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46141 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbZDAN7B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 09:59:01 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by www.etchedpixels.co.uk (8.14.3/8.14.3) with ESMTP id n31E09Pc022633
	for <linux-scsi@vger.kernel.org>; Wed, 1 Apr 2009 15:00:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

---

Alan Cox (2):
      mptsas: remove unneeded check
      config: Make need for SCSI_CDROM clearer


 drivers/message/fusion/mptsas.c |    5 ++---
 drivers/scsi/Kconfig            |    9 +++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

-- 
