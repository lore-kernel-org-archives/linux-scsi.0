From: Jean-Max Reymond <jmreymond@ckr-solutions.com>
Subject: no disk drive detected at boot time
Date: Thu, 11 Jan 2007 12:11:15 +0100
Message-ID: <45A61B53.1040700@ckr-solutions.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010304020102000104070103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix1-g20.free.fr ([212.27.60.42]:46450 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030277AbXAKLMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 06:12:19 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 00388797181
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 12:12:18 +0100 (CET)
Received: from [192.168.0.32] (pbp87.dyndns.org [82.243.162.80])
	by smtp1-g19.free.fr (Postfix) with ESMTP id 584A69B6B4
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 12:11:17 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010304020102000104070103
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

hi,
The computer is an DELL 1600SC with SATA RAID.
At boot time, no disk are detected.
I have tried with Ubuntu Edgy and Fedora Core 6 and I have the same troubles. Fedora Core 2 is running on the computer.
it seems that Dell CERC ATA100/4ch is not supported by any driver.
see
http://www.mail-archive.com/debian-kernel@lists.debian.org/msg20989.html



--------------010304020102000104070103
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


--------------010304020102000104070103--
