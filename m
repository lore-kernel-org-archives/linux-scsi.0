From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/8] scsi: stop passing a gfp_mask argument down the command
 setup path
Date: Wed, 01 Oct 2014 14:28:58 +0200
Message-ID: <542BF38A.9040509@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:42046 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJAM3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:29:06 -0400
In-Reply-To: <1410107469-896-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> There is no reason for ULDs to pass in a flag on how to allocate the S/G
> lists.  While we don't need GFP_ATOMIC for the blk-mq case because we
> don't hold locks, that decision can be made way down the chain without
> having to pass a pointless gfp_mask argument.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

