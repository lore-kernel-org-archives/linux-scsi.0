From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Wed, 2 Oct 2002 11:10:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Scott Merritt <Scsi@PragmaSoft.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org


I agree that Linux would be cleaner if auto-attach were optional.  I
hesitate to call that an artistic preference -- I think of it as
scientific.  Unattached is a valid, meaningful state, more primitive than
attached, so it should be possible for a device to come up to just that
state.

But when we speak of inhibiting partition table reading, I think that's
another (missing) feature:  I should be able to control whether Linux
considers there to be partitions on my disk or not (and change the fact
dynamically).  Note that just because the first sector contains something
that appears to be a partition table doesn't mean it is.  Then I can
imagine bringing up a disk in 3 stages: 1) initialize the SCSI low level
driver and identify the device at that level; 2) attach the device as a
SCSI disk; 3) create the partition devices (read the partition table).



