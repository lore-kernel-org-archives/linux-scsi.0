From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: AW: ARCMSR - Notify sense data report - Lost patch?
Date: Mon, 24 Nov 2014 18:25:57 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C23F4@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C1FC8@EXCHANGE.collogia.de>,<20141124132331.GA4179@infradead.org>
 <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C20B0@EXCHANGE.collogia.de>,<5473451C.1040400@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-367c1726-3eb8-4de4-b746-beb9ac93eb3c"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:16606 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751537AbaKXS0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 13:26:23 -0500
In-Reply-To: <5473451C.1040400@redhat.com>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@infradead.org>, "ching2048@areca.com.tw" <ching2048@areca.com.tw>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-367c1726-3eb8-4de4-b746-beb9ac93eb3c
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Tomas Henzl [thenzl@redhat.com]=0A=
> Gesendet: Montag, 24. November 2014 15:47=0A=
> An: Markus Stockhausen; Christoph Hellwig=0A=
> Cc: ching2048@areca.com.tw; linux-scsi@vger.kernel.org=0A=
> Betreff: Re: AW: ARCMSR - Notify sense data report - Lost patch?=0A=
> =0A=
> On 11/24/2014 02:45 PM, Markus Stockhausen wrote:=0A=
> >> Von: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.or=
g]&quot; im Auftrag von &quot;Christoph Hellwig [hch@infradead.org]=0A=
> >> Gesendet: Montag, 24. November 2014 14:23=0A=
> >> An: Markus Stockhausen=0A=
> >> Cc: ching2048@areca.com.tw; thenzl@redhat.com; linux-scsi@vger.kernel.=
org=0A=
> >> Betreff: Re: ARCMSR - Notify sense data report - Lost patch?=0A=
> >>=0A=
> >> On Mon, Nov 24, 2014 at 11:47:02AM +0000, Markus Stockhausen wrote:=0A=
> >>> Hi,=0A=
> >>>=0A=
> >>> sorting out some diffs between the official Arcea driver and=0A=
> >>> the newest 3.18 patches I found a patch that might got lost:=0A=
> >>>=0A=
> >>> https://lkml.org/lkml/2014/2/20/956=0A=
> >>>=0A=
> >>> Could you check if that is desired?=0A=
> >> Looks sensible to me.  Did you test it?=0A=
> > No not really, as I don't know how. We had a controller crash the last=
=0A=
> > week and I was wondering about the differences between vendor and=0A=
> > upstream version. So I basically did some code comparison between=0A=
> > the two source. Besides a lot of layout differences and other hacks=0A=
> > this was one of the first things I noticed and wondered what difference=
=0A=
> > those flags could make. Especially regarding stability.=0A=
> >=0A=
> > Hopefully Ching and/or Tomas know better as they seem repsonsible=0A=
> > for the rest of the 3.18 arcmsr patches.=0A=
> =0A=
> I don't know why Ching hasn't re-posted this in later series.=0A=
> The Areca in-house driver works stable?=0A=
=0A=
Sorry - No idea. We are on a stock kernel (3.10 longterm no vendor driver) =
=0A=
and have to decide which way to go ... Sadly quite limited test possibilite=
s. =0A=
None of the two options feels 100% comfortable.=0A=
=0A=
@Ching: Does any of the patches fit for stable?=0A=
=0A=
Markus=
------=_NextPartTM-000-367c1726-3eb8-4de4-b746-beb9ac93eb3c
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-367c1726-3eb8-4de4-b746-beb9ac93eb3c--
