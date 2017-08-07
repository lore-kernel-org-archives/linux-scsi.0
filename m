From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] qla2xxx: Fix system crash while triggering FW dump
Date: Mon, 07 Aug 2017 13:38:48 -0400
Message-ID: <yq1h8xj9t1z.fsf@oracle.com>
References: <20170731214510.7653-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34731 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdHGRiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:38:54 -0400
In-Reply-To: <20170731214510.7653-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Mon, 31 Jul 2017 14:45:10 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> Please apply this patch to 4.13.0-rc4. Without this patch our
> capabilty to collect and analyze firmware dump in a customer
> enviorment will be greatly affected.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
