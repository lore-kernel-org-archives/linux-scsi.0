From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: RE: [PATCH] ips driver 2/4: initialization reordering
Date: Thu, 6 Feb 2003 14:58:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03773F@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>



> From: Christoph Hellwig
>=20
> On Thu, Feb 06, 2003 at 01:14:38PM -0500, Jeffery, David wrote:
> > This large patch reworks much of the adapter initialization
> > code.
> >=20
> > It splits the scsi initialization code from the pci
> > initialization.  It adds support for working with some
> > future cards.  It also removes the use of multiple pci_driver
> > registrations and instead does its own adapter ordering.
> >=20
> > The patch was made against 2.5.59.
>=20
> Please don't use the obsolete scsi_register_host() interface=20
> but switch
> to the hotplug-aware scsi_add_host.  Also please just make=20
> the template
> a normal struct in ips.c instead of the magic macro initializ=E6tion.

Using scsi_add_host is on my todo list.  I'll also convert
the evil IPS macro when I get a chance.

David Jeffery
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
