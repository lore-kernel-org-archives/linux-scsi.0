From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Patch: s390 root on scsi disc
Date: Sat, 19 Jun 2004 15:52:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040619145244.GA6398@infradead.org>
References: <1087661628.26436.30.camel@localhost> <20040619142738.GA6062@infradead.org> <1087663139.26437.43.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:43470 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263937AbUFSOwp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 10:52:45 -0400
Content-Disposition: inline
In-Reply-To: <1087663139.26437.43.camel@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Stefan =?iso-8859-1?Q?V=F6lkel?= <stefan.voelkel@millenux.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Heiko Carstens <Heiko.Carstens@de.ibm.com>

On Sat, Jun 19, 2004 at 04:39:00PM +0000, Stefan V=F6lkel wrote:
> >=20
> > please use module_param instead.  still wondering why zfcp needs pa=
ramters
> > anyway..
>=20
> Well, my problem was that passing device=3Dfoo at boot time (zfcp com=
piled
> into the kernel) resulted in device beeing empty. device is
>=20
>         module_param(device, charp, 0);
>         MODULE_PARM_DESC(device, "specify initial device");

You need to pass zfcp.device=3Dfoo
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
