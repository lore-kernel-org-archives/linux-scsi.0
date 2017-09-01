From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/4] Improve requeuing behavior
Date: Thu, 31 Aug 2017 23:10:42 -0400
Message-ID: <yq17exjw1u5.fsf@oracle.com>
References: <20170830235842.29725-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45293 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdIADKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 23:10:48 -0400
In-Reply-To: <20170830235842.29725-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Wed, 30 Aug 2017 16:58:38 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Bart,

> The conclusion of a recent discussion is that .jiffies_at_alloc and
> .retries should be set once at the start of a lifetime of a SCSI
> request instead of every time a request is requeued. This patch series
> realizes that and also ensures that a request is unprepared and
> reprepared when requeued. Please consider these patches for kernel
> v4.14.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
