From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Comparison of features sets between different SCSI
 	targets (SCST, STGT, IET, LIO)
Date: Mon, 06 Apr 2009 16:21:28 +0400
Message-ID: <49D9F3C8.9050700@vlnb.net>
References: <49D7AD54.4060408@vlnb.net>	 <c9a3e4540904052019o3c89128eq52d9046fef7e2725@mail.gmail.com>	 <49D9B017.4080807@vlnb.net> <c9a3e4540904060057w75b5525an9c63486ed00ca9a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZDFMV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 08:21:27 -0400
In-Reply-To: <c9a3e4540904060057w75b5525an9c63486ed00ca9a5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

ronnie sahlberg, on 04/06/2009 11:57 AM wrote:
> STGT supports  MMC (read and write) and SMC which makes it possible to 
> build a dvd burning jukebox.
> It also supports SSC and SMC which makes it possible to build a virtual 
> tape library.
> 
> MMC and SMC are fairly mature.
> SSC and SMC are reasonably mature and some people have succeeded in 
> running some network backup applications with robot control successfully.
> 
> 
> that brings up a point for STGT, we should really set up some "software 
> combatibility matrix" for device types and application software.
> 
> 
> For MMC I know that Nero and DVDdecrypted on windows works and  
> dcdrecord under linux works.

So, I'll add for STGT:

  - "Emulation of virtual tape and media changer"	"Experimental"

  - "Possibility to write to emulated CD-R devices" 	"+"

OK?

Thanks,
Vlad

> On Mon, Apr 6, 2009 at 6:32 PM, Vladislav Bolkhovitin <vst@vlnb.net 
> <mailto:vst@vlnb.net>> wrote:
> 
>     ronnie sahlberg, on 04/06/2009 07:19 AM wrote:
> 
>         Maybe you should also show which device types each
>         implementation can emulate.
> 
> 
>     OK. Seems I should add than STGT has additional emulation for SMC
>     and SSC devices as "Under development", correct?
> 
>         On Sun, Apr 5, 2009 at 5:56 AM, Vladislav Bolkhovitin
>         <vst@vlnb.net <mailto:vst@vlnb.net> <mailto:vst@vlnb.net
>         <mailto:vst@vlnb.net>>> wrote:
> 
>            Hi All,
> 
>            I set up http://scst.sourceforge.net/comparison.html page, which
>            compares features of existing SCSI target subsystems for
>         Linux. The
>            comparison includes SCST, STGT, IET and LIO.
> 
>            I might be not fully correct somewhere, so, if you don't
>         agree with
>            me about some item(s) in the comparison table, please let me know
>            and I will fix that.
> 
>            Vlad
>            --
>            To unsubscribe from this list: send the line "unsubscribe
>         stgt" in
>            the body of a message to majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>
>            <mailto:majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>>
> 
>            More majordomo info at
>          http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 

