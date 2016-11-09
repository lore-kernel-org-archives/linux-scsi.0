From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] megaraid_sas: fix macro MEGASAS_IS_LOGICAL to avoid
 regression caused by commit 1e793f6fc0db920400574211c48f9157a37e3945
Date: Wed, 9 Nov 2016 09:14:40 -0700
Message-ID: <a83d4654-0e9f-b0bb-85fa-0eb7c926c525@kernel.dk>
References: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36457 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753614AbcKIQOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 11:14:45 -0500
Received: by mail-it0-f52.google.com with SMTP id q124so166574034itd.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2016 08:14:45 -0800 (PST)
In-Reply-To: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, shivasharan.srikanteshwara@broadcom.com, stable@vger.kernel.org

On 11/09/2016 03:59 AM, Sumit Saxena wrote:
> This patch will fix regression caused by below commit-
> 1e793f6 scsi: megaraid_sas: Fix data integrity failure for JBOD (passthrough) devices
>
> The problem was MEGASAS_IS_LOGICAL macro does not have braces and because of above commit
> using this macro was exposing lot of non-existing SCSI devices(all SCSI commands to channels-1,2,3 was
> returned as SUCCESS-DID_OK by driver).
>
> Fixes: 1e793f6fc0db920400574211c48f9157a37e3945
> Reported-by: Jens Axboe <axboe@kernel.dk>
> CC: stable@vger.kernel.org
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Tested-by: Sumit Saxena <sumit.saxena@broadcom.com>

Tested-by: Jens Axboe <axboe@fb.com>

-- 
Jens Axboe

