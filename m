From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH][V2] scsi: megaraid-sas: fix spelling mistake of
 "outstanding"
Date: Tue, 29 Nov 2016 11:20:06 -0800
Message-ID: <99f3f833-6dd6-557a-2ae4-0051dfbe9f36@sandisk.com>
References: <20161129191333.9176-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0051.outbound.protection.outlook.com ([104.47.34.51]:29819
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751479AbcK2TUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 14:20:12 -0500
In-Reply-To: <20161129191333.9176-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On 11/29/2016 11:13 AM, Colin King wrote:
> Trivial fix to spelling mistake "oustanding" to "outstanding" in
> dev_info and scmd_printk messages. Also join wrapped literal
> string in the scmd_printk.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
