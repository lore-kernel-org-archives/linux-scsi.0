From: "Augustine Ortiz, Jr." <aortizjr@lanl.gov>
Subject: Getting HD Serial Numbers in RAID
Date: Tue, 31 Aug 2004 13:45:23 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093981522.27891.20.camel@afgar.lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi...

I have been working on getting serial numbers electronically off of hard
drives for various reasons.

I have been successful with IDE and most SCSI drives (using hdparm and
scsiinfo). However I am running into trouble with ones that are on
AACRAID/PERC3 adaptors and actually in a RAID array.

The only serial number I can seem to grab is the one for the entire
volume which is just assigned.

Are there any tools available to get the serial number off the drives in
the array? Or can I get some pointers on writing such a tool?

Thank you.

Augustine

