From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] aacraid: add vpd to inquiry
Date: Thu, 19 Jul 2007 15:07:09 +0200
Message-ID: <20070719130709.GH21899@pentland.suse.de>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0189EBAA@otce2k301.adaptec.com> <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5C40@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbXGSNHK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 09:07:10 -0400
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5C40@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2007 at 05:08:05PM -0400, Salyzyn, Mark wrote:
> Report VPD inquiry page 0x80 with an unique array creation serial num=
ber
> (CUID). When an array is created, the metadata stored on the physical
> drives gets an unique serial number. This serial number remains const=
ant
> through array morphing or migration to other controllers. This patch =
is
> a forward port and modification to survive morphing and migration
> operations, of a similar piece of (un-attributed author) code added t=
o
> the SLES10 SP1 aacraid driver.
>=20
Hmph. I seem to remember I've sent a similar patch to you, so I'd assum=
e
that the (un-attributed author) was in fact me.

But glad that we've finally got VPD pages for aacraid, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=EF=BF=BDrnberg
GF: Markus Rex, HRB 16746 (AG N=EF=BF=BDrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
