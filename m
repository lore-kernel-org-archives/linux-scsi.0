From: John Garry <john.garry@huawei.com>
Subject: scsi-mq performance check
Date: Fri, 18 Dec 2015 14:58:12 +0000
Message-ID: <56741F04.3070506@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:54957 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbbLRPGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 10:06:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@sandisk.com, hch@infradead.org, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

I have started to enable scsi-mq on the HiSilicon SAS driver.

Are there hints/checks I should use to make sure it is configured 
correctly/optimally? In my initial testing I have seen some performance 
improvements, but none like what I have seen in presentations.

Cheers,
John


