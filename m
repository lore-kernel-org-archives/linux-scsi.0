From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: 19 Nov 2002 00:32:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1037665959.9625.0.camel@irongate.swansea.linux.org.uk>
References: <20021118235221.637162C456@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20021118235221.637162C456@lists.samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexander Viro <viro@math.psu.edu>, Doug Ledford <dledford@redhat.com>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2002-11-18 at 23:49, Rusty Russell wrote:
> In message <Pine.GSO.4.21.0211180403440.23400-100000@steklov.math.psu.edu> you 
> write:
> > Not really.  For case in question (block devices) there is only one path
> > and I'd rather keep it that way, thank you very much.
> 
> See other posting.  This is a fundamental design decision, and it's
> not changing.  Sorry.

So is the block layer one, and it was fundamentally designed first 8)
