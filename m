From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFT][PATCH] aic79xx: remove busyq
Date: Mon, 30 May 2005 18:26:25 -0400
Message-ID: <429B9311.9000608@pobox.com>
References: <20050529074620.GA26151@havoc.gtf.org> <1117488507l.7621l.0l@werewolf.able.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:19692 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261786AbVE3W0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 18:26:34 -0400
In-Reply-To: <1117488507l.7621l.0l@werewolf.able.es>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "J.A. Magallon" <jamagallon@able.es>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

J.A. Magallon wrote:
> On 05.29, Jeff Garzik wrote:
> 
>>Can anyone with aic79xx hardware give me a simple "it works"
>>or "this breaks things" answer, for the patch below?
>>
>>This changes the aic79xx driver to use the standard Linux SCSI queueing
>>code, rather than its own.  After applying this patch, NO behavior
>>changes should be seen.
>>
>>The patch is against 2.6.12-rc5, but probably applies OK to recent 2.6.x
>>kernels.
>>
> 
> 
> Applied with even no offsets to -rc5-mm1. Booted and working fine:

Thanks a bunch!

	Jeff



