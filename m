From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: no set_current_state() before schedule_timeout() (QLA1280)
Date: Tue, 13 Jul 2004 17:43:43 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F41F4F.7030806@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:60845 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265682AbUGMRny
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 13:43:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

Hi,

In continuing to replace, where appropriate, code with msleep() calls, I 
ran across the following file(s) / function(s), which do not invoke 
set_current_state() before schedule_timeout(), which causes the latter 
to return immediately:

drivers/scsi/qla1280.c::qla1280_bus_reset

If someone could tell me which state (TASK_INTERRUPTIBLE or 
TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the 
calls with msleep().

Thanks,
Nish
