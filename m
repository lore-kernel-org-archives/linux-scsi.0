From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: small diff in reported GiB size of an SSD
Date: Mon, 29 Feb 2016 07:49:07 -0800
Message-ID: <1456760947.2390.9.camel@HansenPartnership.com>
References: <56D44840.5080405@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51468 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbcB2PtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 10:49:09 -0500
In-Reply-To: <56D44840.5080405@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, linux-scsi@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, 2016-02-29 at 13:31 +0000, Toralf F=C3=B6rster wrote:
> I'm just curious about this diff in dmesg output between 4.3.2 and
> 4.3.3 at a 64 bit Gentoo hardened system:
>=20
> $ diff dmesg-4.4.[23]-hardened | grep logical
> < sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/223
> GiB)
> > sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224
> > GiB)
>=20

commit 564b026fbd0d28e9f70fb3831293d2922bb7855b
Author: James Bottomley <JBottomley@Odin.com>
Date:   Wed Jan 20 14:58:29 2016 -0800

    string_helpers: fix precision loss for some inputs
=20
James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
