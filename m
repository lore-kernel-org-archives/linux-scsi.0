From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert drivers/scsi/ch.c to use unlocked_ioctl
Date: Mon, 14 Jan 2008 15:22:42 +0100
Message-ID: <87odbotrkd.fsf@barad-dur.regala.cx>
References: <1200317533-24643-1-git-send-email-mathieu.segaud@regala.cx>
	<20080114141854.GJ18741@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751025AbYANOWx@vger.kernel.org>
In-Reply-To: <20080114141854.GJ18741@parisc-linux.org> (Matthew Wilcox's message of "Mon\, 14 Jan 2008 07\:18\:54 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Vous m'avez dit r=E9cemment :

> On Mon, Jan 14, 2008 at 02:32:13PM +0100, Mathieu Segaud wrote:
>> +#include <linux/smp_lock.h>
> You don't add any uses of lock_kernel() and there are none in the
> driver currently.

yep, it was before I noticed the locking semantics of
ch_ioctl_compat()

>> -	.owner        =3D THIS_MODULE,
>> -	.open         =3D ch_open,
>> -	.release      =3D ch_release,
>> -	.ioctl        =3D ch_ioctl,
>> +	.owner          =3D THIS_MODULE,
>> +	.open           =3D ch_open,
>> +	.release        =3D ch_release,
>> +	.unlocked_ioctl =3D ch_ioctl,
>
> If you're going to do the gratuitous reformatting, at least use tabs
> instead of spaces.

thanks, will do

> Other than that, should be fine.

I repost this one
thanks a lot.

--=20
Mathieu

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
