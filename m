From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 01/39] Revert "scsi: megaraid_sas: Enable or Disable Fast
 path based on the PCI Threshold Bandwidth"
Date: Mon, 6 Feb 2017 15:37:47 +0530
Message-ID: <005a44f52b788ccda8cc240a50126a33@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35869 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdBFKHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:07:48 -0500
Received: by mail-qk0-f175.google.com with SMTP id 11so49766708qkl.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:07:48 -0800 (PST)
In-Reply-To: <1486375212-17329-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> -----Original Message-----
> From: Shivasharan S [mailto:shivasharan.srikanteshwara@broadcom.com]
> Sent: Monday, February 06, 2017 3:30 PM
> To: linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com; hare@suse.com; Shivasharan S
> Subject: [PATCH 01/39] Revert "scsi: megaraid_sas: Enable or Disable
Fast path
> based on the PCI Threshold Bandwidth"
>
> This reverts
> commit "3e5eadb1a881" ("scsi: megaraid_sas: Enable or Disable Fast path
based
> on the PCI Threshold Bandwidth")
>
> This patch was aimed to increase performance of R1 Write operation for
large
> IO size.
> Since this method used timer approach, it turn on/off fast path did not
work as
> expected.
> Patch 0011 describes new algorithm and performance number.


Correction: Please refer patch #0012 - "megaraid_sas: raid 1 write
performance for large io"
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
