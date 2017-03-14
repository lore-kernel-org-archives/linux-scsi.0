From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] lpfc: Finalize Kconfig options for nvme
Date: Mon, 13 Mar 2017 23:08:09 -0400
Message-ID: <yq137egr1wm.fsf@oracle.com>
References: <1489012561-27977-1-git-send-email-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45277 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754258AbdCNDIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 23:08:49 -0400
In-Reply-To: <1489012561-27977-1-git-send-email-jsmart2021@gmail.com>
        (jsmart's message of "Wed, 8 Mar 2017 14:36:01 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

>>>>> "James" == jsmart2021  <jsmart2021@gmail.com> writes:

James> Reviewing the result of what was just added for Kconfig, we made
James> a poor choice. It worked well for full kernel builds, but not so
James> much for how it would be deployed on a distro.

Applied to 4.11/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
