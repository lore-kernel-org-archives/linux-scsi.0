From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 08 Jun 2006 07:37:14 -0400
Message-ID: <44880BEA.90707@garzik.org>
References: <20060603112113.GA17018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56255 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964788AbWFHLhS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 07:37:18 -0400
In-Reply-To: <20060603112113.GA17018@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Various scsi drivers use scsi_cmnd.buffer and scsi_cmnd.bufflen in their
> queuecommand functions.  Those fields are internal storage for the
> midlayer only and are used to restore the original payload after
> request_buffer and request_bufflen have been overwritten for EH.  Using
> the buffer and bufflen fields means they do very broken things in error
> handling.

False statement, for libata.

Please CC the author (me) or linux-ide, at least, when you touch libata.

	Jeff



