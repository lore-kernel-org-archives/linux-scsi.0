From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 23/39] megaraid_sas: set pd_after_lb from
 MR_BuildRaidContext and initialize pDevHandle to MR_DEVHANDLE_INVALID
Date: Mon, 6 Feb 2017 16:51:17 +0100
Message-ID: <00a9fd5f-23ed-9121-42fa-23abc292e5b4@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753253AbdBFPvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:51:19 -0500
In-Reply-To: <1486375212-17329-24-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> Issue is limited for Syncro firmware where pd_after_lb is not set but is accidentally used.
> Not a functional issue, but results in low performance due to improper load balancing between two LUNs.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
