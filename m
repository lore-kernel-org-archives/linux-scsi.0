From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Wed, 7 Dec 2016 11:05:02 -0800
Message-ID: <20161207190502.GB29031@infradead.org>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932209AbcLGTFE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 14:05:04 -0500
Content-Disposition: inline
In-Reply-To: <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 11:07:44AM -0800, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Replaced existing multiple queue functionality with framework
> that allows for the creation of pairs of request and response queues,
> either at start of day or dynamically.
> 
> Queue pair creation depend on module parameter "ql2xmqsupport",
> which need to be enabled to create queue pair.

This doesn't seem to address any of the feedback from the last
round of feedback, was is sent out before that?
