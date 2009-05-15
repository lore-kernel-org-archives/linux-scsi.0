From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFQ] New driver architecture questions
Date: Fri, 15 May 2009 10:36:27 -0600
Message-ID: <20090515163626.GA15360@parisc-linux.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com> <4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com> <4A0B9B0D.6080006@garzik.org> <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com> <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com> <4A0CDB27.6090009@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763502AbZEOQgw@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Jeff Garzik <jeff@garzik.org>, Julian Calaby <julian.calaby@gmail.com>, adam radford <aradford@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 15, 2009 at 08:56:25AM -0600, Mukker, Atul wrote:
> [Atul] I think we are close, for example, memcpy API in the stack is osi_memcpy(), which translates to memcpy() on Linux and ScsiPortMoveMemory() on windows.

The solution to "We have some people who speak French and other people who
speak German" is not to invent Esperanto ;-)

Using one or the other internally is fine (we don't care what you do),
but we want to see memcpy().  By the way, the documentation I found for
ScsiPortMoveMemory() seems to indicate that it's memmove(), not memcpy().
Mapping memcpy() to ScsiPortMoveMemory() is fine ... but you can't
realiably go the other way.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
