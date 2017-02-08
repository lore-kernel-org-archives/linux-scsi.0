From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 09/39] megaraid_sas: change issue_dcmd to return void
 from int
Date: Wed, 8 Feb 2017 15:40:03 +0100
Message-ID: <61cc9b4f-a3c7-dc1d-9f34-237906afeda4@redhat.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751932AbdBHOsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Feb 2017 09:48:35 -0500
In-Reply-To: <1486546173-20713-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 8.2.2017 10:29, Shivasharan S wrote:
> fix in v2 : 
> 1. split patches into two as discussed below 
> http://marc.info/?l=linux-scsi&m=148638999110404&w=2
> 2. issue_dcmd return type changed from int to void.
>
>
> With the changes to remove checks for a valid request descriptor,
> issue_dcmd will now always return DCMD_SUCCESS. This patch changes
> return type of issue_dcmd to void and change all callers
> appropriately.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
