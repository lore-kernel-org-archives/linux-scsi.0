From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 14:26:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718122622.GD6520@marowsky-bree.de>
References: <B179AE41C1147041AA1121F44614F0B0598B10@AVEXCH02.qlogic.org> <20030718122304.A23013@infradead.org> <20030718121202.GC6520@marowsky-bree.de> <20030718131352.A26546@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:32745 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S265069AbTGRMLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 08:11:32 -0400
Content-Disposition: inline
In-Reply-To: <20030718131352.A26546@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

On 2003-07-18T13:13:52,
   Christoph Hellwig <hch@infradead.org> said:

> > Please come and attend the multipath session at the Kernel Summit a=
nd/or
> > the Ottawa Linux Symposium next week to learn why this is a bad ide=
a and
> > how it can be done better -> http://www.linuxsymposium.org/
> -ENOTIME :)

Well, I was inviting Andrew, mostly, I know that you are around for
KS/OLS and are also probably already convinced ;-)

> > QLogic is reasonably good already in that it can be disabled via a
> > module parameter (ql2xfailover=3D0), allowing the higher level solu=
tions
> > to operate.
> Given that this module never was in 2.4 I don't see clear backwards
> compatiblity problems..

You are being very funny. No, nobody ever shipped a qlogic driver.
Right.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
