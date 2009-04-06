From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Comparison of features sets between different SCSI
 	targets (SCST, STGT, IET, LIO)
Date: Mon, 06 Apr 2009 21:57:56 +0400
Message-ID: <49DA42A4.7060109@vlnb.net>
References: <49D7AD54.4060408@vlnb.net> <c9a3e4540904060319l3c885641k1217fba468f1fcf8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZDFR6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 13:58:00 -0400
In-Reply-To: <c9a3e4540904060319l3c885641k1217fba468f1fcf8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

ronnie sahlberg, on 04/06/2009 02:19 PM wrote:
> Why is AEN so important that it is worth 4 entries? SCST is the only 
> target where this is supported.

About the related functionality see http://lkml.org/lkml/2009/3/26/290

> Has AEN not been replaced with sense codes nowadays anyway?

AEN, particularly, is one of the ways to deliver those sense codes

> Support for Asynchronous Event Notifications (AEN) 	+ 	- 	- 	-

This is about the AEN infrastructure in the target's core

> AEN for devices added/removed 	+ 	- 	- 	-
> AEN for devices resized 	+ 	- 	- 	-

Those two are about ability to generate particular events

> 
> 
> 
> Support for Asynchronous Event Notifications (AEN) 	+ 	- 	- 	-

This is about support for AENs delivery by target driver.

> 
> 
> 
> 
> 
> On Sun, Apr 5, 2009 at 5:56 AM, Vladislav Bolkhovitin <vst@vlnb.net 
> <mailto:vst@vlnb.net>> wrote:
> 
>     Hi All,
> 
>     I set up http://scst.sourceforge.net/comparison.html page, which
>     compares features of existing SCSI target subsystems for Linux. The
>     comparison includes SCST, STGT, IET and LIO.
> 
>     I might be not fully correct somewhere, so, if you don't agree with
>     me about some item(s) in the comparison table, please let me know
>     and I will fix that.
> 
>     Vlad
>     --
>     To unsubscribe from this list: send the line "unsubscribe stgt" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

