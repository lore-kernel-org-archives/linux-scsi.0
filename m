From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 10/39] megaraid_sas: NVME Interface detection and prop
 settings
Date: Wed, 8 Feb 2017 15:48:29 +0100
Message-ID: <e2fb009f-2f3a-05b4-b3fb-5eff2c48f642@redhat.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbdBHPPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Feb 2017 10:15:09 -0500
In-Reply-To: <1486546173-20713-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 8.2.2017 10:29, Shivasharan S wrote:
> New functionality
> Adding detection logic for NVME device attached behind Ventura controller.
> Driver set HostPageSize in IOC_INIT frame to inform about page size for NVME devices.
> Firmware reports NVME page size to the driver.
> PD INFO DCMD provide new interface type NVME_PD. Driver set property of NVME device.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
