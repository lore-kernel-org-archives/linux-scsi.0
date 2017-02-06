From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/39] Revert "scsi: megaraid_sas: Enable or Disable Fast
 path based on the PCI Threshold Bandwidth"
Date: Mon, 6 Feb 2017 14:08:01 +0100
Message-ID: <2c543589-1fba-90e3-7762-19d3fc6df2a8@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751414AbdBFNIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 08:08:04 -0500
In-Reply-To: <1486375212-17329-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> This reverts
> commit "3e5eadb1a881" ("scsi: megaraid_sas: Enable or Disable Fast path based on the PCI Threshold Bandwidth")
>
> This patch was aimed to increase performance of R1 Write operation for large IO size.
> Since this method used timer approach, it turn on/off fast path did not work as expected.
> Patch 0011 describes new algorithm and performance number.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
