From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Getting HD Serial Numbers in RAID
Date: Tue, 31 Aug 2004 16:36:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408312036.i7VKan311353@watkins-home.com>
References: <1093981522.27891.20.camel@afgar.lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1093981522.27891.20.camel@afgar.lanl.gov>
To: "'Augustine Ortiz, Jr.'" <aortizjr@lanl.gov>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When I have used hardware RAID, the vender supplies software that will do
what you want.  But it is tied to the vender's hardware, not general.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Augustine Ortiz, Jr.
Sent: Tuesday, August 31, 2004 3:45 PM
To: linux-raid@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Getting HD Serial Numbers in RAID

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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

