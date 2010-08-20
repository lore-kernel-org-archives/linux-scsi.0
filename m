From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: SG_ALL definition
Date: Fri, 20 Aug 2010 09:18:40 +0200
Message-ID: <201008200918.40405.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51658 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab0HTHSn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 03:18:43 -0400
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 37C721BE
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2010 03:18:42 -0400 (EDT)
Received: from bathl.localnet (stgt-4d03a7af.pool.mediaWays.net [77.3.167.175])
	by mail.messagingengine.com (Postfix) with ESMTPSA id E8DEB4086E5
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2010 03:18:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From ancient times SG_ALL was defined as 0xff = 255. Rather likely for that 
reason we see lots of IO requests of size 1020 from drivers that do not 
support sg-chaining yet. And IO sizes of 1020 are a nightmare for DDN 
hardware. Is there a chance to increase that to 256 by default? 
Lustre includes a kernel patch to that for RHEL5 kernel and it greatly helps 
to get correct IO sizes. 


Thanks,
Bernd

-- 
Bernd Schubert
DataDirect Networks
