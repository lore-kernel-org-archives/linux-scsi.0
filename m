From: "c.hota" <cghota@mail.midsouth.ualr.edu>
Subject: Re: Problem on Dell PE2650/aacraid {almost there, i think!}
Date: Mon, 02 Aug 2004 10:56:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410E642A.30509@midsouth.ualr.edu>
References: <410E4802.1090707@midsouth.ualr.edu>
Reply-To: cghota@mail.midsouth.ualr.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ualr.edu ([144.167.10.21]:12525 "EHLO mail.ualr.edu")
	by vger.kernel.org with ESMTP id S266599AbUHBQ1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2004 12:27:04 -0400
Received: from mfilter1.ualr.edu (mfilter.ualr.edu [144.167.10.248])
 by mail.ualr.edu (iPlanet Messaging Server 5.2 Patch 1 (built Aug 19 2002))
 with ESMTP id <0I1T0037GUVTI8@mail.ualr.edu> for linux-scsi@vger.kernel.org;
 Mon, 02 Aug 2004 11:24:40 -0500 (CDT)
Received: from [144.167.14.19] (helo=mail.midsouth.ualr.edu)
	by mfilter1.ualr.edu with esmtp (Exim 4.34)
	id 1BrfAO-0008VM-Bt	for linux-scsi@vger.kernel.org; Mon,
 02 Aug 2004 10:56:00 -0500
Received: from [144.167.14.88] by mail.midsouth.ualr.edu
 (iPlanet Messaging Server 5.2 HotFix 1.21 (built Sep  8 2003))
 with ESMTP id <0I1T00AM3T8Q2P@mail.midsouth.ualr.edu> for
 linux-scsi@vger.kernel.org; Mon, 02 Aug 2004 10:48:26 -0500 (CDT)
In-reply-to: <410E4802.1090707@midsouth.ualr.edu>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

OK!

Received updated driver from Mark Salyzyn, and I no longer get the error 
message below.

Instead, I get a kernel panic because it doesn't know where the root 
filesystem is.  With the gentoo livecd, it is /dev/sda4.  So I guess my 
question is, with the aacraid driver, what is my raid mounted as? 
/dev/raida or something?

Thanks,

chris.

c.hota wrote:

> Hi all-
>
> Just built a (gentoo 2004.2) 2.4.27 kernel on a Dell PowerEdge 2650 
> (with PERC 3/di) using aacraid.  Upon boot, I'm getting the following 
> message:
>
> Loading Adaptec I20 RAID: Version 2.4 Build 5
> Detecting Adaptec I20 RAID controllers...
> Re Hat/Adaptec aacraid driver (1.1-3 Jul 31 2004 19:50:19)
> AAC0: kernel 2.7.4 build 3170
> AAC0: monitor 2.7.4 build 3170
> AAC0: bios 2.7.4 build 3170
> AAC0: serial 7bd881d3fafaf001
> scsi0: percraid
>
> And then the system just stops...
>
> I'm pretty new to all this, so I'm not sure what to do.  Any ideas?  I 
> looked through the linux-aacraid-devl list archives, and couldn't find 
> anyone with the same problem; and it said to go to this list.
>
> Thanks,
>
> Chris
>
> ---
>
> Chris Hota
> cghota@midsouth.ualr.edu
> (501)683-7339 desk
> (501)413-1176 cell
> http://www.midsouth.ualr.edu/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Chris Hota
cghota@midsouth.ualr.edu
(501)683-7339 desk
(501)413-1176 cell
http://www.midsouth.ualr.edu/ 

