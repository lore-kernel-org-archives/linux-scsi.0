From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v1 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 07:24:31 -0400
Message-ID: <yq1h91im2a8.fsf@oracle.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
        <20170420183047.GD22378@kernel.dk>
        <20170421070027.GB26346@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23833 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034918AbdDULZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 07:25:07 -0400
In-Reply-To: <20170421070027.GB26346@linux-x5ow.site> (Johannes Thumshirn's
        message of "Fri, 21 Apr 2017 09:00:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, jsmart2021@gmail.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com

Johannes Thumshirn <jthumshirn@suse.de> writes:

> Just for clarification, shouldn't Martin take the patches? They're for
> drivers/scsi/lpfc/ after all. I just want to avoid confusion and possible
> merge conflicts.

Yeah, at this point I think it's better we do a second stage merge
through 4.12/scsi-fixes. I'll set that up after Linus pulls from Jens.

-- 
Martin K. Petersen	Oracle Linux Engineering
