From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: prevent potential null pointer dereference
Date: Wed, 31 May 2017 22:45:47 -0400
Message-ID: <yq1zidsl92c.fsf@oracle.com>
References: <20170523150928.GA24570@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25622 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdFACqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 22:46:05 -0400
In-Reply-To: <20170523150928.GA24570@embeddedgus> (Gustavo A. R. Silva's
        message of "Tue, 23 May 2017 10:09:28 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Gustavo A.,

> Null check at line 966: if (ndlp) {, implies that ndlp might be NULL.
> Functions lpfc_nlp_set_state() and lpfc_issue_els_prli() dereference
> pointer ndlp. Include these function calls inside the IF block that
> tests pointer ndlp.

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
