From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [Linux kernel LibSAS - Task Collector Mode]RE: [PATCH 1/5]
	mvsas : redesign the mvsas driver architecture.
Date: Wed, 11 Mar 2009 20:54:49 +0000
Message-ID: <1236804889.3270.97.camel@localhost.localdomain>
References: <49A3C100.8040005@marvell.com>
	 <1235495718.3204.37.camel@localhost.localdomain>
	 <37BE93F844A044459933732A80255042065E0A3A@sc-exch03.marvell.com>
	 <77B579C76B3DE742A499A2EF95859C1FFA61A0@sc-exch03.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42386 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbZCKUyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Mar 2009 16:54:54 -0400
In-Reply-To: <77B579C76B3DE742A499A2EF95859C1FFA61A0@sc-exch03.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Wang <qswang@marvell.com>
Cc: jgarzik@pobox.com, linux-scsi@vger.kernel.org, jeff@garzik.org, Andy Yan <ayan@marvell.com>

On Tue, 2009-03-03 at 16:27 -0800, Michael Wang wrote:
> Hi James,
>=20
> Could you please share your time to care about below issue? Thanks.
>=20
> give us some update for the Task Collector Modesupport of Linux
> kernel=E2=80=99s LibSAS?

I don't really have any to give.  Task collector mode was something
Luben implemented but never really made use of, so what's in the kernel
has never really been tested (or, indeed, implemented).

Personally, it's never been clear to me what the advantage of a task
collector mode over what the kernel currently does inside the block
layer actually is.

If you have any thoughts or requirements on this, posting them to the
list would be helpful since I don't think anyone else has really though=
t
about this, either.

A summary of the differences between the new and old mvsas driver would
be really helpful to me as well, please.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
