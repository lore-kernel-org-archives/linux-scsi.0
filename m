From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c:
 aha152x_resume(): variable used before set
Date: Sat, 18 Feb 2006 14:14:23 -0800
Message-ID: <20060218141423.7d741859.akpm@osdl.org>
References: <200602180209.k1I29meW030162@fire-2.osdl.org>
	<20060217211049.4368ff20.akpm@osdl.org>
	<20060218221039.GA3912@linux-buechse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62380 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932194AbWBRWP6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 17:15:58 -0500
In-Reply-To: <20060218221039.GA3912@linux-buechse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "=?ISO-8859-1?B?SvxyZ2Vu?= E. Fischer" <fischer@linux-buechse.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

J=FCrgen E. Fischer <fischer@linux-buechse.de> wrote:
>
> On Fri, Feb 17, 2006 at 21:10:49 -0800, Andrew Morton wrote:
>  > > I just tried to compile the Linux Kernel version 2.6.11.12
>  > > with the most excellent Intel C compiler. It said
>  > >=20
>  > > drivers/scsi/pcmcia/aha152x_stub.c(313): remark #592: variable "=
tmp" is used
>  > > before its value is set
>  > >        tmp.device->host =3D info->host;
>  > >        ^
>  > >=20
>  > > This is clearly broken code, since the field tmp.device has not =
been
>  > > initialised, and so isn't pointing to anything.
>=20
>  Fix below.

Thanks.

Could we please have a more complete description of this change?  It's
obviosly doing more than fixing a used-uninitialised bug..
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
