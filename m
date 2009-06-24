From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Is the same scsi_device in sd and sg driver?
Date: Wed, 24 Jun 2009 16:05:52 +0800
Message-ID: <d364733c0906240105t70c5e3fbi8d4d0f54ebb3937f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:52781 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZFXIFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2009 04:05:49 -0400
Received: by wf-out-1314.google.com with SMTP id 26so208635wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2009 01:05:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Are the scsi_device structures actually the same one in sd and sg driver?

It seems that the scsi_device structure in sg come from class_device
in sg_add function. And the scsi_device structure in sd when driver
loading, ie. when scsi_scan_host or sd_probe. So, are they the same
structure in memory(ie, they have the same request queue) ?

Thanks,

-- 
Xie Gang
