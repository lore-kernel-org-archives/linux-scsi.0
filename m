From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Why REPORT LUN only for SCSI-2?
Date: Tue, 15 Jul 2003 16:18:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F140D30.D2B5C4D8@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:27441 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S267773AbTGOOBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2003 10:01:21 -0400
Received: from trulli.pdb.fsc.net ([172.25.96.53])
	by plim.fujitsu-siemens.com (8.11.3/8.11.3) with ESMTP id h6FEGAG11580
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2003 16:16:10 +0200
Received: from fujitsu-siemens.com (bounty.pdb.fsc.net [172.25.253.16])
	by trulli.pdb.fsc.net (8.11.6/8.11.6) with ESMTP id h6FEG9d22431
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2003 16:16:09 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Ist there a hard reason not to allow the REPORT LUNS command for SCSI-2
devices?
Are there actually some SCSI-2 devices which break on this command?

There are several devices (e.g. RAID) which tread carefull and claim
only SCSI-2 compliancy but support REPORT LUNS. It would make life
easier with these if REPORT LUNS would be generally available.
Eg I have a box which will happily accept INQUIRYs on LUNs 0-7 but
REPORT LUNS returns only the 4 configured LUNs.

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
