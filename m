From: Jean-Max Reymond <jmreymond@ckr-solutions.com>
Subject: Re: no disk drive detected at boot time
Date: Fri, 12 Jan 2007 15:00:48 +0100
Message-ID: <45A79490.8050309@ckr-solutions.com>
References: <45A61B53.1040700@ckr-solutions.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010002010803030406070106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:52101 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXALOBE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jan 2007 09:01:04 -0500
Received: from [192.168.0.32] (pbp87.dyndns.org [82.243.162.80])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 1C37E54CD
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2007 15:01:01 +0100 (CET)
In-Reply-To: <45A61B53.1040700@ckr-solutions.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010002010803030406070106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Jean-Max Reymond a écrit :
> hi,
> The computer is an DELL 1600SC with SATA RAID.
> At boot time, no disk are detected.
> I have tried with Ubuntu Edgy and Fedora Core 6 and I have the same 
> troubles. Fedora Core 2 is running on the computer.
> it seems that Dell CERC ATA100/4ch is not supported by any driver.
> see
> http://www.mail-archive.com/debian-kernel@lists.debian.org/msg20989.html
> 
> 

the output of dmesg when running Fedora Core 2
megaraid is nicely found

megaraid: found 0x101e:0x1960:bus 1:slot 2:func 0
scsi3:Found MegaRAID controller at 0xe0822000, IRQ:201
megaraid: [6.62:1.03] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: channel[2] is raid.
megaraid: channel[3] is raid.
scsi3 : LSI Logic MegaRAID 6.62 254 commands 16 targs 7 chans 7 luns
scsi3: scanning scsi channel 0 for logical drives.
   Vendor: MegaRAID  Model: LD 0 RAID5  714G  Rev: 6.62
   Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 1464287232 512-byte hdwr sectors (749715 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 1464287232 512-byte hdwr sectors (749715 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
  sda: sda1 sda2 sda3 sda4 < sda5 >
Attached scsi disk sda at scsi3, channel 0, id 0, lun 0
scsi3: scanning scsi channel 1 for logical drives.
scsi3: scanning scsi channel 2 for logical drives.
scsi3: scanning scsi channel 4 [P0] for physical devices.
scsi3: scanning scsi channel 5 [P1] for physical devices.
scsi3: scanning scsi channel 6 [P2] for physical devices.
scsi3: scanning scsi channel 7 [P3] for physical devices

--------------010002010803030406070106
Content-Type: text/x-vcard; charset=utf-8;
 name="jmreymond.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jmreymond.vcf"

begin:vcard
fn:Jean-Max Reymond
n:Reymond;Jean-Max
org:CKR Solutions Open Source
email;internet:jmreymond@ckr-solutions.com
title:Responsable technique
tel;work:08 71 03 25 11
tel;fax:08 21 74 92 65
tel;cell:06 16 94 25 11
note:jabber: jmreymond@jabber.fr
x-mozilla-html:FALSE
url:http://www.ckr-solutions.com
version:2.1
end:vcard


--------------010002010803030406070106--
