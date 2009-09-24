From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Thu, 24 Sep 2009 14:49:22 -0500
Message-ID: <4ABBCD42.8050604@cs.wisc.edu>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55675 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbZIXTt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:29 -0400
In-Reply-To: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: mdr@sgi.com, James Bottomley <James.Bottomley@HansenPartnership.com>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, vasu.dev@intel.com

Giridhar Malavali wrote:
> Hi Michael/James,
> 
>     Patches were submitted to move queue ramp up/down code recently to 
> scsi mid layer. With this change, I don't see a need for a module 
> parameter to disable queuefull tracking  in qla2xxx driver. Andrew, 
> mentioned that this got introduced to avoid wobbling behavior on the 
> wire due to queue depth modifications. Just wanted to check whether the 
> same need to be done in scsi mid layer too.
> 

I think so. I believe Michael Reed had a valid reason for it, and I do 
not see why we would not hit a similar problem with other drivers.
