From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/6] scsi: refactor scsi_reset_provider handling
Date: Tue, 28 Oct 2014 18:36:07 +0100
Message-ID: <20141028173607.GA22593@lst.de>
References: <1414432746-12888-1-git-send-email-hch@lst.de> <1414432746-12888-2-git-send-email-hch@lst.de> <544F5900.6080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37826 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaJ1RgL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2014 13:36:11 -0400
Content-Disposition: inline
In-Reply-To: <544F5900.6080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On Tue, Oct 28, 2014 at 09:51:12AM +0100, Bart Van Assche wrote:
> This function returns 0 even if an action like SG_SCSI_RESET_BUS fails (rtn 
> != SUCCESS) with the flag SCSI_TRY_RESET_NO_ESCALATE set. I think the 
> current behavior is to return -EIO in that case. If this change was 
> intended, please mention it in the patch description.

I will fix this up for the next version, thanks for catching it!

