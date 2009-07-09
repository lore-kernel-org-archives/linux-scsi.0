From: =?UTF-8?B?6LCi57qy?= <xiegang112@gmail.com>
Subject: How to know the completion of SCSI scan?
Date: Thu, 9 Jul 2009 16:54:59 +0800
Message-ID: <d364733c0907090154j1b9e4a76m6344f1ec74bfddbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f175.google.com ([209.85.222.175]:62798 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZGIIzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 04:55:00 -0400
Received: by pzk5 with SMTP id 5so4039pzk.33
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2009 01:54:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Some FC HBA drivers scan luns asynchronously. So, the init of these
driver modules will return before the completion of scsi scan. If
other drivers depend on the completion of the scanning of the Luns,
how do they get the information?

Thanks,

-- 
Xie Gang
