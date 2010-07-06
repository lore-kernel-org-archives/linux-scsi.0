From: Dan Porat <dan.porat@gmail.com>
Subject: Re: 520 BPS data integrity vendors
Date: Tue, 6 Jul 2010 14:01:07 -0400
Message-ID: <AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
	<AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
	<yq1mxu981eg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56212 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0GFS0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2010 14:26:20 -0400
In-Reply-To: <yq1mxu981eg.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

We checked with kernel 2.6.34 , Seagate Cheetah 15K and the following H=
BA:

LSI 9212-4i4e

Still , no success.

Any Ideas?

Thanks



On Sat, Jul 3, 2010 at 3:33 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> >>>>> "Dan" =3D=3D Dan Porat <dan.porat@gmail.com> writes:
>
> >>> Would you know of any specific LSI SAS/HBAmodel which will suppor=
t
> >>> SCSI DIF/DIX ?
>
> LSI's 92xx series HBAs have the LSISAS2008 chip that's required for D=
IF
> operation. These boards do not support DIX.
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
