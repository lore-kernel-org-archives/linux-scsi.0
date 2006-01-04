From: "Deniss" <denis@msh.lv>
Subject: aic94xx linux driver
Date: Wed, 4 Jan 2006 18:54:06 +0200
Message-ID: <001501c6114f$7a6c3c00$520c220a@vugd.gov.lv>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-4";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.msh.lv ([195.13.249.130]:55627 "EHLO mail.msh.lv")
	by vger.kernel.org with ESMTP id S932550AbWADQy2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 11:54:28 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.msh.lv (mailer) with ESMTP id C6955A400B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jan 2006 18:54:09 +0200 (EET)
Received: from blackmoon (unknown [195.234.144.146])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.msh.lv (mailer) with ESMTP id 07245A4009
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jan 2006 18:54:08 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello !

I have Supermicro 6014H-32 server with adaptec 9410w SAS/SATA controller on 
board.
I have linux kernel compiled with aic94xx driver from 
http://linux.adaptec.com/sas/
I am notice that SAS disks work well with this driver, but SATA disks are 
not mapped to /dev by driver.
I tried to contact Luben Tuikov without success.
Looks like aic94xx driver is not complete or have no SATA support

    Deniss Gaplevsky

