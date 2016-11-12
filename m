From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/2] sd: Fix a deadlock between event checking and device
 removal
Date: Fri, 11 Nov 2016 16:38:47 -0800
Message-ID: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0057.outbound.protection.outlook.com ([104.47.41.57]:26432
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934500AbcKLAix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 19:38:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello James and Martin,

This short patch series fixes a deadlock that I ran into for the first 
time several months ago but for which I had not yet had the time to post 
a fix. As usual, feedback is appreciated.

Thanks,

Bart.
