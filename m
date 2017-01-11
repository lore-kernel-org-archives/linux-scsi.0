From: Christoph Hellwig <hch@lst.de>
Subject: two fixes for the qla2xxx MSI-X changes in 4.10-rc
Date: Wed, 11 Jan 2017 17:55:44 +0100
Message-ID: <1484153746-19406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35108 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbdAKQzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 11:55:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: linux-scsi@vger.kernel.org

Hi Himanshu,

two small updates to to a) fix the way affinity is assigned for qla2xxx,
and b) remove the dead interrupt affinity notifiers.

