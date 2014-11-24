From: Markus Stockhausen <stockhausen@collogia.de>
Subject: ARCMSR - Notify sense data report - Lost patch?
Date: Mon, 24 Nov 2014 11:47:02 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C1FC8@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-1bef77fa-b713-4e91-9fd4-49cb7eac62c8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:60455 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752512AbaKXLw0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 06:52:26 -0500
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ching2048@areca.com.tw" <ching2048@areca.com.tw>, "thenzl@redhat.com" <thenzl@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-1bef77fa-b713-4e91-9fd4-49cb7eac62c8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,=0A=
=0A=
sorting out some diffs between the official Arcea driver and =0A=
the newest 3.18 patches I found a patch that might got lost:=0A=
=0A=
https://lkml.org/lkml/2014/2/20/956=0A=
=0A=
Could you check if that is desired?=0A=
=0A=
Thanks in advance.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-1bef77fa-b713-4e91-9fd4-49cb7eac62c8
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

------=_NextPartTM-000-1bef77fa-b713-4e91-9fd4-49cb7eac62c8--
