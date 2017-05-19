From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Clean up some rpm/spm level SysFS nodes upon remove
Date: Thu, 18 May 2017 21:31:10 -0400
Message-ID: <yq1tw4h4opt.fsf@oracle.com>
References: <1494570987-10128-1-git-send-email-michalx.potomski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23752 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932384AbdESBbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 21:31:20 -0400
In-Reply-To: <1494570987-10128-1-git-send-email-michalx.potomski@intel.com>
        (Michal Potomski's message of "Fri, 12 May 2017 08:36:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Potomski <michalx.potomski@intel.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, subhashj@codeaurora.org


Michal,

> When reloading module these two attributes aren't cleaned up properly
> and they persist causing warnings when trying to load module
> again. Additionally they are not recreated properly due to that.

Applied to 4.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
