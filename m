From: Christoph Hellwig <hch@lst.de>
Subject: remove old and unmaintained ISA driver
Date: Mon, 19 Sep 2016 08:50:46 -0700
Message-ID: <1474300253-31351-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40304 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbcISPu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:50:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: schmitzmic@gmail.com, linux@rainbow-software.org, fthain@telegraphics.com.au

Per discussion in last year and last week there are a few old ISA SCSI
drivers that haven't seen any work since the dawn of git, and most likely
no users.  Drop them to speed up killing off the scsi_module.c
infrastruture.

