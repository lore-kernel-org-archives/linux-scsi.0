From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFQ] New driver architecture questions
Date: Fri, 15 May 2009 12:16:41 -0600
Message-ID: <20090515181641.GB15360@parisc-linux.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com> <4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com> <4A0B9B0D.6080006@garzik.org> <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com> <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com> <4A0CDB27.6090009@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com> <20090515163626.GA15360@parisc-linux.org> <6C678488C5CEE74F813A4D1948FD2DC7A96C7848@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52044 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZEOSQk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 14:16:40 -0400
Content-Disposition: inline
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A96C7848@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Jeff Garzik <jeff@garzik.org>, Julian Calaby <julian.calaby@gmail.com>, adam radford <aradford@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 15, 2009 at 12:03:39PM -0600, Mukker, Atul wrote:
> > The solution to "We have some people who speak French and other people who
> > speak German" is not to invent Esperanto ;-)
> [Atul] We really wish they could communicate in English :-), since that's not an option, we agree in principle that using native Linux Kernel APIs wherever possible is probably a good idea.

I'd stick to the C APIs where possible ... oh, that's what Linux does.  OK ;-)

> > Using one or the other internally is fine (we don't care what you do),
> > but we want to see memcpy().  By the way, the documentation I found for
> > ScsiPortMoveMemory() seems to indicate that it's memmove(), not memcpy().
> > Mapping memcpy() to ScsiPortMoveMemory() is fine ... but you can't
> > realiably go the other way.
> [Atul] It's actually memcpy(),http://msdn.microsoft.com/en-us/library/ms805434.aspx

No, it's memmove().  "The (ReadBuffer + Length) can overlap the area
pointed to by WriteBuffer."

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
