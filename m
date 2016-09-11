From: Christoph Hellwig <hch@lst.de>
Subject: consolidate T10 PI defintions
Date: Sun, 11 Sep 2016 19:35:38 +0200
Message-ID: <1473615341-27203-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756131AbcIKRfp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:35:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Hi Martin,

this series ensures scsi_debug and qla2xxx use the common t10_pi_tuple
defintion, and then also moves the remaining T10 PI related defintions
to <linux/t10-pi.h>.

