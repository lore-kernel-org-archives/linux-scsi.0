From: Douglas Gilbert <dougg@torque.net>
Subject: Is scsi_cmnd::underflow still useful?
Date: Mon, 12 Jul 2004 15:40:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F2E93B.3040607@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts10.bellnexxia.net ([209.226.175.54]:50860 "EHLO
	tomts10-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S263790AbUGLWZv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 18:25:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bunk@fs.tum.de

Doesn't look like many LLDs act on scsi_cmnd::underflow.
Seems to me that scsi_cmnd::resid is a more general
replacement.

Comments?

Doug Gilbert

