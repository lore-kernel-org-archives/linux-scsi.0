From: Hannes Reinecke <hare@suse.de>
Subject: Re: Dell CERC ATA100/4ch support
Date: Tue, 22 May 2007 16:50:23 +0200
Message-ID: <4653032F.5000406@suse.de>
References: <01e801c797bf$34f7ef00$15b2a8c0@newbrains> <1179327908.3787.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:53516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934516AbXEVOud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2007 10:50:33 -0400
In-Reply-To: <1179327908.3787.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Leigh Blackwell <leigh@codacommerce.com>, 374792@bugs.debian.org, akpm@osdl.org, linux-scsi@vger.kernel.org, sumant.patro@lsil.com, Matt Domsch <Matt_Domsch@dell.com>

James Bottomley wrote:
> On Wed, 2007-05-16 at 14:36 +0100, Leigh Blackwell wrote:
>> I have been looking at the issue with theses cerc devices, has this=20
>> bug 374792 been closed based on people reverting the firmware to < 6=
=2E61.=20
>>
>> Unfortunately Dell doesn't support a Firmware version that old on ou=
r=20
>> Server, is it possible to re-open this bug? I have been unable to ge=
t the
>> current etch install to recognize my driver controller with any of t=
he
>> megaraid drivers.
>=20
> Umm, but this is a bug in Dell Support isn't it?  I don't think there=
's
> a kernel fix for that.
>=20
> LSIs position is that in current kernels they only support this devic=
e
> with the new megaraid driver and only for firmware version >=3D 6.61.
> Surely you just need to get Dell and LSI on the same page?
>=20
Provided they have an interest in doing so.
Dell for one is _not_ interested in supplying an updated firmware.

So we're stuck.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
