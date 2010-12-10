From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Date: Fri, 10 Dec 2010 02:49:53 -0800 (PST)
Message-ID: <823199.4758.qm@web31810.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, willy@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

Patch retracted for this still-born driver. Instead please use superior=
 uasp.c which was recently submitted.

--- On Wed, 10/27/10, Luben Tuikov <ltuikov@yahoo.com> wrote:

> From: Luben Tuikov <ltuikov@yahoo.com>
> Subject: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
> To: "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org, linux-kern=
el@vger.kernel.org, linux-scsi@vger.kernel.org, willy@linux.intel.com
> Date: Wednesday, October 27, 2010, 1:22 PM
> "Be conservative in what you send,
> liberal in what
> you accept." -- In the spirit of this adage, don't
> send Command IUs with randomly filled in data in
> the reserved fields. (Yes, this shows up on the
> wire.)
>=20
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/usb/storage/uas.c |=A0 =A0 6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/storage/uas.c
> b/drivers/usb/storage/uas.c
> index 2054b1e..17e1820 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -294,7 +294,7 @@ static struct urb
> *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t
> gfp,
>  =A0=A0=A0 if (!urb)
>  =A0=A0=A0 =A0=A0=A0 goto out;
> =20
> -=A0=A0=A0 iu =3D kmalloc(sizeof(*iu), gfp);
> +=A0=A0=A0 iu =3D kzalloc(sizeof(*iu), gfp);
>  =A0=A0=A0 if (!iu)
>  =A0=A0=A0 =A0=A0=A0 goto free;
> =20
> @@ -325,7 +325,7 @@ static struct urb
> *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
>  =A0=A0=A0 if (len < 0)
>  =A0=A0=A0 =A0=A0=A0 len =3D 0;
>  =A0=A0=A0 len =3D ALIGN(len, 4);
> -=A0=A0=A0 iu =3D kmalloc(sizeof(*iu) + len, gfp);
> +=A0=A0=A0 iu =3D kzalloc(sizeof(*iu) + len, gfp);
>  =A0=A0=A0 if (!iu)
>  =A0=A0=A0 =A0=A0=A0 goto free;
> =20
> @@ -660,7 +660,7 @@ static int uas_probe(struct
> usb_interface *intf, const struct usb_device_id *id)
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return -ENODEV;
>  =A0=A0=A0 }
> =20
> -=A0=A0=A0 devinfo =3D kmalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
> +=A0=A0=A0 devinfo =3D kzalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
>  =A0=A0=A0 if (!devinfo)
>  =A0=A0=A0 =A0=A0=A0 return -ENOMEM;
> =20
> --=20
> 1.7.0.1
>=20
>=20
