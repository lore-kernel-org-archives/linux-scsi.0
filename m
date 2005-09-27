From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Possible bug in usb storage (2.6.11 kernel)
Date: Tue, 27 Sep 2005 10:21:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509271020180.5703-100000@iolanthe.rowland.org>
References: <20050927.223801.130240000.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964794AbVI0OVU@vger.kernel.org>
In-Reply-To: <20050927.223801.130240000.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: jim.ramsay@gmail.com, mdharm-kernel@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Sep 2005, Atsushi Nemoto wrote:

> >>>>> On Thu, 8 Sep 2005 16:40:16 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> said:
> 
> stern> I've long thought that usb-storage should allocate its own
> stern> transfer buffer for sense data.  In the past people have said,
> stern> "No, don't bother, it's not really needed."  Here's a good
> stern> reason for doing it.
> 
> stern> Expect a patch before long.
> 
> Did you already create the patch?  If not, how about this (against 2.6.13) ?

Yes I did.  You can see it at

https://lists.one-eyed-alien.net/pipermail/usb-storage/2005-September/001953.html

Alan Stern
