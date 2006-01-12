From: "Zhikun Wang" <raidwang@gmail.com>
Subject: Calling scsi_done from queuecommand()
Date: Thu, 12 Jan 2006 11:57:48 +0800
Message-ID: <200601121157417180341@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.206]:54993 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932681AbWALDz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 22:55:58 -0500
Received: by zproxy.gmail.com with SMTP id i11so301984nzh
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2006 19:55:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi list, 
	Can we call scsi_done() to complete the I/O from the queuecommand() ? (e.g. to make queuecommand synchronous). 
	I try this method in my LsiLogic 22320 SCSI card driver in Redhat9, and i can correctly handle read command. But Write command is stop when i call scsi_done() in the queuecommand. I am very puzzled! 
	Thanks for any answers!

Regards, 
-zkwang 


