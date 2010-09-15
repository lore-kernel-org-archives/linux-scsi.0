From: Douglas Gilbert <dgilbert@interlog.com>
Subject: scsi.h: please rename the status_byte() macro
Date: Wed, 15 Sep 2010 16:39:48 -0400
Message-ID: <4C912F14.8000706@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54060 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab0IOUj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 16:39:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 439641037EF
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2010 22:39:54 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vTGwoesyE4Ip for <linux-scsi@vger.kernel.org>;
	Wed, 15 Sep 2010 22:39:54 +0200 (CEST)
Received: from [10.7.0.10] (unknown [10.7.0.10])
	by smtp.infotech.no (Postfix) with ESMTPA id D682F1037E9
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2010 22:39:53 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

... to something like:
    scsi_status_byte_div2()
or:
    scsi_broken_status_byte()

Doug Gilbert
