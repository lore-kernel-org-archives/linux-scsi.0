From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: misc scsi midlayer updates
Date: Mon, 31 Mar 2014 16:55:53 -0500
Message-ID: <5339E469.60004@cs.wisc.edu>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58051 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaCaV4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 17:56:06 -0400
In-Reply-To: <1395936862-6938-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On 03/27/2014 11:14 AM, Christoph Hellwig wrote:
> Various patches from the scsi multiqueue development that make sense on their
> own.


With the updated patch "[PATCH 3/4 v2] scsi: reintroduce
scsi_driver.init_command", they look ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
