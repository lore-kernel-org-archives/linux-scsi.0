From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V3 0/3] hpsa updates
Date: Mon, 13 Mar 2017 23:00:57 -0400
Message-ID: <yq1bmt4r28m.fsf@oracle.com>
References: <148917802486.17050.17178463722401202189.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35596 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdCNDBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 23:01:37 -0400
In-Reply-To: <148917802486.17050.17178463722401202189.stgit@brunhilda> (Don
        Brace's message of "Fri, 10 Mar 2017 14:35:05 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> These patches are based on Linus's tree The changes are:
Don>  - add in a new offline volume status
Don>  - limit the number of outstanding rescan operation
Don>  - do not timeout reset operations

Applied to 4.11/scsi-fixes.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
