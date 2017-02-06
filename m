From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 17/39] megaraid_sas: In validate raid map, raid capability
 is not converted to cpu format for all lds
Date: Mon, 6 Feb 2017 16:42:54 +0100
Message-ID: <bf24e9dd-896f-2794-494c-5cbaf46b2684@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751756AbdBFPm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:42:57 -0500
In-Reply-To: <1486375212-17329-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> On a host, if an ld is deleted there is a hole in the ld array returned
> by the FW. But in MR_ValidateMapInfo we are not accounting for holes in
> the ld array and traverse only upto index num_lds.
> This patch takes care of converting the capability field of all the
> valid lds in the ld raid map.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
