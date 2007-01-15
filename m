From: Jean-Max Reymond <jmreymond@ckr-solutions.com>
Subject: Re: no disk drive detected at boot time
Date: Mon, 15 Jan 2007 11:44:41 +0100
Message-ID: <45AB5B19.1070901@ckr-solutions.com>
References: <45A61B53.1040700@ckr-solutions.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080209050605080101060803"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3-g19.free.fr ([212.27.42.29]:40897 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204AbXAOKop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jan 2007 05:44:45 -0500
Received: from [192.168.0.32] (pbp87.dyndns.org [82.243.162.80])
	by smtp3-g19.free.fr (Postfix) with ESMTP id E7CDB4A26A
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2007 11:44:43 +0100 (CET)
In-Reply-To: <45A61B53.1040700@ckr-solutions.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080209050605080101060803
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
no answers ?
here is the report of cat /proc/scsi/scsi :

Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD 0 RAID5  714G Rev: 6.62
  Type:   Direct-Access                    ANSI SCSI revision: 02

does it exist a recent patch ?
thanks for your tips

--------------080209050605080101060803
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


--------------080209050605080101060803--
