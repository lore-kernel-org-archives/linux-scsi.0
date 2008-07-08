From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Target drivers for QLogic Fibre Channel cards released
Date: Tue, 08 Jul 2008 23:15:33 +0400
Message-ID: <4873BCD5.5060407@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:35908 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801AbYGHTfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 15:35:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: scst-devel <scst-devel@lists.sourceforge.net>

I'm glad to announce that version 1.0.0 of target drivers for QLogic 
Fibre Channel cards released and available for download from 
http://scst.sourceforge.net/downloads.html.

Two target drivers were released:

   - Target driver qla2x00t for 22xx and 23xx based QLogic Fibre Channel 
cards

   - Target driver qla_isp for 24xx based QLogic Fibre Channel cards

Those drivers are designed to work in SCST environment. They are high 
performance drivers, which provide all necessary functionality to work 
as targets in Fibre Channel environment.

Detail description of the target drivers you can find on SCST home page 
http://scst.sourceforge.net.

Driver qla2x00t is being prepared in form of patch for review and 
inclusion into the kernel.

Vlad
