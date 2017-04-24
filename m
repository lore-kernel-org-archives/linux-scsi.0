From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 3/9] sd: Remove unecessary variable in sd_done()
Date: Mon, 24 Apr 2017 09:25:09 +0900
Message-ID: <9b3d760d-b8c4-f9f4-a59d-5dcd6ba91cb5@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-4-damien.lemoal@wdc.com>
 <1492800162.7079.33.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48361 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163676AbdDXAZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 20:25:17 -0400
In-Reply-To: <1492800162.7079.33.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

James,

On 4/22/17 03:42, James Bottomley wrote:
> Really, no, you're making the code less clear for no gain.  I'm fairly
> certain the compiler can optimise this without any help and when you're
> skimming the code you can easily see that the out jump is taken if you
> have a sense code that's either invalid or deferred.  After your change
> you have to glance one level deeper to come to the same conclusion.
> 
> To be clear: I wouldn't object if the original function were written
> the way you propose because we all get used to scanning code looking
> for things like this.  However, a patch to change existing code fails
> the net benefit test.

OK. Let's drop this patch then.
Thank you for the review.

-- 
Damien Le Moal,
Western Digital
