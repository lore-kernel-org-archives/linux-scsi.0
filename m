From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 5/6] qla2xxx: Add Block Multi Queue functionality.
Date: Fri, 9 Dec 2016 05:10:28 -0800
Message-ID: <20161209131028.GB15254@infradead.org>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-6-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45808 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751953AbcLINKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 08:10:30 -0500
Content-Disposition: inline
In-Reply-To: <1481051266-32362-6-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

This also need to write up the ->map_queues callback so that the MSI-X
assignment is preserved.
