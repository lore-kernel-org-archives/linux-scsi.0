From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] signed bug in scsi_device.h
Date: Thu, 13 May 2004 19:16:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040513171629.GA31832@suse.de>
References: <20040513164306.GA27050@suse.de> <20040513181047.A13153@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48789 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264206AbUEMRSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 13:18:11 -0400
Content-Disposition: inline
In-Reply-To: <20040513181047.A13153@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

 On Thu, May 13, Christoph Hellwig wrote:

> On Thu, May 13, 2004 at 06:43:06PM +0200, Olaf Hering wrote:
> >=20
> > one of the recent aic7xxx versions puts a -1 in scsi_cmnd->device->=
type,
> > in drivers/scsi/aic7xxx/aic79xx_osm.c
> > that doesnt work very well on ppc because aic7xxx tends to use -Wer=
ror.
> >=20
> > maybe scsi_level needs the signed as well.
>=20
> Maybe aic7xxx should stop doing stuff like that instead?

probably. Can you fix up scsi_alloc_sdev in the meantime?
I just looked again, the check was device->type !=3D -1.=20
Maybe our enterprise compiler is just too pedantic. I really dont know.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
