From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH] ips driver 2/4: initialization reordering
Date: Thu, 6 Feb 2003 20:00:01 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206200001.A16467@infradead.org>
References: <A3B9245C291EEF4785A24A1DBE8D852B03773F@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A3B9245C291EEF4785A24A1DBE8D852B03773F@rtpexc01.adaptec.com>; from David_Jeffery@adaptec.com on Thu, Feb 06, 2003 at 02:58:18PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, Feb 06, 2003 at 02:58:18PM -0500, Jeffery, David wrote:
> > Please don't use the obsolete scsi_register_host() interface=20
> > but switch
> > to the hotplug-aware scsi_add_host.  Also please just make=20
> > the template
> > a normal struct in ips.c instead of the magic macro initializ=E6tio=
n.
>=20
> Using scsi_add_host is on my todo list.  I'll also convert
> the evil IPS macro when I get a chance.

Cool!

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
