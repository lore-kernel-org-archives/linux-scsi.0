From: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Subject: Re: [PATCH] for Deadlock in transport_fc
Date: Thu, 09 Jun 2005 16:11:41 +0200
Message-ID: <42A84E1D.5060607@fujitsu-siemens.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC67@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:406 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S262404AbVFIOLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 10:11:44 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC67@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

James.Smart@Emulex.Com wrote:
> 
>>BTW: at least once when we disconnected one target and 
>>connected the other
>>without waiting for nodev_tmo, we saw the situation, that the 
>>new target was
>>accessible, while sysfs still showed us the old wwpn.
> 
> 
> We ought to track this further offline. There's more detail I'd like to
> get from you to ensure there isn't an error here.
> 
We'll try to reproduce this. If we succeed, we will let you know the
recipe.

	Bodo
