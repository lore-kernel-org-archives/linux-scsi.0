From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 69/78] ncr5380: Fix whitespace in comments using
 regexp
Date: Sat, 02 Jan 2016 23:54:28 -0800
Message-ID: <1451807668.4334.38.camel@perches.com>
References: <20160103050501.042035135@telegraphics.com.au>
	 <20160103050520.752909053@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:52302 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751016AbcACHyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 02:54:32 -0500
In-Reply-To: <20160103050520.752909053@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2016-01-03 at 16:06 +1100, Finn Thain wrote:
> Hanging indentation was a poor choice for the text inside comments. I=
t
> has been used in the wrong places and done badly elsewhere. There is
> little consistency within any file. One fork of the core driver uses
> tabs for this indentation while the other uses spaces. Better to use
> flush-left alignment throughout.
>=20
> This patch is the result of the following substitution. It replaces t=
abs
> and spaces at the start of a comment line with a single space.
>=20
> perl -i -pe 's,^(\t*[/ ]\*)[ \t]+,$1 ,' drivers/scsi/{atari_,}NCR5380=
=2Ec=A0
>=20
> This removes some unimportant discrepancies between the two core driv=
er
> forks so that the important ones become obvious, to facilitate
> reunification.

I still think this patch is poor at best and
overall not useful.
@@ -32,15 +32,15 @@
> =A0/*
> =A0 * Further development / testing that should be done :
> =A0 * 1.=A0=A0Cleanup the NCR5380_transfer_dma function and DMA opera=
tion complete
> - *=A0=A0=A0=A0=A0code so that everything does the same thing that's =
done at the
> - *=A0=A0=A0=A0=A0end of a pseudo-DMA read operation.
> + * code so that everything does the same thing that's done at the
> + * end of a pseudo-DMA read operation.
> =A0 *
> =A0 * 2.=A0=A0Fix REAL_DMA (interrupt driven, polled works fine) -
> - *=A0=A0=A0=A0=A0basically, transfer size needs to be reduced by one
> - *=A0=A0=A0=A0=A0and the last byte read as is done with PSEUDO_DMA.
> + * basically, transfer size needs to be reduced by one
> + * and the last byte read as is done with PSEUDO_DMA.
> =A0 *
> =A0 * 4.=A0=A0Test SCSI-II tagged queueing (I have no devices which s=
upport
> - *=A0=A0=A0=A0=A0=A0tagged queueing)
> + * tagged queueing)

Numbering 1, 2, then 4 could be improved.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
