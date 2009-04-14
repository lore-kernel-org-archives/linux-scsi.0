From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: A target driver for Marvell 88SE64xx(3G) and 88SE94xx(6G)
 SAS cards
Date: Tue, 14 Apr 2009 20:16:21 +0400
Message-ID: <49E4B6D5.9060007@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbZDNQQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 12:16:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, Andy Yan <ayan@marvell.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hi All,

I'm glad to announce that a target driver for Marvell 88SE64xx(3G) and 
88SE94xx(6G) SAS cards has been just added in the SCST SVN repository. A 
lot of thanks to Marvell and Andy Yan!

This driver allows to use a SAS controller based on Marvell 88SE64xx or 
88SE94xx chips as a SAN storage server (target). More info you can find 
on the SCST page http://scst.sourceforge.net.

You can download the driver from SCST SVN by running a command:

$ svn co https://scst.svn.sourceforge.net/svnroot/scst

Vlad
