From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: fix sleeping in interrupt context
Date: Fri, 13 Jan 2017 21:17:46 +0000
Message-ID: <1484342253.2679.22.camel@sandisk.com>
References: <1484162202-64392-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr710088.outbound.protection.outlook.com ([40.107.71.88]:30880
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750707AbdAMVR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 16:17:58 -0500
In-Reply-To: <1484162202-64392-1-git-send-email-bryantly@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <BDDBC9473A7500458445018299ABD88B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Wed, 2017-01-11 at 13:16 -0600, Bryant G. Ly wrote:
> Currently, dma_alloc_coherent is being called with a GFP_KERNEL
> flag which allows it to sleep in an interrupt context, need to
> change to GFP_ATOMIC.

This patch has been queued for kernel v4.10. Thanks for the patch.

Bart.=
