From: Kenneth Porter <shiva@sewingwitch.com>
Subject: MegaRAID 511 i4 IDE
Date: Thu, 08 Sep 2005 02:07:06 -0700
Message-ID: <9C51CCE9E6958364EDABAE1E@[10.169.6.233]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segw.microprecisionautomation.com ([69.17.55.168]:2718 "EHLO
	segw.microprecisionautomation.com") by vger.kernel.org with ESMTP
	id S932425AbVIHJHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 05:07:17 -0400
Received: from home.sewingwitch.com (c-67-160-222-127.hsd1.ca.comcast.net [67.160.222.127])
	(authenticated bits=0)
	by segw.microprecisionautomation.com (8.13.1/8.13.1) with ESMTP id j8897Am9021149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Sep 2005 02:07:16 -0700
Received: from [10.169.6.233] (segw.microprecisionautomation.com [69.17.55.168])
	(authenticated bits=0)
	by home.sewingwitch.com (8.13.1/8.13.1) with ESMTP id j889770p028000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Sep 2005 02:07:08 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Alas, I've got one of these critters, and I don't see it listed in 
megaraid_mbox.c. (The subsystem device is 0x0511.) The I4_133 (0x0522) is 
listed, though. Is there any hope that just adding the entry to the PCI 
table would make this work? Or would the 511 need special-case code?

<http://www.lsilogic.com/products/megaraid/megaraid_i4.html>
