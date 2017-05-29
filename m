From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: prevent potential null pointer dereference
Date: Mon, 29 May 2017 16:06:28 -0700
Message-ID: <5e0120e9-418d-c051-cd3e-03c39ff8f627@broadcom.com>
References: <20170523150928.GA24570@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33902 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdE2XG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2017 19:06:29 -0400
Received: by mail-oi0-f52.google.com with SMTP id b204so92099600oii.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 16:06:29 -0700 (PDT)
In-Reply-To: <20170523150928.GA24570@embeddedgus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Looks good

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james


On 5/23/2017 8:09 AM, Gustavo A. R. Silva wrote:
> Null check at line 966: if (ndlp) {,  implies that ndlp might be NULL.
> Functions lpfc_nlp_set_state() and lpfc_issue_els_prli() dereference
> pointer ndlp. Include these function calls inside the IF block that
> tests pointer ndlp.
>
> Addresses-Coverity-ID: 1401856
>
