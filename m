From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ipr: do not set DID_PASSTHROUGH on CHECK CONDITION
Date: Tue, 11 Apr 2017 21:41:19 -0400
Message-ID: <yq18tn6v1vk.fsf@oracle.com>
References: <1491921964-11077-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43602 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbdDLBlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 21:41:24 -0400
In-Reply-To: <1491921964-11077-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Tue, 11 Apr 2017 11:46:04
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: martin.petersen@oracle.com, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

> On a dual controller setup with multipath enabled, some MEDIUM ERRORs
> caused both paths to be failed, thus I/O got queued/blocked since the
> 'queue_if_no_path' feature is enabled by default on IPR controllers.

Applied to 4.11/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
