From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] libiscsi: fix potential buffer overrun in
 __iscsi_conn_send_pdu
Date: Fri, 5 Sep 2014 17:36:54 -0700
Message-ID: <20140906003654.GA23694@infradead.org>
References: <1409720439-6226-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIFAgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:36:55 -0400
Content-Disposition: inline
In-Reply-To: <1409720439-6226-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:00:39AM -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patches fixes a potential buffer overrun in __iscsi_conn_send_pdu.
> This function is used by iscsi drivers and userspace to send iscsi PDUs/
> commands. For login commands, we have a set buffer size. For all other
> commands we do not support data buffers.
> 
> This was reported by Dan Carpenter here:
> http://www.spinics.net/lists/linux-scsi/msg66838.html
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
