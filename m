From: Menny Hamburger <Menny_Hamburger@Dell.com>
Subject: BLKDISCARD and AIO
Date: Tue, 22 Oct 2013 17:13:26 +0300
Message-ID: <201310221413.r9MEDQpK002617@bldi04p.dell-idc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:39726 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3JVOWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Oct 2013 10:22:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a question regarding the use of BLKDISCARD ioctl in userland code:
Is there currently a way to hook up with an asyncronous event that can be polled by userland when the operation completes?
If not, is there any developement undergoing to implement such a behavior? 

Thanks,
Menny
