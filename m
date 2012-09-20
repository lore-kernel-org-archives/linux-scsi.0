From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v7 0/6] ZPODD patches
Date: Thu, 20 Sep 2012 08:34:59 +0800
Message-ID: <61B33BA8121D47DDB62CF71F004E15E8@usish.com.cn>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <20120919080328.GA4283@mint-spring.sh.intel.com> <1348057667.2479.33.camel@dabdike.int.hansenpartnership.com> <1348067972.21322.218.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1348067972.21322.218.camel@shinybook.infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: 'David Woodhouse' <dwmw2@infradead.org>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: 'Aaron Lu' <aaron.lu@intel.com>, 'Alan Stern' <stern@rowland.harvard.edu>, 'Oliver Neukum' <oliver@neukum.org>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, 'Aaron Lu' <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> 
> On Wed, 2012-09-19 at 13:27 +0100, James Bottomley wrote:
> > I think we could do this with a couple of flags sitting inside struct
> > device itself: one for pm state and capabilities defined at a generic
> > level and one for device specific pm state.  The latter would be for
> > things like the door lock information which is very specific to CDs
> > (although not specific to SCSI CDs).  Alternatively, even if we can't
> > use these capabilities at the generic pm level, we still need an
> > internal state set of flags because power state stuff traverses the
> > stack and struct device is the only universal object in that stack.
> 
> FWIW the SATA Device Sleep support, which is currently only used (in a
> patch which is pending) automatically as an extension of the AHCI link
> power management, can also be triggered manually by a GPIO line; I've
> got a platform where it's done with an ACPI call. I suspect we'll see
> that kind of manual setup on a few embedded platforms too.
> 
> If we're working on hooking this up through the device layers, perhaps
> that's worth taking into consideration?
> 
> --

Hi David,

For SATA Device sleep, what's the appropriate time to set the Device sleep,
this seems also part of runtime PM?

Best regards!

Jack

