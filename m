From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: qla2xxx async scan in kernel 2.6.16
Date: Mon, 27 Apr 2009 00:04:46 +0800
Message-ID: <d364733c0904260904t1ba66e7ey1caef491d6428866@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:7307 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZDZQEq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2009 12:04:46 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1568004wfd.4
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2009 09:04:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

In kernel 2.6.16, I find that there is no scsi_scan_host in
qla2xxx_probe_one. So how does the qla driver scan the scsi device?

Thanks

-- 
Xie Gang
