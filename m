From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 38/39] megaraid_sas: Change RAID_1_10_RMW_CMDS to
 RAID_1_PEER_CMDS and set value to 2
Date: Mon, 6 Feb 2017 17:14:03 +0100
Message-ID: <a01766a1-d3c5-2766-e7fa-a1f1549695ca@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-39-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754524AbdBFQOL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 11:14:11 -0500
In-Reply-To: <1486375212-17329-39-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 11:00, Shivasharan S wrote:
> For RAID1 FastPath writes, driver needs to allocate extra commands
> internally to accommodate for the extra peer command being sent.
> Currently driver is allocating 2 extra commands for each but only
> one extra command is necessary.
> Set RAID_1_10_RMW_CMDS to 2 and also change macro name to
> RAID_1_PEER_CMDS.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
