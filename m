From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Tue, 22 Jan 2013 10:25:31 +0800
Message-ID: <20130122022531.GA20211@aaronlu.sh.intel.com>
References: <50FA5F67.4080102@intel.com>
 <CAGRGNgWc2QTnY==NdMeZpw-7L3WwQfBFOwm=UZZ3Jcz+dp=h3g@mail.gmail.com>
 <20130121091104.GA11010@aaronlu.sh.intel.com>
 <1671780.QshOn4REzF@linux-5eaq.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1671780.QshOn4REzF@linux-5eaq.site>
Sender: linux-pm-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Julian Calaby <julian.calaby@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 21, 2013 at 03:56:43PM +0100, Oliver Neukum wrote:
> On Monday 21 January 2013 17:11:04 Aaron Lu wrote:
> > It is not easy for the OS to tell if the drive is being used or not
> > sometimes 
> > 
> > Alan has reminded me it is possible for an app to open the block device
> > file(/dev/sr0), issue a command(play audio), then close the device file.
> > From the OS' point of view, we think nobody is using it. But actually,
> > the drive is playing cd for the user, so we can't suspend the device.
> 
> Are there drives that support ZPODD and have an audio output?

I'm afraid I don't know, since there are so many ODD makers.
But at least we can say, the SPEC doesn't forbid it.

Thanks,
Aaron

