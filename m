From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Partition information lost on reboot.
Date: Fri, 10 Aug 2007 14:30:36 +0200
Message-ID: <6bffcb0e0708100530u6087a963re61dddd8f48eb630@mail.gmail.com>
References: <2e1f41c80708100517y736b8cd7xaebed333a0748a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:65089 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbXHJMah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 08:30:37 -0400
Received: by rv-out-0910.google.com with SMTP id k20so669333rvb
        for <linux-scsi@vger.kernel.org>; Fri, 10 Aug 2007 05:30:36 -0700 (PDT)
In-Reply-To: <2e1f41c80708100517y736b8cd7xaebed333a0748a3@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jegadeesh <kovaiteam@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@adaptec.com

[Adding linux-scsi and Adaptec support to CC]

On 10/08/07, Jegadeesh <kovaiteam@gmail.com> wrote:
> Hi,
>
> I have a scsi disk on Adaptec ASC-29320 U320. I have created a linux
> partition and ext3 filesystem over it.
> Now the problem is, whenever the machine is rebooted, the partition
> information to the OS is lost and I get an error saying it as a not valid
> block device.
> But fdisk tool shows the partitions, but "cat /proc/partitions" doesnt have
> this. I need to do a "partprobe" and then have to mount it explicitly.
>
> What could be causing this problem. Given below are some of the command
> outputs.
>
> # uname -a
> Linux pr.vionline.net 2.6.18-1.2798.fc6 #1 SMP Mon Oct 16 14:37:32 EDT 2006
> i686 i686 i386 GNU/Linux
>
> # mount /dev/sda1 /disk1
> mount: /dev/sda1 is not a valid block device
>
> # fdisk -l /dev/sda
>
> Disk /dev/sda: 73.4 GB, 73407900160 bytes
> 255 heads, 63 sectors/track, 8924 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Device Boot Start End Blocks Id System
> /dev/sda1 1 7417 59577021 83 Linux
> /dev/sda2 7418 8924 12104977+ 83 Linux
>
> # cat /proc/partitions
> major minor #blocks name
>
> 3 0 60051600 hda
> 3 1 409626 hda1
> 3 2 10482412 hda2
> 3 3 10482412 hda3
> 3 4 1 hda4
> 3 5 10482381 hda5
> 3 6 2096451 hda6
> 3 7 2096451 hda7
> 3 8 2096451 hda8
> 8 0 71687402 sda
>
> Thanks
> -Jag
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
