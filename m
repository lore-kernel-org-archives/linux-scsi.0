From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/21] lpfc updates for 11.4.0.4
Date: Mon, 02 Oct 2017 22:45:53 -0400
Message-ID: <yq1o9pp0x0e.fsf@oracle.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42126 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdJCCqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 22:46:04 -0400
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 29 Sep 2017 17:34:26 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: linux-scsi@vger.kernel.org


James,

> This patch set provides a number of bug fixes and additions to
> the driver.
>
> The patches were cut against the Martin's 4.14/scsi-queue tree.
> There are no outside dependencies.

Applied to 4.15/scsi-queue.

I got a conflict in patch 8 in the "Process all the event on FCP
fast-path EQ" hunk. Please verify.

-- 
Martin K. Petersen	Oracle Linux Engineering
