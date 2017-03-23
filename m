From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: fix volume offline state
Date: Thu, 23 Mar 2017 10:13:12 -0400
Message-ID: <yq1var0dqtj.fsf@oracle.com>
References: <1490024568-4301-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbdCWON3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 10:13:29 -0400
In-Reply-To: <1490024568-4301-1-git-send-email-thenzl@redhat.com> (Tomas
        Henzl's message of "Mon, 20 Mar 2017 16:42:48 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, don.brace@microsemi.com, joseph.szczypek@hpe.com

Tomas Henzl <thenzl@redhat.com> writes:

> In a previous patch a hpsa_scsi_dev_t.volume_offline update line
> has been removed, so let us put it back..
>
> Fixes: 85b29008d8 (hpsa: update check for logical volume status)

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
