From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: How does a SCSI device gets a target ID?
Date: Wed, 9 Mar 2005 23:38:53 -0500
Message-ID: <200503100438.j2A4cx519046@www.watkins-home.com>
References: <20050309172943.GB21986@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:26335 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262373AbVCJEjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 23:39:11 -0500
In-Reply-To: <20050309172943.GB21986@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <matthew@wil.cx>
Cc: "'Rajat  Jain, Noida'" <rajatj@noida.hcltech.com>, linux-scsi@vger.kernel.org

You said:
"And plugging any SE device onto an LVD bus causes the whole bus to fall
back to SE.  This includes terminators."

True, but if your terminator is LVD only, it will get hot!!!  Not sure if it
can be damaged, but it does get hot (or warm). :)

I also believe some LVD devices do not support SE.

Guy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Matthew Wilcox
Sent: Wednesday, March 09, 2005 12:30 PM
To: Guy
Cc: 'Rajat Jain, Noida'; linux-scsi@vger.kernel.org
Subject: Re: How does a SCSI device gets a target ID?

On Wed, Mar 09, 2005 at 11:54:57AM -0500, Guy wrote:
> A narrow SCSI bus will support 8 devices.
> A wide SCSI bus will support 16 devices.
> A narrow bus uses 50 pins.
> A wide bus uses 68 pins.

We need a SCSI Wiki for all this kind of information ... maybe Wikipedia?

> There is a standard for auto selecting the SCSI ID.  I have never used
this.
> SCAM (SCSI Configures Auto Magically).

I think the SCSI vendors prefer to sell SCA drives rather than SCAM
drives ;-) Drives with the SCA connector have power supplied to them and
their SCSI ID configured automatically depending on which slot they're
plugged into.  If you're doing hotplug SCSI, it's probably with SCA drives.

> Mixing devices with different electrical standards can be tricky.  Some
> can't be mixed.  HVD is not compatible with any other.

And plugging any SE devince onto an LVD bus causes the whole bus to fall
back to SE.  This includes terminators.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

