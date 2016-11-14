From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid-sas: request irqs later
Date: Mon, 14 Nov 2016 18:48:04 -0500
Message-ID: <yq1wpg5ei8b.fsf@sermon.lab.mkp.net>
References: <1478017922-22655-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46081 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938953AbcKNXsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:48:11 -0500
In-Reply-To: <1478017922-22655-1-git-send-email-thenzl@redhat.com> (Tomas
        Henzl's message of "Tue, 1 Nov 2016 17:32:02 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com, kashyap.desai@broadcom.com

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> It is not good when an irq arrives before driver structures are
Tomas> allocated.

Sumit, Kashyap: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
