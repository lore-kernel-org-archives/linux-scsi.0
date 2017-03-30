From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi: ufs: add queries retry mechanism"
Date: Wed, 29 Mar 2017 22:53:53 -0400
Message-ID: <yq1y3vn3266.fsf@oracle.com>
References: <1490768361-4492-1-git-send-email-szymonx.mielczarek@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30919 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdC3CyK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 22:54:10 -0400
In-Reply-To: <1490768361-4492-1-git-send-email-szymonx.mielczarek@intel.com>
        (Szymon Mielczarek's message of "Wed, 29 Mar 2017 08:19:21 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Szymon Mielczarek <szymonx.mielczarek@intel.com>
Cc: linux-scsi@vger.kernel.org, subhashj@codeaurora.org

Szymon Mielczarek <szymonx.mielczarek@intel.com> writes:

> This reverts commit 61e073590b82a539654626ecae91b8fab11db3f3.
>
> The patch introduced redundant query retries as we already had such
> mechanism provided with _retry functions.
> Both ufshcd_read_desc and ufshcd_read_unit_desc_param functions
> call ufshcd_query_descriptor_retry wrapper.

Applied to 4.12/scsi-queue. Thank you.

-- 
Martin K. Petersen	Oracle Linux Engineering
