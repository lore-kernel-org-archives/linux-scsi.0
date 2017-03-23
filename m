From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Fix PT2PT PRLI reject.
Date: Thu, 23 Mar 2017 11:20:47 -0400
Message-ID: <yq1inn0dnow.fsf@oracle.com>
References: <CAGx+d6dqKhPt4oF5Q_=EQa9Joa9KuHpsnTTFMBOA1z3CA5RshA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39468 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935030AbdCWPUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 11:20:53 -0400
In-Reply-To: <CAGx+d6dqKhPt4oF5Q_=EQa9Joa9KuHpsnTTFMBOA1z3CA5RshA@mail.gmail.com>
        (Dick Kennedy's message of "Thu, 23 Mar 2017 08:47:18 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>

Dick Kennedy <dick.kennedy@broadcom.com> writes:

Dick,

> lpfc cannot establish connection with targets that send PRLI in P2P
> configurations.
>
> If lpfc rejects a PRLI that is sent from a target the target will not
> resend and will reject the PRLI send from the initiator.

Applied to 4.11/scsi-fixes (by hand, due to being mangled).

-- 
Martin K. Petersen	Oracle Linux Engineering
