From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Make checking the scsi_device_get() return value mandatory
Date: Thu, 06 Apr 2017 12:46:40 -0400
Message-ID: <yq1h921qya7.fsf@oracle.com>
References: <4b49f610-4ae7-ac4c-5c93-920c034e964d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39719 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754592AbdDFQqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 12:46:48 -0400
In-Reply-To: <4b49f610-4ae7-ac4c-5c93-920c034e964d@sandisk.com> (Bart Van
        Assche's message of "Wed, 5 Apr 2017 09:52:50 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart Van Assche <bart.vanassche@sandisk.com> writes:

> Now that all scsi_device_get() callers check the return value of this
> function, make checking that return value mandatory.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
