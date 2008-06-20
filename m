From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before
	mounting root
Date: Fri, 20 Jun 2008 11:53:11 +0200
Message-ID: <20080620095311.GK15159@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org> <200806191613.25552.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752420AbYFTJyV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200806191613.25552.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <matthew@wil.cx>, Pekka J Enberg <penberg@cs.helsinki.fi>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2008 at 04:13:25PM -0700, David Brownell wrote:

> Why give up, ever? 

It would be quite useful to time out and reboot using the previous
kernel ("lilo -R") when one wants to figure out remotely why the new
kernel does not boot.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
