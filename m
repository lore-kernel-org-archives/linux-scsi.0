From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4.9/scsi-fixes] libcxgbi: fix incorrect DDP resource cleanup
Date: Tue, 08 Nov 2016 19:12:12 -0500
Message-ID: <yq1twbhpl43.fsf@sermon.lab.mkp.net>
References: <1478362768-19895-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45772 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbcKIAMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 19:12:20 -0500
In-Reply-To: <1478362768-19895-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Sat, 5 Nov 2016 21:49:28 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, indranil@chelsio.com

>>>>> "Varun" == Varun Prakash <varun@chelsio.com> writes:

Varun> Before calling task_release_itt() task data is memset to zero
Varun> because of which DDP context information is lost resulting in
Varun> incorrect DDP resource cleanup, to fix this call
Varun> task_release_itt() before memset.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
