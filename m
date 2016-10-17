From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/7] megaraid_sas: For SRIOV enabled firmware, ensure VF
 driver waits for 30secs before reset
Date: Mon, 17 Oct 2016 14:43:39 +0200
Message-ID: <9fa6510a-cdb0-ad83-e73b-6b1c1cfeb88c@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-2-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934631AbcJQMnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 08:43:42 -0400
In-Reply-To: <1476699850-25083-2-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, stable@vger.kernel.org, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

On 17.10.2016 12:24, Sumit Saxena wrote:
> For SRIOV enabled firmware, if there is a OCR(online controller reset)
> possibility driver set the convert flag to 1, which is not happening if
> there are outstanding commands even after 180 seconds.
> As driver does not set convert flag to 1 and still making the OCR to run,
> VF(Virtual function) driver is directly writing on to the register
> instead of waiting for 30 seconds. Setting convert flag to 1 will cause
> VF driver will wait for 30 secs before going for reset.
>
> CC: stable@vger.kernel.org
> Signed-off-by: Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

