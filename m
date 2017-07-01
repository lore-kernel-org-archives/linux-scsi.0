From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ses: do not add a device to an enclosure if enclosure_add_links() fails.
Date: Sat, 01 Jul 2017 16:53:37 -0400
Message-ID: <yq1o9t3x4j2.fsf@oracle.com>
References: <1498557207-12364-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25704 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdGAUxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2017 16:53:51 -0400
In-Reply-To: <1498557207-12364-1-git-send-email-mlombard@redhat.com> (Maurizio
        Lombardi's message of "Tue, 27 Jun 2017 11:53:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com


Maurizio,

> The enclosure_add_device() function should fail if it can't
> create the relevant sysfs links.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
