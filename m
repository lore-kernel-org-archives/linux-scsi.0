From: "Magnus Naeslund(w)" <mag@fbab.net>
Subject: ServeRAID SCSI device write-back
Date: Thu, 7 Oct 2004 11:08:12 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <64015.129.178.88.68.1097140092.squirrel@129.178.88.68>
Reply-To: mag@fbab.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from spectre.fbab.net ([212.214.165.139]:32129 "HELO mail2.fbab.net")
	by vger.kernel.org with SMTP id S267358AbUJGJIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 05:08:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have this ServeRAID 6 card that has a batterybacked writecache.
When i look in the IBM supplied manager interface i see that the _logical_
drive/partition has write-back enabled.
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

I appreciate any enlightening answers, I just don't want to toast my data :)

Please CC any replies me, as i'm using my webmail account right now.

Regards,
Magnus Naeslund

-- 
no .sig


