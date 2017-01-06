From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Reinstate lpfc_soft_wwn parameter
Date: Thu, 05 Jan 2017 20:57:38 -0500
Message-ID: <yq137gxhrvx.fsf@oracle.com>
References: <586675eb.72esfyQ8KCA7mcNa%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39662 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753265AbdAFB6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:58:06 -0500
In-Reply-To: <586675eb.72esfyQ8KCA7mcNa%jsmart2021@gmail.com> (James Smart's
        message of "Fri, 30 Dec 2016 06:57:47 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "James" == James Smart <jsmart2021@gmail.com> writes:

James> The lpfc 11.2.0.4 patch set deprecated, by removing, the
James> lpfc_soft_wwn parameter support.

James> This patch reinstates support, but adds a warning in the
James> enablement of the feature that indicates Broadcom (Emulex) does
James> not support the feature.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
