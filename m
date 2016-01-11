From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/15] megaraid_sas: MFI IO timeout handling
Date: Mon, 11 Jan 2016 18:02:50 +0100
Message-ID: <5693E03A.6040106@redhat.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-3-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbcAKRCw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2016 12:02:52 -0500
In-Reply-To: <1450445228-26571-3-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 18.12.2015 14:26, Sumit Saxena wrote:
> This patch will do proper error handling for DCMD timeout and failed cases for fusion adapters.
> Below are few key design points-
> 1. For MFI adapters, in case of DCMD timeout(DCMD which must return SUCCESS) driver will call kill adapter. 
> 2. What action needs to be taken in case of DCMD timeout is decided by function dcmd_timeout_ocr_possible().
> DCMD timeout causing OCR is applicable to below DCMDs-
>
> MR_DCMD_PD_LIST_QUERY
> MR_DCMD_LD_GET_LIST
> MR_DCMD_LD_LIST_QUERY
> MR_DCMD_CTRL_SET_CRASH_DUMP_PARAMS
> MR_DCMD_SYSTEM_PD_MAP_GET_INFO(for non pended DCMD)
> MR_DCMD_LD_MAP_GET_INFO(for non pended DCMD)
>
> 3. If DCMD fails from Driver init path, there are certain DCMD which is must to be return SUCCESS. If those DCMD fails,
> driver bail out load. For optional DCMD like pd_info etc, driver continue without executing certain functionality.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

