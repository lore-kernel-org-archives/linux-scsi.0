From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/7] megaraid_sas: Send correct PhysArm to FW for R1 VD
 downgrade
Date: Mon, 17 Oct 2016 14:50:16 +0200
Message-ID: <9aa4f843-8c20-d04a-add6-bfa27a6280d5@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-3-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752058AbcJQMuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 08:50:19 -0400
In-Reply-To: <1476699850-25083-3-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

On 17.10.2016 12:24, Sumit Saxena wrote:
> This patch fixes the issue of wrong PhysArm was sent to firmware for R1
> VD downgrade.
>
> Signed-off-by: Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

