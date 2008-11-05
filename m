From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
Date: Wed, 05 Nov 2008 15:00:20 +0200
Message-ID: <491198E4.8080306@panasas.com>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <20081104111037.bcae04e5.akpm@linux-foundation.org> <20081104194240.GC16036@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:1890 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYKENAY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 08:00:24 -0500
In-Reply-To: <20081104194240.GC16036@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com

J=C3=B6rn Engel wrote:
> On Tue, 4 November 2008 11:10:37 -0800, Andrew Morton wrote:
>> etc, etc, etc.   Please review all that.
>=20
> One easy way to review 98% is to include the header in an otherwise
> empty foo.c and compile that.  The remaining 2% are hidden behind
> different config options and architectures.  Although your header may=
 be
> fine on that front.
>=20
> J=C3=B6rn
>=20

I have done just that. It's an old habit of mine. The very first
#include in osd_initiator.c is osd_initiator.h precisely for that.
So it's not just a one time test it's always tested.

Thanks
Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
