From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: ServeRAID SCSI device write-back
Date: Thu, 7 Oct 2004 07:38:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F019868B8B@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:29113 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269796AbUJGLia convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 07:38:30 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: mag@fbab.net
Cc: linux-scsi@vger.kernel.org


The Write Cache you are referring to in the ServeRAID Manager is a
feature on the adapter itself and is not the same thing you are
displaying with scsiinfo.   

Yes, it is definitely good to have the adapter Write Cache turned on
when the adapter has battery backup.

IpsLinux 


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Magnus
Naeslund(w)
Sent: Thursday, October 07, 2004 5:08 AM
To: linux-scsi@vger.kernel.org
Subject: ServeRAID SCSI device write-back 

I have this ServeRAID 6 card that has a batterybacked writecache.
When i look in the IBM supplied manager interface i see that the
_logical_ drive/partition has write-back enabled.
When i issue scsiinfo -c /dev/sda on the 2.6 system i get:

 Data from Caching Page
 ----------------------
 Write Cache                        0
 Read Cache                         1
 Prefetch units                     0
 Demand Read Retention Priority     0
 Demand Write Retention Priority    0
 Disable Pre-fetch Transfer Length  2060
 Minimum Pre-fetch                  0
 Maximum Pre-fetch                  0
 Maximum Pre-fetch Ceiling          0

So it looks like the write cache isn't used?
As i understand it, it should be safe for me to turn on write cache when
it's batterybacked, right?
Since it's a RAID card presenting itself as a scsi card, i'm not so sure
if the write-back is internally handled (just returning immediatly if
queue isn't full) or if i should turn this on the linux side for it to
take advantage of the cache.

I appreciate any enlightening answers, I just don't want to toast my
data :)

Please CC any replies me, as i'm using my webmail account right now.

Regards,
Magnus Naeslund

--
no .sig


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

