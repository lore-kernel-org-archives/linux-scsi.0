From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: Fix capacity calculation with 32-bit sector_t
Date: Thu, 06 Apr 2017 12:52:26 -0400
Message-ID: <yq18tndqy0l.fsf@oracle.com>
References: <20170405101529.30787-1-martin.petersen@oracle.com>
        <1491416024.2787.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43247 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752828AbdDFQwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 12:52:31 -0400
In-Reply-To: <1491416024.2787.9.camel@sandisk.com> (Bart Van Assche's message
        of "Wed, 5 Apr 2017 18:13:45 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

>> We previously made sure that the reported disk capacity was less than
>> 0xffffffff blocks when the kernel was not compiled with large sector_t
>> support (CONFIG_LBDAF). However, this check assumed that the capacity
>> was reported in units of 512 bytes.
>> 
>> Add a sanity check function to ensure that we only enable disks if the
>> entire reported capacity can be expressed in terms of sector_t.
>
> Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
