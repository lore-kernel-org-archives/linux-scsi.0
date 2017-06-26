From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] qedi: Add support for offload iSCSI Boot
Date: Mon, 26 Jun 2017 12:59:02 -0400
Message-ID: <yq1h8z27kix.fsf@oracle.com>
References: <20170619134429.17657-1-nilesh.javali@cavium.com>
        <20170619134429.17657-2-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26758 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdFZQ7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 12:59:13 -0400
In-Reply-To: <20170619134429.17657-2-nilesh.javali@cavium.com> (Nilesh
        Javali's message of "Mon, 19 Jun 2017 06:44:29 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com


Nilesh,

> This patch adds support for offload iSCSI boot (Boot from SAN
> over iSCSI offload).
>
> The dependent qed patches for this support are,
> - qed: Support NVM-image reading API
> - qed: Share additional information with qedf

You had tagged this for 4.12/scsi-fixes but the above patches are not
present in 4.12. So I presume this would be a candidate for a second
stage 4.13 merge?

Patch looks OK to me, but please resubmit with a slightly more verbose
description of the changes and how they work.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
