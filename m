From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Defect list size ?
Date: Wed, 16 Mar 2005 16:43:00 -0500
Message-ID: <200503162143.j2GLh5T08828@www.watkins-home.com>
References: <20050316194709.GA4444@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from rwcrmhc14.comcast.net ([216.148.227.89]:9118 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262825AbVCPVnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 16:43:12 -0500
In-Reply-To: <20050316194709.GA4444@bougret.hpl.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jt@hpl.hp.com, linux-scsi@vger.kernel.org

3060 seems low when you compare your disk's size to my 18 Gig disks!

I have 17 disks, 18 Gig each.

2112 entries (16896 bytes) in manufacturer table.
1902 entries (15216 bytes) in manufacturer table.
2048 entries (16384 bytes) in manufacturer table.
1304 entries (10432 bytes) in manufacturer table.
3461 entries (27688 bytes) in manufacturer table.
949 entries (7592 bytes) in manufacturer table.
1939 entries (15512 bytes) in manufacturer table.
2250 entries (18000 bytes) in manufacturer table.
1404 entries (11232 bytes) in manufacturer table.
2633 entries (21064 bytes) in manufacturer table.
1997 entries (15976 bytes) in manufacturer table.
1431 entries (11448 bytes) in manufacturer table.
1353 entries (10824 bytes) in manufacturer table.
1474 entries (11792 bytes) in manufacturer table.
1519 entries (12152 bytes) in manufacturer table.
1720 entries (13760 bytes) in manufacturer table.
1247 entries (9976 bytes) in manufacturer table.

My disks have been in use 24/7 for 1.5 years, some for 2.5 years.
My grown tables:
0 entries (0 bytes) in grown table.
0 entries (0 bytes) in grown table.
9 entries (72 bytes) in grown table.
5 entries (40 bytes) in grown table.
0 entries (0 bytes) in grown table.
12 entries (96 bytes) in grown table.
21 entries (168 bytes) in grown table.
0 entries (0 bytes) in grown table.
6 entries (48 bytes) in grown table.
0 entries (0 bytes) in grown table.
6 entries (48 bytes) in grown table.
29 entries (232 bytes) in grown table.
0 entries (0 bytes) in grown table.
2 entries (16 bytes) in grown table.
3 entries (24 bytes) in grown table.
4 entries (32 bytes) in grown table.
0 entries (0 bytes) in grown table.

Guy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jean Tourrilhes
Sent: Wednesday, March 16, 2005 2:47 PM
To: linux-scsi@vger.kernel.org
Subject: Defect list size ?

	Hi,

	What is a reasonable defect list size for an almost new disk
(3 weeks - 146 GB).
	scscinfo -d gives me :
--------------------------------------------
Data from Defect Lists
----------------------
3060 entries in manufacturer table.
...
[truncated]
--------------------------------------------
	Which is way more than my older and smaller disk. I'm
wondering if this is acceptable or if I have a bad disk.

	Thanks...

	Jean
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

