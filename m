From: berthiaume_wayne@emc.com
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 12:44:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BF8D8@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hbryan@us.ibm.com
Cc: linux-scsi@vger.kernel.org

	VLUN = virtual LUN   

	This would be the number assigned by the storage system. A storage
system can be broken up into multiple virtual storage systems each unique to
the owner. The real trick is when to virtual storage systems share the same
LUN. Depending on the order of entry into the virtual storage array on a
CLARiiON at the time it is being configured it could be a LUN 1 to your
virtual storage and LUN 6 on mine.

-----Original Message-----
From: Bryan Henderson [mailto:hbryan@us.ibm.com]
Sent: Wednesday, April 10, 2002 11:28 AM
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org
Subject: RE: [RFC] Persistent naming of scsi devices



>I believe that if you are sharing a VLUN on the array the
>same WWNN/WWPN is assigned to it. Though it may be represented to you as
>VLUN 1 in your virtual storage system and VLUN 6 in mine I thought the
same
>WWNN/WWPN was assigned to it.

Yes, every system I've seen does that and it seems to be the intent (for
whatever that's worth) of the fibre channel architects.  But how is that
relevant?  We're talking about uniquely identifying a logical unit (which
is what would appear in Linux as a device).

I don't know what a VLUN is, so maybe I'm just lost.  Isn't that redundant?
Virtual and logical are the same thing.

Leave the WWPN (worldwide port number) out of it, by the way.  That doesn't
help identify devices, just ports that can be used to reach them.

