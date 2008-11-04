From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
Date: Tue, 4 Nov 2008 20:42:40 +0100
Message-ID: <20081104194240.GC16036@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <20081104111037.bcae04e5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:51233 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYKDTnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 14:43:21 -0500
Content-Disposition: inline
In-Reply-To: <20081104111037.bcae04e5.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com

On Tue, 4 November 2008 11:10:37 -0800, Andrew Morton wrote:
>=20
> etc, etc, etc.   Please review all that.

One easy way to review 98% is to include the header in an otherwise
empty foo.c and compile that.  The remaining 2% are hidden behind
different config options and architectures.  Although your header may b=
e
fine on that front.

J=C3=B6rn

--=20
He who knows others is wise.
He who knows himself is enlightened.
-- Lao Tsu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
