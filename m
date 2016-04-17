From: Douglas Gilbert <dgilbert@interlog.com>
Subject: EXPORT_SYMBOL(scsi_use_blk_mq);
Date: Sat, 16 Apr 2016 21:55:48 -0400
Message-ID: <5712ED24.60806@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:35560 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbcDQBz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Apr 2016 21:55:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 45938204192
	for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2016 03:55:52 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G83jbIDscSog for <linux-scsi@vger.kernel.org>;
	Sun, 17 Apr 2016 03:55:50 +0200 (CEST)
Received: from [192.168.48.86] (host-104-157-190-142.dyn.295.ca [104.157.190.142])
	by smtp.infotech.no (Postfix) with ESMTPA id 64B0620415C
	for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2016 03:55:50 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Is there a good reason why 'bool scsi_use_blk_mq' declared as
extern in scsi_hosts.h is not an exported symbol?

That would allow a LLD loaded as a module to access it.

Doug Gilbert
