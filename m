From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 5/7] scsi: pm: add may_power_off flag
Date: Thu, 6 Sep 2012 09:52:01 +0800
Message-ID: <20120906015200.GA1866@mint-spring.sh.intel.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
 <1346768680-7287-6-git-send-email-aaron.lwe@gmail.com>
 <1539628.e0bNDi5Td8@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539628.e0bNDi5Td8@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 04, 2012 at 06:01:22PM +0200, Oliver Neukum wrote:
> On Tuesday 04 September 2012 22:24:38 Aaron Lu wrote:
> > From: Aaron Lu <aaron.lu@intel.com>
> > 
> > Add a new flag may_power_off for scsi device, it gives the user a chance
> > to control when the device is runtime suspended, can we remove its power
> > if possible.
> > 
> > And if the device can be powered off(reflected by can_power_off flag,
> > determined by individual driver), create a sysfs entry named
> > may_power_off to let user control the flag.
> 
> Do we really need yet another interface to user space?

We do not have a way to let user decide when device is runtime
suspended, can we remove its power, so I added this flag. PCI subsystem
has a similar flag named d3cold_allowed.

This flag can disable the power off of ZPODD capable devices, or put a
rotational disk into powered off if user so choose.

Thanks,
Aaron
