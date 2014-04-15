From: Christoph Hellwig <hch@lst.de>
Subject: scsi fixes for 3.15-rc2
Date: Tue, 15 Apr 2014 12:24:54 +0200
Message-ID: <1397557496-21194-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaDOKWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2014 06:22:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Two simple fixes for use after free conditions in prep_fn error handling.

