From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Seagate Cheetah: Firmware, Bugs, Compatibility?
Date: Fri, 3 Jan 2003 05:54:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D4EB@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from petasus.fm.intel.com (petasus.fm.intel.com [10.1.192.37])
	by hermes.fm.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h03Dn3j08497
	for <linux-scsi@vger.kernel.org>; Fri, 3 Jan 2003 13:49:03 GMT
Received: from fmsmsxvs042.fm.intel.com (fmsmsxvs042.fm.intel.com [132.233.42.128])
	by petasus.fm.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.27 2002/10/16 23:46:59 dmccart Exp $) with SMTP id h03Dkif26591
	for <linux-scsi@vger.kernel.org>; Fri, 3 Jan 2003 13:46:44 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Shanker Balan' <shanu@exocore.com>, Linux-SCSI <linux-scsi@vger.kernel.org>

Shanu,

We also had some problems with those same Atlas drives from Maxtor/Quantum.
The B700 firmware seems to resolve the problems and we have been satisfied
with it.  

I have a Linux tool that should help you download the firmware images
successfully.  See http://scsirastools.sourceforge.net, and the tool is
named sgdskfl.  I put a copy of the B700 firmware out there and the firmware
update procedure is documented in the UserGuide.

Both Maxtor/Quantum and Seagate firmware images contain the model number of
the disks that they are intended to be compatible with inside the image
file.  sgdskfl checks the model number against the image itself for safety.

The Seagate firmware images I have I got via email from Seagate support.

Andy

-----Original Message-----
From: Shanker Balan [mailto:shanu@exocore.com] 
Sent: Friday, January 03, 2003 2:03 AM
To: Linux-SCSI
Subject: Seagate Cheetah: Firmware, Bugs, Compatibility?


Hello:

I recently wrote in to ask about the "Queued IO" errors I have been
experiencing on all 3 of my Quantum Atlas 10KIII drivers. According to
Justin, its a firmware problem and upgrading to the latest will
hopefully fix it.

Like Mikael Abrahamsson mentioned in the same thread, it has been next
to impossible to find any information on the firmware update procedure
and result thereof with the updates available on the Quantum FTP site:

ftp://ftpdownload.maxtor.com/pub/QuantumProducts/
Disk_Firmware/Atlas-10KIII/160/

Quantum support in India is next to impossible with vendors having a
"take it or leave it" kind of attitude and Quantum web support is yet to
get back to me on my query. Basically, I have burnt my fingers with the
Quantum.

Anyway, I need another SCSI hard disk for my cluster and the only other
brand available in the local market is the Seagate Cheetah ST318406LC.

Before I make the purchase (not that I have a choice here :( ), should I
be aware of any bugs/compatibility issues with this specific model? The
SCSI controller is a Adaptec AIC-7892A U160/m (rev 02).

Any specific firmware releases to avoid with the ST318406LC?

Thank you for your time.

-- Shanu
http://shankerbalan.com/

BTW: Any one have the URL to the Seagate firmware location?


-- 
Westheimer's Discovery:
	A couple of months in the laboratory can frequently save a
couple of hours in the library.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
