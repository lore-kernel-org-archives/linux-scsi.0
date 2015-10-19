From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: restart list search after unlock in
 scsi_remove_target
Date: Mon, 19 Oct 2015 08:36:23 -0700
Message-ID: <56250DF7.6050803@sandisk.com>
References: <20151019143546.GA7486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0070.outbound.protection.outlook.com ([157.56.110.70]:32124
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754288AbbJSPg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 11:36:29 -0400
In-Reply-To: <20151019143546.GA7486@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: jthumshirn@suse.de

On 10/19/2015 07:35 AM, Christoph Hellwig wrote:
> When dropping a lock while iterating a list we must restart the search
> as other threads could have manipulated the list under us.  Without this
> we can get stuck in an endless loop.

Hello Christoph,

Thanks for looking into this. However, I think we need a motivation in 
the patch description why this patch does not reintroduce the soft 
lockup documented in patch "scsi_remove_target: fix softlockup 
regression on hot remove" (commit bc3f02a795d3).

Thanks,

Bart.
