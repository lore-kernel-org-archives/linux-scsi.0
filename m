From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/3] [SCSI] Fix command result state propagation
Date: Mon, 31 Mar 2014 09:00:22 +0200
Message-ID: <53391286.9020007@suse.de>
References: <1396028874.15365.30.camel@dabdike> <1396029075.15365.33.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396029075.15365.33.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 03/28/2014 06:51 PM, James Bottomley wrote:
> From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
>=20
> We're seeing a case where the contents of scmd->result isn't being re=
set after
> a SCSI command encounters an error, is resubmitted, times out and the=
n gets
> handled.  The error handler acts on the stale result of the previous =
error
> instead of the timeout.  Fix this by properly zeroing the scmd->statu=
s before
> the command is resubmitted.
>=20
> Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> Signed-off-by: James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>

<grin>

Acked-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
