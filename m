From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: 07 Feb 2003 14:39:46 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044628785.14350.9.camel@irongate.swansea.linux.org.uk>
References: <Pine.LNX.4.44.0302061519360.14478-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302061519360.14478-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Mark Haverkamp <markh@osdl.org>, Steven Cole <elenstev@mesatop.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, 2003-02-06 at 23:22, Linus Torvalds wrote:
> On 6 Feb 2003, David Woodhouse wrote:
> > 
> > Cut and paste from xterm should work fine. Cut and paste from
> > gnome-terminal, OTOH, will often corrupt it for you.
> 
> I think xterm does the same thing. I certainly refuse to use inferior 
> clones (I don't understand why people even _bother_ with things like 
> gnome-terminal, since it can't even do proper vt100 sequences), and I 
> definitely get tab->space conversion between two xterms.

gnome-terminal should be an exact copy of the xterm codes without the
tek graphics extensions. Roughly speaking thats vt220. If you know of
any it gets wrong please file a bug report.

It should also be preserving tabs (WORKKSFORME 8)). People with 
replicable cases where it doesn't should stick them in gnome bugzilla.
https://bugzilla.gnome.org. Konsole should also have the same properties
as xterm with regard to these features.

Alan


