From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Wed, 17 Oct 2007 00:01:51 +0200
Message-ID: <471534CF.6020609@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com> <200710151225.39624.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:20269 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936099AbXJPWFo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 18:05:44 -0400
Received: by ug-out-1314.google.com with SMTP id z38so172564ugc
        for <linux-scsi@vger.kernel.org>; Tue, 16 Oct 2007 15:05:43 -0700 (PDT)
In-Reply-To: <200710151225.39624.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Sunday 14 October 2007 18:47, Gabriel C wrote:
>>> Compile tested and applies cleanly to 2.6.23.
>>> I don't have this hardware anymore and cannot run test these patches.
>> I can test these patches on an aic7892 controller later on today if you want.
> 
> I'd appreciate that.
> 
> Do you, by any chance, use aic94xx driver too (drivers/scsi/aic94xx/*)?
> After i'm done with aic7xxx, I may attack this one.

Sorry I don't have any box uses this one , but I'll ask some friends maybe someone has :)

> 
>> BTW while you seems to care about this driver could you have a look at :
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=3062 ?!?
> 
> I am a desktop Linux user, so far I don't use suspend at all. Sorry.

Ok , no problem maybe one 'day' the SCSI folks cares ( where the 'day' may be never ),  I dunno :(
  
> --
> vda
> 

Gabriel
