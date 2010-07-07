From: Dan Porat <dan.porat@gmail.com>
Subject: Re: 520 BPS data integrity vendors
Date: Wed, 7 Jul 2010 06:34:42 -0400
Message-ID: <AANLkTildJKANf7tC_OkYII-4T01oBgPx7YDC_WjuPSmN@mail.gmail.com>
References: <AANLkTilcpFgsYtEUkZ2zAU3SDs0jetiajYPzKUWgFMyD@mail.gmail.com>
	<1278093968.2856.169.camel@mulgrave.site>
	<AANLkTilWKeOAXMukh_zvXzdXkdOTk6soAEnpzFNwvBA3@mail.gmail.com>
	<yq1mxu981eg.fsf@sermon.lab.mkp.net>
	<AANLkTimI7Ke4qXw7zv8WDsWSQtBRSwSi5IZbvByjGRih@mail.gmail.com>
	<yq1630s8msu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1630s8msu.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Thanks for the elaborate answer.
We want to buy the drive which supports (rather than currently
investigating , probably your assumption is right and our seagate does
not have the required FW).

Regarding the specific model ,
Will any of those do ?

HUS151414VL3800
HUS151473VL3800
HUS151436VL3800
HUS151414VL3600
HUS151473VL3600
HUS151436VL3600

Thanks

Dan Porat


On Tue, Jul 6, 2010 at 2:53 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> >>>>> "Dan" =3D=3D Dan Porat <dan.porat@gmail.com> writes:
>
> Dan> We checked with kernel 2.6.34 , Seagate Cheetah 15K and the
> Dan> following HBA: LSI 9212-4i4e
>
> Dan> Still , no success.
>
> Send us the output of:
>
> # lsscsi -p
> # sg_inq -x /dev/sdN
> # sg_readcap -l /dev/sdN
>
>
> Dan> Any Ideas?
>
> And you are sure that the drive is formatted with DIF? =A0Seagate's
> standard firmware doesn't support it, fwiw. =A0It's a build-to-order
> option.
>
> Hitachi drives support DIF out of the box.
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
