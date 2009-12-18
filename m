From: Matt Tehonica <matt.tehonica@mac.com>
Subject: Re: Applying MVSAS Patch
Date: Fri, 18 Dec 2009 09:26:59 -0500
Message-ID: <4D393076-4B36-49EC-AA69-ED0E52298943@mac.com>
References: <67980649284293627495293095942659870934-Webmail@me.com>
 <20091216081301.59d1698e.randy.dunlap@oracle.com>
 <93017718277361587250366956065608636194-Webmail@me.com>
 <20091216090430.66b7f389.randy.dunlap@oracle.com>
 <29479280-86A1-4DF5-BA64-F2F0F1A4838B@mac.com>
 <20091216101617.a6499cad.randy.dunlap@oracle.com>
 <105495033028979535461096937726809251647-Webmail@me.com>
 <alpine.DEB.1.10.0912181519510.23464@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asmtpout027.mac.com ([17.148.16.102]:55953 "EHLO
	asmtpout027.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZLRO1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 09:27:12 -0500
Received: from [192.168.1.6]
 (cpe-74-71-154-226.twcny.res.rr.com [74.71.154.226])
 by asmtp027.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTPSA id <0KUU003TKQSZ1R40@asmtp027.mac.com> for
 linux-scsi@vger.kernel.org; Fri, 18 Dec 2009 06:27:01 -0800 (PST)
In-reply-to: <alpine.DEB.1.10.0912181519510.23464@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-scsi@vger.kernel.org, ayan@marvell.com


On Dec 18, 2009, at 9:21 AM, Mikael Abrahamsson wrote:

> On Fri, 18 Dec 2009, Matthew Tehonica wrote:
>
>> Anyone have any ideas on this??  It compiled fine until I applied  
>> those 7 patches.
>
> http://www.spinics.net/lists/linux-ide/msg35614.html
>
> Just remove the last option and it'll compile. The resulting kernel  
> doesn't work well for me anyway, instead of oops:ing and working  
> badly, I just get kernel freeze.
>
> -- 
> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Should these mvsas patches be applied against 2.6.32 or 2.6.31?
