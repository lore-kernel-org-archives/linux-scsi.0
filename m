From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix crash in qla2xxx_eh_abort on bad ptr
Date: Mon, 13 Mar 2017 22:55:17 -0400
Message-ID: <yq1k27sr2i2.fsf@oracle.com>
References: <1489078043-388-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41572 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752012AbdCNCzc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 22:55:32 -0400
In-Reply-To: <1489078043-388-1-git-send-email-William.Kuzeja@stratus.com>
        (Bill Kuzeja's message of "Thu, 9 Mar 2017 11:47:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Kuzeja <William.Kuzeja@stratus.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

>>>>> "Bill" == Bill Kuzeja <William.Kuzeja@stratus.com> writes:

Hi Bill,

Bill> I've seen this issue only after a Qlogic card breaks upon
Bill> initialization (one of my test cases). After the break,
Bill> qla2x00_abort_all_cmds gets invoked. This routine has a relatively
Bill> new section introduced by these commits:

[...]

Please resubmit a v2 of this fix with a concise (~ one paragraph) patch
description. The extensive debugging write-up is fine but it should be
placed after a --- separator so it doesn't end up in the git log.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
