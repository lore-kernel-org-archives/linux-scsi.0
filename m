From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid-sas: request irqs later
Date: Wed, 16 Nov 2016 20:20:01 -0500
Message-ID: <yq1oa1ec37i.fsf@sermon.lab.mkp.net>
References: <1478017922-22655-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48823 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932393AbcKQBUJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 20:20:09 -0500
In-Reply-To: <1478017922-22655-1-git-send-email-thenzl@redhat.com> (Tomas
        Henzl's message of "Tue, 1 Nov 2016 17:32:02 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com, kashyap.desai@broadcom.com

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> It is not good when an irq arrives before driver structures are
Tomas> allocated.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
