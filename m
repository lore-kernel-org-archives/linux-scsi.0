From: berthiaume_wayne@emc.com
Subject: RE: QLA2200 driver
Date: Thu, 25 Apr 2002 11:48:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BF940@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: jes@wildopensource.com
Cc: ttonino@corp.home.nl, linux-scsi@vger.kernel.org

	Actually, we have been using the latest off the QLogic site and
referencing EMC customers to that driver as the one of choice. They are
referred to the EMC approved driver link. The Rawhide is way out of date,
thus one of the reasons to use what is on the Qlogic site. The only
modification we've had to make is to the qlavendor.c to contain the
definitions for EMC's unique SCSI command set.

-----Original Message-----
From: Jes Sorensen [mailto:jes@wildopensource.com]
Sent: Thursday, April 25, 2002 9:56 AM
To: berthiaume_wayne@emc.com
Cc: ttonino@corp.home.nl; linux-scsi@vger.kernel.org
Subject: Re: QLA2200 driver


>>>>> ">" == berthiaume wayne <berthiaume_wayne@emc.com> writes:

>> 	The qla2x00 driver is not in the Linus tree; however, if you
>> pull down a Red Hat tree you'll find it is in there. QLogic
>> maintains the driver and, perhaps, just hasn't gotten around to
>> submitting it to Marcello, Linus, et al for inclusion in the
>> LSB. Duane ol' buddy are you listening????  =;^)

Or maybe the driver you're referring to is such a mess that it would
never be included in the official kernel.

Arjan is trying to clean it up (similarly to what I did to the qla1280
driver) but it's still got some way to go. If you want to play with
it, your best bet is to pull Arjan's qla2200 driver out of the Red Hat
Rawhide .src.rpm.

Jes
