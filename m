From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic boolean-values
Date: Tue, 08 May 2007 06:13:16 +0200
Message-ID: <463FF8DC.1070103@student.ltu.se>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>	<1178567419.3729.44.camel@mulgrave.il.steeleye.com>	<20070507140656.3debfb55.akpm@linux-foundation.org> <20070507141107.e9c87d8c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:47905 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967731AbXEHEPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 00:15:53 -0400
In-Reply-To: <20070507141107.e9c87d8c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Mon, 7 May 2007 14:06:56 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> so I'll drop it on those grounds, not on the bogus ones.
>>     
>
> However it will come back again.  All subsystem-private implementations
> of TRUE and FALSE are in the firing line now.
>   
Amen.
But should we let it rest until most of the other (boolean) conversions 
are done (as with CIFS and XFS (iirc)), otherwise I can take a new stab 
at it this weekend.

Btw Andrew, do you want me to Cc: you all the patches or should I 
continue to first send them to (hopefully the correct) maintainer(s)/ML, 
and send them your way if they are not picked up (is one week enough, or 
should it be longer?)

Regards
Richard Knutsson

