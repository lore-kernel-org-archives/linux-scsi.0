From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: QLA2200 driver
Date: 25 Apr 2002 09:56:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m31yd3opab.fsf@trained-monkey.org>
References: <93F527C91A6ED411AFE10050040665D0049BF939@corpusmx1.us.dg.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: berthiaume_wayne@emc.com's message of "Thu, 25 Apr 2002 09:40:40 -0400"
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: ttonino@corp.home.nl, linux-scsi@vger.kernel.org

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
