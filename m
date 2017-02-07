From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Mon, 06 Feb 2017 19:23:22 -0500
Message-ID: <yq1r33asvb9.fsf@oracle.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
        <20170123163446.9227-2-bart.vanassche@sandisk.com>
        <yq1tw8mbtyj.fsf@oracle.com> <1486141186.2553.2.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46346 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdBGAXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 19:23:32 -0500
In-Reply-To: <1486141186.2553.2.camel@sandisk.com> (Bart Van Assche's message
        of "Fri, 3 Feb 2017 16:59:59 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michael.hernandez@cavium.com" <michael.hernandez@cavium.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "hch@lst.de" <hch@lst.de>

>>>>> "Bart" == Bart Van Assche <Bart.VanAssche@sandisk.com> writes:

Hi Bart,

Bart> Since there is now a resolution for patch 2: have you already
Bart> decided when to submit these patches upstream?

I queued it in scsi-fixes last week:

commit 2780f3c8f0233de90b6b47a23fc422b7780c5436
Author:     Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
AuthorDate: Wed Jan 25 22:07:06 2017 -0200
Commit:     Martin K. Petersen <martin.petersen@oracle.com>
CommitDate: Tue Jan 31 22:25:32 2017 -0500

    scsi: qla2xxx: Avoid that issuing a LIP triggers a kernel crash

[...]

-- 
Martin K. Petersen	Oracle Linux Engineering
