From: Eric Belhomme <rico@ricospirit.net>
Subject: Re: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work
 with LSI MegaRAID i4 since release 2.00.4
Date: Wed, 14 Feb 2007 10:54:30 +0100
Message-ID: <45D2DC56.3030807@ricospirit.net>
References: <20070213092920.f0bafea0.akpm@linux-foundation.org>	 <1171389557.3382.34.camel@mulgrave.il.steeleye.com>	 <45D22F1C.7060604@ricospirit.net> <1171406217.3382.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from paris.icsb.fr ([195.6.191.124]:44844 "EHLO lyon.admin.icsb.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbXBNK2l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 05:28:41 -0500
In-Reply-To: <1171406217.3382.48.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

James Bottomley a =E9crit :

>> So if I understand well, the module actively used with the LSI card =
is=20
>> megaraid, the legacy one ! but the mbox and mm are loaded and seems =
to=20
>> be necessary for the legacy driver ?
>=20
> Actually, it shouldn't be.  megaraid_mbox depends on megaraid_mm as y=
our
> lsmod shows, which is correct.  However, nothing's depending on legac=
y
> megaraid ... I'm not sure why it's showing as loaded and in use.
>=20
but it is ! moreover I have a /proc/megaraid/hba1/ directory structure=20
fully filled with my RAID card, drives, and RAID volumes informations,=20
and I don't hav any entry in sysfs directory tree (witch is the right=20
place for megaraid NG module)

I'd like to understand _why_ this module supposed to be independant fro=
m=20
the "new generation" megaraid module needs megaraid NG to be compiled t=
o=20
work correctly ?

I looked over the sources but I didn't found any link between the legac=
y=20
driver and the newgen one... quite strange !

Regards,

--=20
Rico

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
