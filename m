From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] qla2xxx: Fix crash in qla2xxx_eh_abort on bad ptr
Date: Wed, 15 Mar 2017 18:52:38 -0400
Message-ID: <yq1tw6ugnk9.fsf@oracle.com>
References: <1489512524-11178-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50445 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753448AbdCOWwr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 18:52:47 -0400
In-Reply-To: <1489512524-11178-1-git-send-email-William.Kuzeja@stratus.com>
        (Bill Kuzeja's message of "Tue, 14 Mar 2017 13:28:44 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Kuzeja <William.Kuzeja@stratus.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

Bill Kuzeja <William.Kuzeja@stratus.com> writes:

> After a Qlogic card breaks when initializing (test case), the system can
> crash in qla2xxx_eh_abort if processing anything but a scsi command type 
> srb.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
