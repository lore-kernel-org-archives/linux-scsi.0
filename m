From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_unregister_driver in 2.6.10
Date: Tue, 11 Jan 2005 03:00:07 +0000
Message-ID: <20050111030007.GS27371@parcelfarce.linux.theplanet.co.uk>
References: <e20f392505011016575aac92a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39110 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262479AbVAKDAJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 22:00:09 -0500
Content-Disposition: inline
In-Reply-To: <e20f392505011016575aac92a1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Mahajan <vmahajan@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 10, 2005 at 05:57:32PM -0700, Vivek Mahajan wrote:
> I was working on my SCSI module and tried to use
> scsi_unregister_driver(). But looks like it has been made GPL only. I
> get unresolved symbol : driver_unregister(), when I tried to load the
> module. I think it is #defined to driver_unregister() in
> include/scsi/scsi_driver.h. And driver_unregister is exported as GPL
> only.
> 
> At the same time, scsi_register_driver() works with non GPL code
> without any problem. As this call is exclusively defined in
> drivers/scsi/scsi_sysfs.c.
> 
> I was just wondering wss it unintentional Or there was a purpose
> behind that to make scsi_register_driver( ) as non GPL and
> scsi_unregister_driver( ) as GPL only.

I think this was unintentional.  However, I'm not sure there's a
compelling reason to undo it -- scsi_register_driver is for registering
top-level drivers like st, sr, sd and osst.  What kind of driver is this
that you're writing?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
