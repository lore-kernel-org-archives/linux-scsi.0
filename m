From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Mon, 27 Mar 2006 16:29:13 -0500
Message-ID: <44285929.4020806@torque.net>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>	 <Pine.LNX.4.64.0603261424590.15714@g5.osdl.org>	 <4427FEC9.4010803@torque.net>	 <Pine.LNX.4.64.0603270854570.15714@g5.osdl.org>	 <20060327172530.GH3486@parisc-linux.org>	 <Pine.LNX.4.64.0603270936290.15714@g5.osdl.org> <1143489287.4970.76.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:35974 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1751461AbWC0VbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 16:31:16 -0500
In-Reply-To: <1143489287.4970.76.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@osdl.org>, Matthew Wilcox <matthew@wil.cx>, Bodo Eggert <7eggert@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Llu, 2006-03-27 at 09:43 -0800, Linus Torvalds wrote:
> 
>>The fact is, BUS/ID/LUN crap really doesn't make sense for the majority of 
>>devices out there. Never has, never will. The fact that old-fashioned SCSI 
>>devices think of themselves that way has absolutely zero to do with 
>>reality today.
> 
> 
> It is still a very visible reality if you work in a data centre or with
> server kit, or if you have tape arrays or multi-CD towers. The LUN or
> device number in particular are generally the number emblazoned on each
> slot in the unit and knowing the LUN reliably is sort of critical to not
> making embarrasing (and career limiting) screwups when swapping drives.
> 
> Controller is a pretty abstract concept and except on arrays so is
> device, but both device and LUN do need to be accessible reliably for
> the hardware that thinks that way. What other hardware does is
> irrelevant and "-EINVAL" seems as good an answer as anything.

USB multi-card readers seem to like the concept of
LUNs as well.

Doug Gilbert
"What, never? Well, hardly ever." G+S HMS Pinafore
