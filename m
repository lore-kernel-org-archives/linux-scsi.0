From: Joe <joecool1029@gmail.com>
Subject: Re: Empty partition nodes not created (was device node issues with recent mm's and udev)
Date: Tue, 3 May 2005 19:34:24 -0400
Message-ID: <d4757e60050503163472dacf5a@mail.gmail.com>
References: <d4757e6005050219514ece0c0a@mail.gmail.com>
	 <20050503031421.GA528@kroah.com>
	 <20050502202620.04467bbd.rddunlap@osdl.org>
	 <427758BC.1090906@grupopie.com>
Reply-To: Joe <joecool1029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.193]:25315 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261920AbVECXe1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2005 19:34:27 -0400
Received: by rproxy.gmail.com with SMTP id a41so61590rng
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2005 16:34:27 -0700 (PDT)
In-Reply-To: <427758BC.1090906@grupopie.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paulo Marques <pmarques@grupopie.com>, "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>

On 5/3/05, Paulo Marques <pmarques@grupopie.com> wrote:
> Randy.Dunlap wrote:
> > Could this 2.6.11.8 -stable patch fix it?
> > Subject: [04/07] partitions/msdos.c fix
> >
> > Joe, can you test 2.6.11.8, please?
> 
> It seems to me that this exactly the other way around. The patch is
> probably already in -mm and is doing what it is supposed to do: don't
> report partitions whose system ID == 0.
> 
> Can you try to give the empty partition a type different than zero? You
> don't need to make a file system on it or anything, just change the type.
> 
> Or check if the patch Randy is pointing to is already in your tree and
> revert it.
> 
> I think this is a good argument not to include this patch on the -stable
> release...
> 
> --
> Paulo Marques - www.grupopie.com
> 
> All that is necessary for the triumph of evil is that good men do nothing.
> Edmund Burke (1729 - 1797)
> 

You would be correct.. that patch is already in MM.. so this issue
continues, more input necessary.

Joe
