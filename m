From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH TRIVIAL] Compile error in 2.4.22 without PCI
Date: Fri, 17 Oct 2003 13:33:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017133301.B27349@infradead.org>
References: <20031015003036.A10226@natasha.ward.six>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:47111 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263431AbTJQMdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:33:03 -0400
Content-Disposition: inline
In-Reply-To: <20031015003036.A10226@natasha.ward.six>; from zzz@anda.ru on Wed, Oct 15, 2003 at 12:30:36AM +0600
List-Id: linux-scsi@vger.kernel.org
To: Denis Zaitsev <zzz@anda.ru>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 15, 2003 at 12:30:36AM +0600, Denis Zaitsev wrote:
> I have these warnings when I'm compiling 2.4.22 for a 486 EISA system=
:
>=20
> aic7xxx_osm.c: In function `ahc_softc_comp':
> aic7xxx_osm.c:1560: warning: implicit declaration of function `ahc_ge=
t_pci_bus'
> aic7xxx_osm.c:1568: warning: implicit declaration of function `ahc_ge=
t_pci_slot'
>=20
> And then the make finishes with an error, because these functions
> really exist only if the PCI support is turned on.
>=20
> The patch below fixes this.  And the same patch fits for the 2.6
> kernels.  Please, apply it.

You probably want to send this to Justin, the driver Maintainer.  If he
doesn't reply in say a week I=B4d suggest submitting it to Marcelo as i=
t's
obviously correct.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
