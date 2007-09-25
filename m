From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 6/9] mpt fusion: error recovery improvements,andsynchronizing
 internal commands
Date: Tue, 25 Sep 2007 17:38:19 -0500
Message-ID: <46F98DDB.8070407@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D709D940E@NAMAIL4.ad.lsil.com> <46F95586.2020504@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59708 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305AbXIYWiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 18:38:22 -0400
In-Reply-To: <46F95586.2020504@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


Jeff Garzik wrote:
> Moore, Eric wrote:
>> On Tuesday, September 25, 2007 11:32 AM,  James Bottomley  wrote:
>>  
>>>> Youve rejected the error recovery patchs, which is fair enough.  
>>> Just the separation ... the actual patch looks OK.
>>>
>>
>> I'll will continue working to separate the "error recovery
>> improvements:" into smaller feature add, but will take some time.   I
>> want some constructive feedback, and too big of patch is deterring some
>> people from looking at it.
> 
> I think it's fair to break it up, as long as its clearly noted that the
> patch is for review only.

Any chance the changes, properly documented, could be accepted as
one big patch?  Breaking this code into smaller patches, when it's
really intended as a driver update, could prove problematic.

Mike


> 
>     Jeff
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
