From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.37: USB Thermaltake Dock: Only see's 1 HDD? [SOLVED, but
 which option fixed it?]
Date: Fri, 18 Feb 2011 16:44:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1102181643030.27433-100000@netrider.rowland.org>
References: <alpine.DEB.2.02.1102181621190.4561@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1102181621190.4561@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 18 Feb 2011, Justin Piszcz wrote:

> When I attach a dock with two HDD's on it in Linux, it only picks up one HDD,
> this is with a Thermaltake BlackX Duet, is there a special module/etc
> I need to load so it sees both drives on USB?
> 
> So I added some additional kernel options and now it seems fixed, but 
> this is more of a shotgun approach, instead of rebuilding/rebooting 
> several times does anyone know which module enabled support of > 1 HDD on 
> the USB dock as shown below?

> +CONFIG_SCSI_MULTI_LUN=y

That's the one.

Alan Stern
