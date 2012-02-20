From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
Date: Mon, 20 Feb 2012 13:39:13 +0800
Message-ID: <1329716353.1511.19.camel@rui.sh.intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202142329.16516.rjw@sisk.pl>
	 <1329376106.28581.5.camel@rui.sh.intel.com>
	 <201202172323.18022.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <201202172323.18022.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On =E4=BA=94, 2012-02-17 at 23:23 +0100, Rafael J. Wysocki wrote:
> > Okay, agreed.
> > so how about this? _PR3 equals D3_HOT support.
>=20
> Yes, I can agree with that. :-)
>=20
> > > > Hmm, how about set D3_COLD support if _PR3 exists, but leave a =
warning
> > > > message if _OFF doesn't exist, for now?
> > >=20
> > > I don't think we need to set D3_COLD support at all.  In fact, it=
 is always
> > > supported (as I said, if all power resources used by a device are=
 off, the
> > > device is in D3_COLD pretty much by definition).
> > >=20
> > Yeah, but it seems that Linux uses ACPI_D3 for both ACPICA D3_HOT a=
nd D3
> > (off). I'm generating a patch to remove ACPI_D3_COLD and introduce
> > D3_HOT support in Linux kernel.
>=20
> That's a good idea in my opinion.

Great.
Patch will be sent out later.

thanks,
rui

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
