From: "Toby Moxham" <toby@digitalmischief.co.uk>
Subject: aaccli - adding a disk to an existing container...
Date: Mon, 10 Apr 2006 13:14:59 +0100
Message-ID: <GMEELKCDNAFPAFHNHKIMOEKLCFAA.toby@digitalmischief.co.uk>
Reply-To: <toby@digitalmischief.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from greenwood.uk-noc.com ([83.223.98.60]:38585 "EHLO
	greenwood.uk-noc.com") by vger.kernel.org with ESMTP
	id S1751151AbWDJMPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 08:15:25 -0400
Received: from digitalm.plus.com ([80.229.80.244] helo=tobymain)
	by greenwood.uk-noc.com with smtp (Exim 4.52)
	id 1FSvIS-0000d8-WA
	for linux-scsi@vger.kernel.org; Mon, 10 Apr 2006 13:15:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org




Hi,

I have an Adaptec 2610SA sata raid card I inititally configured it with 3x
300gb drives in a Raid 5 configuration. I now have added another 300gb
drive.

Using AAC CLI in Slackware linux... i have issued the command container
reconfigure 0 (0,3,0) to add the fourth disk to the array, It is currently
in progress in doing this .

however when i now do container list i get this :-

Executing: container list
Num          Total  Oth Chunk          Scsi   Partition
Label Type   Size   Ctr Size   Usage   B:ID:L Offset:Size
----- ------ ------ --- ------ ------- ------ -------------
 0    Reconf  558GB            Open
 /dev/sda             RAID_ARRAY
62    RAID-5  558GB       64KB None    0:00:0 64.0KB: 186GB
                                               0:01:0 64.0KB: 186GB
                                               0:02:0 64.0KB: 186GB
                                               0:03:0 64.0KB: 186GB

I assume that what has happened is that the 558GB array is being distributed
across the four disks. (or is it because the task is still in progress?)

However i also want to grow the size of the array to max of the four disks.
(rather than leaving free space on each disk)

Do i need to use /extend_fs switch (looks as thought this is only for
windows) or do i need to use the partition resize.

Any help would be appreciated.

Thanks
Toby Moxham
--
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.385 / Virus Database: 268.4.0/306 - Release Date: 09/04/2006

--
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.385 / Virus Database: 268.4.0/306 - Release Date: 09/04/2006

