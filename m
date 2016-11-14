From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: megaraid_sas: add in missing white spaces in error messages text
Date: Mon, 14 Nov 2016 18:27:49 -0500
Message-ID: <yq1y40lfxqi.fsf@sermon.lab.mkp.net>
References: <20161112162524.4585-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38113 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753048AbcKNX17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:27:59 -0500
In-Reply-To: <20161112162524.4585-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 12 Nov 2016 16:25:24 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> A couple of dev_printk messages spans two lines and the literal
Colin> string is missing a white space between words. Add the white
Colin> space.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
