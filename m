From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: device handler cleanups V2
Date: Mon, 10 Nov 2014 12:07:37 -0600
Message-ID: <5460FEE9.6000406@cs.wisc.edu>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50428 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaKJSHt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 13:07:49 -0500
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

On 10/30/2014 04:19 AM, Christoph Hellwig wrote:
> This series contains a couple easy cleanups for the device handler
> infrastructure.  I think some more work could be done in the longer run,
> e.g. by using a class_device interface to attach to the scsi_device,
> similar to how the /dev/sg devices work.
> 
> Changes since V1:
>  - fix ->attach for rdac, pointed out by Mike Christie
> 

Look ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
