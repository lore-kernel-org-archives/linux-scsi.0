From: Vivek Mahajan <vmahajan@gmail.com>
Subject: Re: scsi_unregister_driver in 2.6.10
Date: Mon, 10 Jan 2005 20:20:15 -0700
Message-ID: <e20f39250501101920a1954c4@mail.gmail.com>
References: <e20f392505011016575aac92a1@mail.gmail.com>
	 <20050111030007.GS27371@parcelfarce.linux.theplanet.co.uk>
Reply-To: Vivek Mahajan <vmahajan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.195]:53270 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262542AbVAKDUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 22:20:15 -0500
Received: by wproxy.gmail.com with SMTP id 67so129812wri
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 19:20:15 -0800 (PST)
In-Reply-To: <20050111030007.GS27371@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Thanks for ur reply back. The driver is an iSCSI driver which does
registeration with scsi generic driver for the various SATA drives. In
2.4 we used to use scsi_register_module() which is gone in 2.6.

It is a non GPL driver and I was just wondering what would be the work around.

Thanks muchly for your help.

Vivek


On Tue, 11 Jan 2005 03:00:07 +0000, Matthew Wilcox <matthew@wil.cx> wrote:
> On Mon, Jan 10, 2005 at 05:57:32PM -0700, Vivek Mahajan wrote:
> > I was working on my SCSI module and tried to use
> > scsi_unregister_driver(). But looks like it has been made GPL only. I
> > get unresolved symbol : driver_unregister(), when I tried to load the
> > module. I think it is #defined to driver_unregister() in
> > include/scsi/scsi_driver.h. And driver_unregister is exported as GPL
> > only.
> >
> > At the same time, scsi_register_driver() works with non GPL code
> > without any problem. As this call is exclusively defined in
> > drivers/scsi/scsi_sysfs.c.
> >
> > I was just wondering wss it unintentional Or there was a purpose
> > behind that to make scsi_register_driver( ) as non GPL and
> > scsi_unregister_driver( ) as GPL only.
> 
> I think this was unintentional.  However, I'm not sure there's a
> compelling reason to undo it -- scsi_register_driver is for registering
> top-level drivers like st, sr, sd and osst.  What kind of driver is this
> that you're writing?
> 
> --
> "Next the statesmen will invent cheap lies, putting the blame upon
> the nation that is attacked, and every man will be glad of those
> conscience-soothing falsities, and will diligently study them, and refuse
> to examine any refutations of them; and thus he will by and by convince
> himself that the war is just, and will thank God for the better sleep
> he enjoys after this process of grotesque self-deception." -- Mark Twain
>
