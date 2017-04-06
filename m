From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla4xxx: drop redundant init_completion
Date: Thu, 06 Apr 2017 13:15:04 -0400
Message-ID: <yq1r315pief.fsf@oracle.com>
References: <1490179462-16559-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22513 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbdDFRPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 13:15:14 -0400
In-Reply-To: <1490179462-16559-1-git-send-email-der.herr@hofr.at> (Nicholas Mc
        Guire's message of "Wed, 22 Mar 2017 11:44:22 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Nicholas Mc Guire <der.herr@hofr.at> writes:

> The redundant init_completion() here seems to be a cut&past error as
> struct scsi_qla_host only has 4 completion elements to initialize,
> thus the duplicate init_completion(disable_acb_comp) is simply
> removed.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
