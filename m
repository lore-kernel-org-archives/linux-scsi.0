From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Sun, 30 Sep 2012 00:31:04 +0200
Message-ID: <201209300031.04419.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1209291024380.29902-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1209291024380.29902-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Saturday, September 29, 2012, Alan Stern wrote:
> On Sat, 29 Sep 2012, Aaron Lu wrote:
> 
> > > I don't think this is a good idea, quite frankly.  sr seems to be a too
> > > generic place for that.
> > 
> > Does this mean sr can only have code that is useful to all devices it
> > manages? i.e. If a piece of code enables a feature for a special kind of
> > ODD(like the sata based ZPODD), it shouldn't be done in sr?
> 
> Drivers are allowed to have special features and quirks that apply only 
> to some devices.
> 
> > There is nothing in theory stopping us from doing this in ata layer.
> > For the loading mechanism, we can always send an ATAPI command to figure
> > it out.
> > 
> > So gentlemen, I need your opinions on where this ZPODD code should live
> > before I can continue this work, thanks.
> 
> Can arbitrary SCSI devices be ZP, or does this notion apply only to
> ATAPI-based drives?  That's the key question, and the answer determines
> where the ZP support belongs.

I agree.  That said for now I'm not aware of any other ZP devices.  It also
is unclear whether or not their requirements would be the same for the
ZPODD devices. 

> On the other hand, the sr driver certainly deserves to have some form 
> of runtime PM support, even for devices that aren't ZP.

Yes, it does, but it is unclear to me at this point what it should do in its
callbacks.

Thanks,
Rafael
