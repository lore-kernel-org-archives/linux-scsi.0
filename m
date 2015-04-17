From: Torsten Luettgert <ml-lkml@enda.eu>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
 746650160
Date: Fri, 17 Apr 2015 15:31:16 +0200
Message-ID: <20150417153116.5f97e007@goldlack.schiller106>
References: <20150408183333.493607a3@goldlack.schiller106>
	<20150413174105.GA14988@lst.de>
	<20150413202829.580e3801@goldlack.schiller106>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150413202829.580e3801@goldlack.schiller106>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 13 Apr 2015 20:28:29 +0200
Torsten Luettgert <ml-lkml@enda.eu> wrote:

> On Mon, 13 Apr 2015 19:41:05 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Can you run gdb on your vmlinux file and send the output of the
> > following command in gdb
> > 
> > l *(scsi_dma_unmap+0x54)
> 
> Thanks for looking into it! Here is what gdb says: [...]

Hello Christoph,

do you think it could be a compiler problem? I still can't imagine why
only 2 people have seen this (at least it wasn't just me), but it
_always_ hits with newer kernels on that node.

Right now, I'm trying the problematic release, compiled with a newer
gcc (4.9.2-6 from Fedora, while using 4.4.7-11 from rhel6
before). It has only been running a few hours yet, so I can't tell if
it's good.

Regards,
Torsten
