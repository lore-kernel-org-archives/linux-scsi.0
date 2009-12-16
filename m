From: Matthew Tehonica <matt.tehonica@mac.com>
Subject: Applying MVSAS Patch
Date: Wed, 16 Dec 2009 09:22:21 -0500
Message-ID: <123775394220340616192589247497798894367-Webmail@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asmtpout018.mac.com ([17.148.16.93]:51687 "EHLO
	asmtpout018.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZLPOW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 09:22:29 -0500
Received: from spool002.mac.com ([10.150.69.52])
 by asmtp018.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTP id <0KUR00BOK19EY210@asmtp018.mac.com> for
 linux-scsi@vger.kernel.org; Wed, 16 Dec 2009 06:22:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ayan@marvell.com

Hi All,

I am trying to apply the first patch to fix the mvsas issue and getting an error that I can't figure out. See below:

mtehonica@ghostrider:/usr/src/linux-2.6.32$ sudo patch -p1 < /home/mtehonica/Downloads/0001-Update-chip-init-code-to-enhance-performance.patch 
patching file drivers/scsi/mvsas/mv_64xx.c
patch: **** malformed patch at line 65:  	/* interrupt coalescing may cause missing HW interrput in some case,

I have played around with removing the line that it complains about and it just then says the next line is malformed.  Can anyone help with this???

Thanks!
Matt
