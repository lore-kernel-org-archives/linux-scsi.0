From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: megaraid_sas: add in missing white spaces in error
 messages text
Date: Mon, 14 Nov 2016 14:24:48 -0800
Message-ID: <b1a8dbb6-e905-ff64-e402-a9373b12609c@sandisk.com>
References: <20161112162524.4585-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0071.outbound.protection.outlook.com ([104.47.42.71]:45184
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965039AbcKNWY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Nov 2016 17:24:57 -0500
In-Reply-To: <20161112162524.4585-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On 11/12/2016 08:25 AM, Colin King wrote:
> A couple of dev_printk messages spans two lines and the literal string
> is missing a white space between words. Add the white space.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
