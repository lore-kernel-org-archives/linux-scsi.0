From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Add fix to read correct register value for ISP82xx.
Date: Tue, 04 Apr 2017 20:14:32 -0400
Message-ID: <yq18tnfvhg7.fsf@oracle.com>
References: <20170331213704.5577-1-himanshu.madhani@cavium.com>
        <20170331213704.5577-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33615 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752326AbdDEAOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 20:14:48 -0400
In-Reply-To: <20170331213704.5577-2-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Fri, 31 Mar 2017 14:37:03 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Himanshu Madhani <himanshu.madhani@cavium.com> writes:

> Add fix to read correct register value for ISP82xx, during check for
> register disconnect.ISP82xx has different base register.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
