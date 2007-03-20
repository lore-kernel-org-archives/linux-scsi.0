From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPT Fusion LSI22320 ,  Domain validation loops .
Date: Mon, 19 Mar 2007 20:16:18 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70650FD9@NAMAIL4.ad.lsil.com>
References: <Pine.LNX.4.64.0703171302440.18291@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50792 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965711AbXCTCQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 22:16:33 -0400
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.64.0703171302440.18291@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Saturday, March 17, 2007 2:33 PM,  James W. Laferriere wrote:
>  	Hello All ,  I am have been having this problem since I 
> purchased the 
> controller and after changing out the disks I thought were 
> the problem .
>  	I am still getting the continous :
> 
> mptscsih: ioc1: attempting task abort! (sc=f7a64500)
> scsi 3:0:4:0:
>          command: Inquiry: 12 00 00 00 60 00
> mptbase: Initiating ioc1 recovery
> mptscsih: ioc1: task abort: SUCCESS (sc=f7a64500)
>   target3:0:4: Domain Validation detected failure, dropping back
>   target3:0:4: Domain Validation skipping write tests
>   target3:0:4: Ending Domain Validation
>   target3:0:4: asynchronous
>   target3:0:5: Beginning Domain Validation
> mptscsih: ioc0: attempting target reset! (sc=f7a64380)
> 
>  	The acutual device id's change and the driver 
> continously resets the 
> busses & starts all over .
> 
>  	The disks are in a HP DS-SL13R-BA 4354R 14drive ultra3 
> racKmount cabinet 
> w/ dualbus & dualps ,  Which seems to present a ID6 ,  That 
> does not show up in 
> any of the bus scans .
> 
>  	Now I have previously had the same cabinet with 18gb 
> disks which had the 
> same problem with this controller .  BUT I also have a LSI 
> Logic / Symbios 
> Logic 53c1010 66MHz Ultra3 dual SCSI bus Adapter which works 
> flawlessly with the 
> 18gb disks in this very same cabinet .
>  	The cables for connecting the adapter(s) to tha cabinet 
> are less than 24 
> inches in length .
> 
>  	Would anyone please shed some light on what it is I am 
> doing wrong or 
> need to do or ....?  Too have this controller recognise these 
> disk drives in 
> this cabinet .

There is a seperate mailing list for scsi releated issues, e.g.
linux-scsi@.   I've posted a patch to address your issue several times,
however it seems its not been picked up by the scsi subsystem
maintainer.   The last time it was posted was here:
http://marc.info/?l=linux-scsi&m=117089244809072&w=2   An alternative is
you could obtain our latest drivers from the LSI download site, where
these drivers should have this patch
http://www.lsilogic.com/cm/DownloadSearch.do.

Eric


