From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/9] mpt fusion: error recovery improvements,andsynchronizing
 internal commands
Date: Tue, 25 Sep 2007 14:37:58 -0400
Message-ID: <46F95586.2020504@garzik.org>
References: <664A4EBB07F29743873A87CF62C26D709D940E@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48459 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbXIYSiD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 14:38:03 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D709D940E@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Tuesday, September 25, 2007 11:32 AM,  James Bottomley  wrote:
>  
>>> Youve rejected the error recovery patchs, which is fair enough.  
>> Just the separation ... the actual patch looks OK.
>>
> 
> I'll will continue working to separate the "error recovery
> improvements:" into smaller feature add, but will take some time.   I
> want some constructive feedback, and too big of patch is deterring some
> people from looking at it.

I think it's fair to break it up, as long as its clearly noted that the 
patch is for review only.

	Jeff



