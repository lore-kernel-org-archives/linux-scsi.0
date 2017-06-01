From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: scsi_debug: Avoid PI being disabled when TGPS is enabled
Date: Wed, 31 May 2017 22:59:45 -0400
Message-ID: <yq1inkgl8f2.fsf@oracle.com>
References: <20170526165935.19543-1-martin.petersen@oracle.com>
        <1496244104.4753.104.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46708 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdFAC74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 22:59:56 -0400
In-Reply-To: <1496244104.4753.104.camel@localhost.localdomain> (Ewan
        D. Milne's message of "Wed, 31 May 2017 11:21:44 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


Ewan,

> Code is correct.
>
> s/TGPS/TPGS in the subject line and in one place in the patch
> description.

Also fixed the original, incorrect comment in the code that begat the
patch description typo. Thanks!

Applied to 4.12/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
