From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 00/16]  qla2xxx: Patches for target-pending branch
Date: Wed, 06 Jan 2016 11:01:32 -0800
Message-ID: <1452106892.26125.36.camel@haakon3.risingtidesystems.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1450681047.25674.32.camel@haakon3.risingtidesystems.com>
	 <D2B2862C.D155F%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49667 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbcAFTBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 14:01:34 -0500
In-Reply-To: <D2B2862C.D155F%himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2016-01-06 at 17:00 +0000, Himanshu Madhani wrote:
> Hi Nic,
>=20
>=20
> On 12/20/15, 10:57 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> =
wrote:
>=20
> >Hi Himanshu & Co,
> >
> >On Thu, 2015-12-17 at 14:56 -0500, Himanshu Madhani wrote:
> >> Hi Nic,
> >>=20
> >> Please apply this series to target-pending at your earliest conven=
ience.
> >>=20
> >> changes from v1 -> v2
> >>=20
> >> o Added Reviewed-by tag for reviewed patches.
> >>=20
> >> o Dropped following patches for rework.
> >>   - qla2xxx: Change check_stop_free to always return 1
> >>   - qla2xxx: Fix interaction issue between qla2xxx and Target Core
> >>Module
> >>   - qla2xxx: Add TAS detection for kernel 3.15 n newer
> >>   - target/tmr: LUN reset cause cmd premature free.
> >>=20
> >
> >Thanks for dropping these for the moment.
> >
> >I'll be following up on outstanding TMR LUN_RESET reference counting
> >bugs over the holiday.
> >
> >> o Fixed patch description on following patches
> >>   - qla2xxx: Enable Extended Login support
> >>   - qla2xxx: Enable Exchange offload support.
> >>=20
> >> o Fixed patch description as well as kbuild warning for
> >>   - qla2xxx: Added interface to send explicit LOGO.
> >>=20
> >> o Fixed kbuild warning for
> >>   - qla2xxx: Remove dependency on hardware_lock to reduce lock
> >>     contention.
> >>=20

<SNIP>

> >
> >Applied patches #1 -> #14 + #16 to target-pending/for-next code.
> >
> >Adding commenting inline for patch #15.
> >
> >Thank you,
> >
> >--nab
>=20
> We need to rework patch #11 (=C2=B3qla2xxx: Add selective command que=
uing=C2=B2) to
> address review comments from Bart and Christoph.
> Can you please drop it from your queue. We=C2=B9ll send updated patch=
 once its
> ready.
>=20

No need to resend the whole patch.

Just address the comments with an incremental patch, and I'll fold into
the original when applying.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
