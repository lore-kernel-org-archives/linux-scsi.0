From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Wed, 19 Sep 2012 15:05:15 +0200
Message-ID: <3371596.56tAzlQG23@linux-lqwf.site>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <20120919080328.GA4283@mint-spring.sh.intel.com> <1348057667.2479.33.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1348057667.2479.33.camel@dabdike.int.hansenpartnership.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 19 September 2012 13:27:47 James Bottomley wrote:
> On Wed, 2012-09-19 at 16:03 +0800, Aaron Lu wrote:
> > Hi James,
> >=20
> > May I know if this patchset will enter v3.7?
>=20
> Sigh, well, I was hoping to persuade the PM people to sort this out
> first.
>=20
> The first observation is that all this looks to be too specific.  ZPO
> may be ACPI specific, but the property it abstracts: whether the
> particular device is powered off or not is generic and probably shoul=
d
> be known at the generic PM level.  Nothing actually really cares abou=
t
> how we power off the device until you get all the way down to the ACP=
I
> controller.

The SCSI layer however needs to know whether the cache is handled
by the OS or in the device and under which circumstances a device
can detect media change events.

	Regards
		Oliver


--=20
- - -=20
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6=
rffer, HRB 16746 (AG N=FCrnberg)=20
Maxfeldstra=DFe 5                        =20
90409 N=FCrnberg=20
Germany=20
- - -=20
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
