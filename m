From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: QLA2200 driver
Date: 25 Apr 2002 11:53:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3y9fbn5b2.fsf@trained-monkey.org>
References: <93F527C91A6ED411AFE10050040665D0049BF940@corpusmx1.us.dg.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: berthiaume_wayne@emc.com's message of "Thu, 25 Apr 2002 11:48:01 -0400"
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: ttonino@corp.home.nl, linux-scsi@vger.kernel.org

>>>>> ">" == berthiaume wayne <berthiaume_wayne@emc.com> writes:

>> 	Actually, we have been using the latest off the QLogic site
>> and referencing EMC customers to that driver as the one of
>> choice. They are referred to the EMC approved driver link. The
>> Rawhide is way out of date, thus one of the reasons to use what is
>> on the Qlogic site. The only modification we've had to make is to
>> the qlavendor.c to contain the definitions for EMC's unique SCSI
>> command set.

Sorry, but thats really scary to hear, unless of course you have a
special version thats totally rewamped compared to the one that Red
Hat has been shipping.

Please note that I am referring to Arjan's work on qla2200.c not
qla2x00.c!

Jes
