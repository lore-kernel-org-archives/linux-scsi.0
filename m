From: braver@pobox.com (Alexy Khrabrov)
Subject: Wide negotiation fails with 80->68 LVD adapter?
Date: Mon, 21 Oct 2002 01:14:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210210514.g9L5ElYp006401@angle.badbox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Greetings -- did anybody try to connect a SCSI SCA
hard drive (with 80 pins) to an Adaptec 7899
Ultra160 with 65 pins?  Mine seems unable to spin
them at 160 Mbps.

I'm running Linux, Suse 7.2 _ many upgrades,
kernel 2.4.20-pre9, with Adaptec 7899, v25113 in
SCSISelect.  My system came with a Barracuda ...LW
drive, 68 pin, and it was always working fine in
160 Mbps mode.

A week ago, I got some more Barracudas on ebay, those
were SCA ones, ...LC, so I got an 80->68 LVD adapter.
Here it is, I guess there's only one, as everybody
resells this one:

http://www.scsistuff.com/106-0067.htm

Here's the Barracuda:
http://www.seagate.com/support/disc/specs/scsi/st150176lc.html
Strangely, it comes up as SX..., not ST..., in
Adaptec's bootup.

I set only the SCSI IDs on my Barracudas.  OK.

The first thing after Dell splash which comes during
boot is SCSI list, and my good ol' LW Barracuda comes
up first ith SCSI 0 and 160 speed.  Good.  But the two
new ones came up as ASYN!  SCSISelect would hang, with
SCSI device 1 (a new Barracuda) LED lit, until I
switched them in SCSIselect to ASYN.  And then they
negotiated a wonderful speed of 6.6 Mbps, just above
my dds tape...

Since the idea for these was to keep my DVD images,
5 GB each, waiting was not an option -- and the best
thing I could do is to disable Wide Negotiation, => OFF,
and choose maximum 40 Mbps in SCSIselect for the LCs.
Works, but now I wonder what should I do to spin them
at 160?  Is it

-- Adaptec 7899 firmare/Dell BIOS?
-- 80->68 adapter settings (looks like none is needed,
   setting SYN jumper did nothing, looks like it's a
   different kind of syncing -- for spindles)
-- Barracuda's jumpers (now that adapter takes over ID,
   I wonder if any other would matter; and ddefaults are
   to be the fastest)
-- Linux aic7xxx driver
-- Linux higher-level SCSI driver(s)?
-- Something else is fishy?

Any hints would be highly appreciated!

Cheers,
Alexy
