From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 16:22:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021024232258.GA26093@kroah.com>
References: <Pine.LNX.4.33L2.0210241350230.20950-100000@dragon.pdx.osdl.net> <Pine.LNX.4.33.0210241839490.10937-100000@rancor.yyz.somanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0210241839490.10937-100000@rancor.yyz.somanetworks.com>
To: Scott Murray <scottm@somanetworks.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, Steven Dake <sdake@mvista.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 24, 2002 at 07:00:23PM -0400, Scott Murray wrote:
> 
> I've not implemented it yet, but I'm pretty sure I can detect surprise
> extractions in my cPCI driver.  The only thing holding me back at the
> moment is that there's no clear way to report this status change via
> pcihpfs without doing something a bit funky like reporting "-1" in the
> "adapter" node.

Why would you need to report anything other than if the card is present
or not?  What would a "supprise" removal cause you to do differently?
Hm, well I guess we should be extra careful in trying to shut down any
driver bound to that card...

thanks,

greg k-h
