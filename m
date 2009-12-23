From: Prashant Bhole <prashantsmailcenter@gmail.com>
Subject: Query related to block_device and gendisk relation
Date: Wed, 23 Dec 2009 17:41:46 +0530
Message-ID: <9ff69a5d0912230411saa76828v7fe4d506a9390ced@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:56648 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbZLWMLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2009 07:11:46 -0500
Received: by qyk30 with SMTP id 30so3358626qyk.33
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2009 04:11:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
Can anybody please tell me where does an object of gendisk gets
assigned to struct block_device->bd_disk?

I looked into fs/partitions/check.c register_disk()
This function has a parameter struct gendisk pointer. This function
gets/allocates a block_device *bdev. But nowhere it assigns the
gendisk to bdev->bd_disk.


Thanks in advance,
-- 
~p~r~a~s~h~a~n~t~
