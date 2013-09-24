From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 00/20] [SCSI] remove unnecessary pci_set_drvdata()
Date: Tue, 24 Sep 2013 10:19:41 +0900
Message-ID: <001401ceb8c4$25214040$6f63c0c0$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
 <1379962528.2109.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38433 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3IXBTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 21:19:43 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTL0021AVO809D0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 24 Sep 2013 10:19:42 +0900 (KST)
In-reply-to: <1379962528.2109.6.camel@dabdike.int.hansenpartnership.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

On Tuesday, September 24, 2013 3:55 AM, James Bottomley wrote:
> On Mon, 2013-09-23 at 09:54 +0900, Jingoo Han wrote:
> > Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> > (device-core: Ensure drvdata =3D NULL when no driver is bound),
> > the driver core clears the driver data to NULL after device_release
> > or on probe failure. Thus, it is not needed to manually clear the
> > device driver data to NULL.
>=20
> Look, these are particularly pointless patches.  The null setting is
> only on teardown; the fact that we set something to NULL that should
> already be null doesn't matter at all the extra cycles simply won't b=
e
> noticed.  Please roll them into a single patch and send them to Ji=C5=
=99=C3=AD
> Kosina and the trivial tree (cc'd) he'll take care of checking and
> applying them (assuming they meet his criteria for worth bothering
> with).
>=20

OK, I see.
I squashed all 20 patches into a single patch, and sent the single patc=
h
to Jiri Kosina and the trivial tree, as you mentioned.
Thank you for your guidance.

Best regards,
Jingoo Han

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
