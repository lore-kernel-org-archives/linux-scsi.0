From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/4] scsi: never drop to untagged mode during queue ramp
 down
Date: Fri, 28 Nov 2014 10:59:53 +0100
Message-ID: <54784799.80704@acm.org>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:53948 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaK1KQM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 05:16:12 -0500
In-Reply-To: <1416839781-26988-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/14 15:36, Christoph Hellwig wrote:
> Dropping to untagged mode when ramping down a queue due to QUEUE FULL
> events has two problems:
>
>   - nothing in the midlayer or drivers ever moves back to tagged mode
>     during queue ramp up.
>   - cmd_per_lun isn't the untagged queue depth for many modern drivers
>     that can handle multiple untagged commands, and this is the only
>     place in the midlayer assuming that.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

