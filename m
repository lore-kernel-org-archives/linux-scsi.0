From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: split ->change_queue_depth
Date: Sun, 23 Nov 2014 23:51:55 -0600
Message-ID: <5472C77B.1020401@cs.wisc.edu>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47108 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaKXFwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 00:52:08 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/13/14, 11:58 AM, Christoph Hellwig wrote:
> Overloading ->change_queue_depth with the queue ramp up / down
> functionality has been a bad idea.   It lead to a large amount
> of code duplication, and driver keep getting the the API
> wrong and end up accidentally enabling the queue depth tracking
> while getting it wrong.
>
> This serie instead adds a flag to enable queue tracking and
> handles it entirely in core code.  This is a preparation for
> various logic changes to the queue depth tracking code.
>

Looks nice to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
