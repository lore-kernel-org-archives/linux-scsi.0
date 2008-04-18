From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: MPTSAS: ("activate status led" | "find disc") in external enclosure
Date: Fri, 18 Apr 2008 12:41:04 +0200
Message-ID: <20080418124104.9ca87130.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:43218 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYDRKkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 06:40:07 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 1B6AF4A8067
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2008 12:40:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 9411D939BB
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2008 12:40:04 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 5A9C0939B8
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2008 12:40:04 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hallo!

As some of you might already now I have to set up a (for us) bigger SAN=
 with Linux.
I'm simulating disc failure right now. To find a defective disc in the =
enclosure is unresolved yet.
I already had a look at several web pages and searched for it but witho=
ut luck.

The manual of the enclosure says (PROMISE VTRAK J610S):
-----------------------------------------------------------------------
LEDs                                 State
                | Dark     | Steady Green  | Flashing Green
Power/Activity* | No Drive | Drive Present | Activity
Status**        | HBA/RAID controller determines the LED behavior
[...]
** Refer to the user documentation for your HBA or RAID controller for =
this
   information.
-----------------------------------------------------------------------

Is there a standard way to lit the led in the enclosure with linux mean=
s or anything alike?
The enclosure does not tell the serial numbers of the included disc.
The HBA is an LSI SAS 3801X.


Thanks
Lars

--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
