From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Get mutex lock before checking optrom_state
Date: Mon, 09 Jan 2017 23:16:32 -0500
Message-ID: <yq1eg0beehr.fsf@oracle.com>
References: <288dbcf8-29b5-8156-aba8-049edfed1dde@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42927 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934301AbdAJEQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 23:16:40 -0500
In-Reply-To: <288dbcf8-29b5-8156-aba8-049edfed1dde@redhat.com> (Milan
        P. Gandhi's message of "Sat, 24 Dec 2016 22:02:46 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, chad.dupuis@cavium.com

>>>>> "Milan" == Milan P Gandhi <mgandhi@redhat.com> writes:

Milan> There is a race condition with qla2xxx optrom functions where one
Milan> thread might modify optrom buffer, optrom_state while other
Milan> thread is still reading from it.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
