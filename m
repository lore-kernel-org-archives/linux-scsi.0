From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ips driver 2/4: initialization reordering
Date: Thu, 6 Feb 2003 18:23:52 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206182352.A14946@infradead.org>
References: <A3B9245C291EEF4785A24A1DBE8D852B03773C@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A3B9245C291EEF4785A24A1DBE8D852B03773C@rtpexc01.adaptec.com>; from David_Jeffery@adaptec.com on Thu, Feb 06, 2003 at 01:14:38PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, Feb 06, 2003 at 01:14:38PM -0500, Jeffery, David wrote:
> This large patch reworks much of the adapter initialization
> code.
>=20
> It splits the scsi initialization code from the pci
> initialization.  It adds support for working with some
> future cards.  It also removes the use of multiple pci_driver
> registrations and instead does its own adapter ordering.
>=20
> The patch was made against 2.5.59.

Please don't use the obsolete scsi_register_host() interface but switch
to the hotplug-aware scsi_add_host.  Also please just make the template
a normal struct in ips.c instead of the magic macro initializ=E6tion.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
