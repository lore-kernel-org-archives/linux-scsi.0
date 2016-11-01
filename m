From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix scsi scan hang triggered if adapter fails during init
Date: Tue, 01 Nov 2016 16:42:11 -0400
Message-ID: <yq1funbylss.fsf@sermon.lab.mkp.net>
References: <1477082727-29137-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30301 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750889AbcKAUmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 16:42:35 -0400
In-Reply-To: <1477082727-29137-1-git-send-email-William.Kuzeja@stratus.com>
        (Bill Kuzeja's message of "Fri, 21 Oct 2016 16:45:27 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Kuzeja <William.Kuzeja@stratus.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>

>>>>> "Bill" == Bill Kuzeja <William.Kuzeja@stratus.com> writes:

Bill> A system can get hung task timeouts if a qlogic board fails during
Bill> initialization (if the board breaks again or fails the init). The
Bill> hang involves the scsi scan.

Bill> In a nutshell, since commit beb9e315e6e0 ("qla2xxx: Prevent
Bill> removal and board_disable race"):

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
