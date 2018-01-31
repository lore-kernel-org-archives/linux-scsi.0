From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] Six qla2xxx and qla4xxx patches
Date: Tue, 30 Jan 2018 22:04:37 -0500
Message-ID: <yq1tvv2enju.fsf@oracle.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeAaDEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 22:04:51 -0500
In-Reply-To: <20180124003351.2616-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Tue, 23 Jan 2018 16:33:45 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org


Bart,

> The patches in this series are what I came up with after having analyzed
> the source code of the qla[24]xxx drivers with several source code analysis
> tools (scripts/kernel-doc, gcc, sparse and smatch). None of the patches in
> this series have been tested. Yet I'm asking you to consider at least the
> first patch of this series for kernel v4.16 because it fixes a locking bug
> in one of the SCSI patches queued for kernel v4.16.

Himanshu and team: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
