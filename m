From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G)
 SAS cards
Date: Thu, 11 Jun 2009 11:52:34 +0400
Message-ID: <4A30B7C2.3020303@vlnb.net>
References: <49E4B6D5.9060007@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103AC1E41@CORPUSMX50C.corp.emc.com> <4A2D2E8F.6090207@vlnb.net> <D27CA15508148C428A25104ADEFAAC8103BB6034@CORPUSMX50C.corp.emc.com> <5FF020A1CFFEEC49BD1E09530C4FF595714E369F@SC-VEXCH1.marvell.com> <4A2FFE26.5050408@vlnb.net> <5FF020A1CFFEEC49BD1E09530C4FF595714E3DF1@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:61936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbZFKHwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2009 03:52:47 -0400
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF595714E3DF1@SC-VEXCH1.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: "Foster_Brian@emc.com" <Foster_Brian@emc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

Andy Yan, on 06/11/2009 05:11 AM wrote:
> No, enable target mode and then add LUN.

Why to have the race window open?

Vlad

> -----Original Message-----
> From: Vladislav Bolkhovitin [mailto:vst@vlnb.net]=20
> Sent: 2009=E5=B9=B46=E6=9C=8811=E6=97=A5 2:41
> To: Andy Yan
> Cc: Foster_Brian@emc.com; linux-scsi@vger.kernel.org; scst-devel@list=
s.sourceforge.net; James.Bottomley@HansenPartnership.com
> Subject: Re: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and=
 88SE94xx(6G) SAS cards
>=20
> Andy Yan, on 06/09/2009 05:27 AM wrote:
>> Brian,
>> Please set unique SAS address for each SAS port of target controller=
,
>> and make sure you do correct connection, you can get the SAS address=
 of
>> attaching device from "attach sas address ".Then enable target mode =
and
>> add target LUN.
>=20
> Do you mean "add target LUN and then enable target mode"? Otherwise a=
n=20
> initiator can connect while there are no LUNs configured on the targe=
t=20
> and confused by it.
>=20
>> Regards
>> Andy Yan

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
