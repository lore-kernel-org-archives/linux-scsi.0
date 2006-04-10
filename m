From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aaccli - adding a disk to an existing container...
Date: Mon, 10 Apr 2006 09:13:06 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0255FB76@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:26810 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1750939AbWDJNNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2006 09:13:08 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: toby@digitalmischief.co.uk, linux-scsi@vger.kernel.org

You need to contact Adaptec Technical Support, or read the Adaptec
Documentation regarding array expansion. Please note that aaccli is no
longer supported and has been replaced by arcconf.

The array size for a RAID-5 is (n-1)*slice size. The new size is not
available until the build has completed, during that time it appears
that aaccli is reporting what it can to justify the older size with the
newer physical components while in this transitional state. I am unsure
of the operation of the /extend_fs switch for aaccli, I believe it is
only for the windoze file system; the actions you take under Linux will
be incantations around fdisk(8).

If I were you, I'd wait for the build to complete before worrying, it
has already started and any other actions you take until it is completed
could affect the integrity of the data. If the data is unimportant, just
build a fresh 4 drive RAID-5 and you can use the disk space immediately
;->

Sincerely -- Mark Salyzyn


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Toby Moxham
> Sent: Monday, April 10, 2006 8:15 AM
> To: linux-scsi@vger.kernel.org
> Subject: aaccli - adding a disk to an existing container...
> 
> 
> 
> 
> 
> Hi,
> 
> I have an Adaptec 2610SA sata raid card I inititally 
> configured it with 3x
> 300gb drives in a Raid 5 configuration. I now have added another 300gb
> drive.
> 
> Using AAC CLI in Slackware linux... i have issued the command 
> container
> reconfigure 0 (0,3,0) to add the fourth disk to the array, It 
> is currently
> in progress in doing this .
> 
> however when i now do container list i get this :-
> 
> Executing: container list
> Num          Total  Oth Chunk          Scsi   Partition
> Label Type   Size   Ctr Size   Usage   B:ID:L Offset:Size
> ----- ------ ------ --- ------ ------- ------ -------------
>  0    Reconf  558GB            Open
>  /dev/sda             RAID_ARRAY
> 62    RAID-5  558GB       64KB None    0:00:0 64.0KB: 186GB
>                                                0:01:0 64.0KB: 186GB
>                                                0:02:0 64.0KB: 186GB
>                                                0:03:0 64.0KB: 186GB
> 
> I assume that what has happened is that the 558GB array is 
> being distributed
> across the four disks. (or is it because the task is still in 
> progress?)
> 
> However i also want to grow the size of the array to max of 
> the four disks.
> (rather than leaving free space on each disk)
> 
> Do i need to use /extend_fs switch (looks as thought this is only for
> windows) or do i need to use the partition resize.
> 
> Any help would be appreciated.
> 
> Thanks
> Toby Moxham
> --
> No virus found in this outgoing message.
> Checked by AVG Free Edition.
> Version: 7.1.385 / Virus Database: 268.4.0/306 - Release 
> Date: 09/04/2006
> 
> --
> No virus found in this outgoing message.
> Checked by AVG Free Edition.
> Version: 7.1.385 / Virus Database: 268.4.0/306 - Release 
> Date: 09/04/2006
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
