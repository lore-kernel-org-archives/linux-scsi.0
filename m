From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] qla2xxx: Initialize Work element before requesting IRQs
Date: Mon, 16 Oct 2017 23:13:31 -0400
Message-ID: <yq1376i1n6s.fsf@oracle.com>
References: <20171016182605.22174-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21896 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbdJQDNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 23:13:39 -0400
In-Reply-To: <20171016182605.22174-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Mon, 16 Oct 2017 11:26:05 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> commit a9e170e28636 ("scsi: qla2xxx: Fix uninitialized work element")
> moved initialziation of work element earlier in the probe to fix call
> stack. However, it still leaves a window where interrupt can be
> generated before work element is initialized. Fix that window by
> Initializing work element before we are requesting IRQs.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
