From: Bernd Schubert <bs@q-leap.de>
Subject: need help with sg ioctls
Date: Thu, 28 Feb 2008 17:43:51 +0100
Message-ID: <200802281743.51332.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:41222 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbYB1Qn4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 11:43:56 -0500
Received: from lanczos (lanczos [192.168.55.86])
	by mail.q-leap.de (Postfix) with ESMTP id EE3B079AF
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2008 17:43:54 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

for some reasons the kernel.org qla4xxx driver doesn't work for us. Version 
5.01.00.08 seems to work a bit better, but all default sg-ioctl's are not 
defined.

Adding these manually as in scsi/sg.c works, but IMHO is rather stupid. Is 
there a sane way to call sg_ioctl()?
I mean it's static and also not exported and the file_operations ioctl method 
is already taken by the qla4xxx driver.

Do I miss something?


Thanks in advance,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
