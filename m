From: Anil kumar <anils_r@yahoo.com>
Subject: blk_queue_hardsect_size 520-byte sector
Date: Thu, 5 Jun 2008 21:58:28 -0700 (PDT)
Message-ID: <339116.28290.qm@web32404.mail.mud.yahoo.com>
Reply-To: anils_r@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32404.mail.mud.yahoo.com ([68.142.207.197]:21471 "HELO
	web32404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751721AbYFFFFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 01:05:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

Can I call blk_queue_hardsect_size in a driver and set it to 520-byte as hardware sector size. 
How does the kernel and block layers take the request, will it be in multiples of 520-bytes aligned or 512 bytes aligned?

Thanks for your help in advance.

with regards,
  Anil


      
