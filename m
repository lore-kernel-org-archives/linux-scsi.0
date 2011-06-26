From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] PM / Runtime: Update documentation of interactions
 with system sleep
Date: Sat, 25 Jun 2011 23:01:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1106252257440.10907-100000@netrider.rowland.org>
References: <alpine.LNX.2.00.1106260055270.23991@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1106260055270.23991@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 26 Jun 2011, Jesper Juhl wrote:

> On Sun, 26 Jun 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> 
> A few tiny nit-picks..

And a few more...

> > The documents describing the interactions between runtime PM and
> > system sleep generally refer to the model in which the system sleep
> > state is entered through a global firmware or hardware operation.
> > As a result, some recommendations given in there are not entirely
> > suitable for systems in which this is not the case.  Update the
> > documentation take the existence of those systems into accout.
> > 
> 
> I believe this should read "... documentation to take the existence of 
> those systems ..."

Also add the missing 'n' in "account".

> > +known to it.  If that is the case and none of the situations listed above takes
> > +place (in particular, if the system is not waking up from hibernation), it may
> > +be more efficient to leave the devices that had been suspended before the system
> > +suspend began in the suspended state.
> > +
> 
> You are refering to device*s*, so I believe this last bit should be "... 
> in the suspended states".

No, the text is correct as it stands.  There are many devices, but
there are only two power states: active and suspended.  For example,
it's perfectly correct to say "All five devices are in the suspended
state" -- and it would be wrong to say "All five are in the suspended
states" (that makes it sound as if the states are suspended rather 
than the devices being suspended).

Alan Stern
