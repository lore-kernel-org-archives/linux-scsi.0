From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 3/5] qla2xxx: Add multiple queue pair functionality.
Date: Tue, 13 Dec 2016 04:15:28 -0800
Message-ID: <20161213121528.GB16734@infradead.org>
References: <1481582409-22027-1-git-send-email-himanshu.madhani@cavium.com>
 <1481582409-22027-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45889 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932577AbcLMMP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 07:15:29 -0500
Content-Disposition: inline
In-Reply-To: <1481582409-22027-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Mon, Dec 12, 2016 at 02:40:07PM -0800, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Replaced existing multiple queue functionality with framework
> that allows for the creation of pairs of request and response queues,
> either at start of day or dynamically.
> 
> Queue pair creation depend on module parameter "ql2xmqsupport",
> which need to be enabled to create queue pair.
> 
> Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
> Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>

Not happy with all the details, but I guess this is ok for now:

Acked-by: Christoph Hellwig <hch@lst.de>
