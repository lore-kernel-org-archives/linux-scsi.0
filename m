From: "Toby Moxham" <toby@digitalmischief.co.uk>
Subject: RE: aaccli - adding a disk to an existing container...
Date: Mon, 10 Apr 2006 14:26:11 +0100
Message-ID: <GMEELKCDNAFPAFHNHKIMGEKMCFAA.toby@digitalmischief.co.uk>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0255FB76@otce2k03.adaptec.com>
Reply-To: <toby@digitalmischief.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from greenwood.uk-noc.com ([83.223.98.60]:52946 "EHLO
	greenwood.uk-noc.com") by vger.kernel.org with ESMTP
	id S1750991AbWDJN0R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 09:26:17 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F0255FB76@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org

Hi Mark,

Thanks for the responce, i will wait for the process to finish (which looks
as thought it make take a day or two!) and see what it reports then. I have
looked throught the adaptec documentation and this is very little concerning
expansion.

Thanks for the help!

Toby

-----Original Message-----
From: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com]
Sent: 10 April 2006 14:13
To: toby@digitalmischief.co.uk; linux-scsi@vger.kernel.org
Subject: RE: aaccli - adding a disk to an existing container...


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


--
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.385 / Virus Database: 268.4.0/306 - Release Date: 09/04/2006

--
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.385 / Virus Database: 268.4.0/306 - Release Date: 09/04/2006

