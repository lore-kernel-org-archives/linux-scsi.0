From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 03/39] megaraid_sas: raid 1 fast path code optimize
Date: Thu, 9 Feb 2017 14:16:27 +0100
Message-ID: <32ccbadc-02b8-6e00-0824-1023e99e61fd@redhat.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdBIN2O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Feb 2017 08:28:14 -0500
In-Reply-To: <1486546173-20713-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 8.2.2017 10:28, Shivasharan S wrote:
> fix in v2 - ex_status and status was wrongly re-used in megasas_complete_r1_command.
> discussed below -
> http://marc.info/?l=linux-scsi&m=148638763409385&w=2
>
>
> No functional change. Code refactor.
> Remove function megasas_fpio_to_ldio as we never require to convert fpio to ldio because of frame unavailability.
> Grab extra frame of raid 1 write fast path before it creates first frame as Fast Path.
> Removed is_raid_1_fp_write flag as raid 1 write fast path command is decided using r1_alt_dev_handle only.
> Move resetting megasas_cmd_fusion fields at common function megasas_return_cmd_fusion.
>
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
