From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] virtio_scsi: Always try to read VPD pages
Date: Wed, 19 Apr 2017 19:12:56 -0400
Message-ID: <yq1mvbcrnyf.fsf@oracle.com>
References: <20170413021300.25023-1-david@gibson.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41825 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938359AbdDSXNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 19:13:11 -0400
In-Reply-To: <20170413021300.25023-1-david@gibson.dropbear.id.au> (David
        Gibson's message of "Thu, 13 Apr 2017 12:13:00 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: stefanha@redhat.com, pbonzini@redhat.com, famz@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


David,

> Passed through SCSI targets may have transfer limits which come from
> the host SCSI controller something on the host side other than the
> target itself.
>
> To make this work properly, the hypervisor can adjust the target's VPD
> information to advertise these limits.  But for that to work, the
> guest has to look at the VPD pages, which we won't do by default if it
> is an SPC-2 device, even if it does actually support it.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
