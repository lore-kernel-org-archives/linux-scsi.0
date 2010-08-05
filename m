From: Dan Porat <dan.porat@gmail.com>
Subject: Re: 520 BPS data integrity vendors
Date: Thu, 5 Aug 2010 16:39:34 -0400
Message-ID: <AANLkTimK6aE9VP=P45bDP5s8wFc9TbMDscP1YS=DjA-3@mail.gmail.com>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
	<AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
	<yq1mxu981eg.fsf@sermon.lab.mkp.net>
	<AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
	<yq1630s8msu.fsf@sermon.lab.mkp.net>
	<AANLkTilqzgIav9noTYLC9cxKtntva6wQwLSUI1i8DgAe@mail.gmail.com>
	<yq17hkwrh57.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50470 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763Ab0HEUjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 16:39:36 -0400
In-Reply-To: <yq17hkwrh57.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Thank you all for your great advice.
Actually we did succeed with the Hitachi drives.

Thank you very very much.

Dan Porat

On Thu, Jul 15, 2010 at 9:47 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> >>>>> "Dan" =3D=3D Dan Porat <dan.porat@gmail.com> writes:
>
> Dan> [root@fedora13 ~]# sg_inq /dev/sdb
> [...]
> Dan> [root@fedora13 ~]# sg_readcap /dev/sdb
> [...]
>
> I asked for EXTENDED INQUIRY and READ CAPACITY(16).
>
> # sg_inq -x /dev/sdb
> # sg_readcap -l /dev/sdb
>
> It does not look like you have reformatted the drive, though...
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
