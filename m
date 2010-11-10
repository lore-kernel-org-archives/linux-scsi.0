From: "Jack Wang" <jack_wang@usish.com>
Subject: sd: Why we need to call sd_revalidate_disk twice in sd_probe_async
Date: Wed, 10 Nov 2010 15:21:22 +0800
Message-ID: <014D70148ADE4E969B698514F7F6913E@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:51315 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0KJHVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 02:21:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

 
Hi all

I notice in sd.c, we call sd_revalidate_disk twice in function
sd_probe_async?  Are there some special reasons? I track the git history,
and found the second one is add by From
3821d768912a47ddbd6cab52943a8284df88003c Mon Sep 17 00:00:00 2001
From: Martin K. Petersen <martin.petersen@oracle.com>
Date: Sat, 23 May 2009 11:43:38 -0400
Subject: [PATCH] sd: Detect non-rotational devices

Detect non-rotational devices and set the queue flag accordingly.

Could anyone tell me why?

Thanks
Jack

