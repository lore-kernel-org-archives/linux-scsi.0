From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] kill scsi_assign_lock
Date: Sat, 04 Nov 2006 22:59:17 -0500
Message-ID: <454D6195.2070704@garzik.org>
References: <20061104191136.GC23477@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:5314 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965827AbWKED7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 22:59:20 -0500
In-Reply-To: <20061104191136.GC23477@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> scsi_assign_lock has been unused for a long time and is a bad idea
> in general, so kill it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

ACK


