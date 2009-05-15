From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: RE: [RFQ] New driver architecture questions
Date: Fri, 15 May 2009 12:38:40 -0600
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A96C787D@cosmail02.lsi.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
 <4A0B858F.3080405@garzik.org>
 <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
 <4A0B9B0D.6080006@garzik.org>
 <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
 <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
 <4A0CDB27.6090009@garzik.org>
 <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
 <20090515163626.GA15360@parisc-linux.org>
 <6C678488C5CEE74F813A4D1948FD2DC7A96C7848@cosmail02.lsi.com>
 <20090515181641.GB15360@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:43523 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZEOSju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 14:39:50 -0400
In-Reply-To: <20090515181641.GB15360@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, Julian Calaby <julian.calaby@gmail.com>, adam radford <aradford@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

 
> > > Using one or the other internally is fine (we don't care what you do),
> > > but we want to see memcpy().  By the way, the documentation I found
> for
> > > ScsiPortMoveMemory() seems to indicate that it's memmove(), not
> memcpy().
> > > Mapping memcpy() to ScsiPortMoveMemory() is fine ... but you can't
> > > realiably go the other way.
> > [Atul] It's actually memcpy(),http://msdn.microsoft.com/en-
> us/library/ms805434.aspx
> 
> No, it's memmove().  "The (ReadBuffer + Length) can overlap the area
> pointed to by WriteBuffer."
[Atul] Look, you are already figuring out possible issues with the source code without it being out yet :-).

Thanks everyone for your inputs so far!

Atul
