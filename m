From: "Michael Wang" <qswang@marvell.com>
Subject: RE: [Linux kernel LibSAS - Task Collector Mode]RE: [PATCH 1/5]mvsas : redesign the mvsas driver architecture.
Date: Thu, 12 Mar 2009 08:42:35 -0700
Message-ID: <77B579C76B3DE742A499A2EF95859C1F0100986C@sc-exch03.marvell.com>
References: <49A3C100.8040005@marvell.com> <1235495718.3204.37.camel@localhost.localdomain> <37BE93F844A044459933732A80255042065E0A3A@sc-exch03.marvell.com> <77B579C76B3DE742A499A2EF95859C1FFA61A0@sc-exch03.marvell.com> <1236804889.3270.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:10810 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754590AbZCLPmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 11:42:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1236804889.3270.97.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: jgarzik@pobox.com, linux-scsi@vger.kernel.org, jeff@garzik.org, Andy Yan <ayan@marvell.com>

Hi James,
Thanks for your response.

And for mvsas, we're still in development, and try to find a better way=
 to commit to kernel based on your previously suggestions. FYI


Michael Wang

-----Original Message-----
=46rom: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]=20
Sent: 2009=C4=EA3=D4=C212=C8=D5 4:55
To: Michael Wang
Cc: jgarzik@pobox.com; linux-scsi@vger.kernel.org; jeff@garzik.org; And=
y Yan
Subject: RE: [Linux kernel LibSAS - Task Collector Mode]RE: [PATCH 1/5]=
mvsas : redesign the mvsas driver architecture.

On Tue, 2009-03-03 at 16:27 -0800, Michael Wang wrote:
> Hi James,
>=20
> Could you please share your time to care about below issue? Thanks.
>=20
> give us some update for the Task Collector Modesupport of Linux=20
> kernel=A1=AFs LibSAS?

I don't really have any to give.  Task collector mode was something Lub=
en implemented but never really made use of, so what's in the kernel ha=
s never really been tested (or, indeed, implemented).

Personally, it's never been clear to me what the advantage of a task co=
llector mode over what the kernel currently does inside the block layer=
 actually is.

If you have any thoughts or requirements on this, posting them to the l=
ist would be helpful since I don't think anyone else has really thought=
 about this, either.

A summary of the differences between the new and old mvsas driver would=
 be really helpful to me as well, please.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
