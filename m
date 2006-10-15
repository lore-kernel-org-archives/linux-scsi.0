From: Aboo Valappil <aboo@aboo.org>
Subject: About SG Elements of request_buffer
Date: Sun, 15 Oct 2006 22:03:54 +1000
Message-ID: <453223AA.50409@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:30380 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S1750744AbWJOMD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 08:03:59 -0400
Received: from [192.168.1.65] ([192.168.1.65])
	by localhost.localdomain (8.13.1/8.13.1) with ESMTP id k9FBwXH7022504
	for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2006 21:58:33 +1000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

Thanks for all your support for my previous posts.

I have two questions.

1. Is it safe to assume that all the SG elements of request_buffer are 
page aligned? (Except the first one and last one),  I mean, it is always 
multiple of pages?

2. What are situations reading a scsi disk (using dd ) cause a write to 
the disk?  When I read my virtual scsi disk using dd command, block 
layer is generating lot of SCSI write, as well as reads. Any thoughts? 
Besides this observation, everything is working fine.

Thanks in advance.

Aboo


