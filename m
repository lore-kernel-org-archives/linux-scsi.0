From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 08:28:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8ECE757A.1F2E8851-ON87256B97.00543CAF@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org


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


