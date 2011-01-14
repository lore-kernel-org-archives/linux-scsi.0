From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: SCST SCSI target mode subsystem 2.0.0.1 released
Date: Sat, 15 Jan 2011 00:07:36 +0300
Message-ID: <4D30BB18.6080804@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dfsv43.com ([91.103.216.11]:36537 "EHLO mail.dfsv43.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1ANVHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 16:07:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

SCST SCSI target mode subsystem 2.0.0.1 released and can be downloaded
from the SCST download page http://scst.sourceforge.net/downloads.html.

Everybody are strongly encouraged to upgrade.

Summary of changes between versions 2.0.0 and 2.0.0.1
-----------------------------------------------------

 - Fixed critical issue with wrong INQUIRY page 0x80 (r3197)

 - Possible crashes due to incorrect execution context estimations fixed

 - Responsiveness under heavy load improved

Thanks to all participated!

Vlad
