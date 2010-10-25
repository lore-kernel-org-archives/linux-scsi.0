From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 15:56:47 +0200
Message-ID: <20101025135647.GA14302@apartia.fr>
References: <20101023095816.GA19791@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com>
 <20101025131937.GA6605@apartia.fr>
 <20101025154705.73d49860@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:39812 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0JYN4s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 09:56:48 -0400
Received: from sylla.apartia.fr (sylla.apartia.fr [10.0.3.3])
	by zenon.apartia.fr (Postfix) with ESMTP id BB27B424A6009
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 15:56:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20101025154705.73d49860@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Oct 25, 2010 at 03:47:05PM +0200, Emmanuel Florac wrote:
> Le Mon, 25 Oct 2010 15:19:37 +0200
> Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org> =E9criva=
it:
>=20
> > Could you tell me what LSI app do I need? Does it run under Linux?
> >=20
>=20
> It's called MegaCli. Find it here :
>=20
> http://www.lsi.com/storage_home/products_home/internal_raid/megaraid_=
sas/megaraid_sas_8888elp/index.html#Miscellaneous
>=20

OK, I installed it and tried:

	MegaCli64 -AdpSetProp -EnableJBOD -1 -aALL

but this seems to do nothing (maybe after reboot?), and

	MegaCli64 -PDMakeJBOD -PhysDrv 0:0 -aAll

gives this error (tried most permutations):

	Invalid input at or near token 0=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
