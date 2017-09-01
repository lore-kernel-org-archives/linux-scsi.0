From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Thu, 31 Aug 2017 23:22:44 -0400
Message-ID: <yq13787w1a3.fsf@oracle.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        <yq1lgmbauxt.fsf@oracle.com>
        <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
        <yq1a82gxwqm.fsf@oracle.com>
        <CA+RiK67f59U5Ss_Z2=veBRODtBSp1-4VTbosLkHkgaxY9XA6hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35310 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbdIADXT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 23:23:19 -0400
In-Reply-To: <CA+RiK67f59U5Ss_Z2=veBRODtBSp1-4VTbosLkHkgaxY9XA6hQ@mail.gmail.com>
        (Suganath Prabu Subramani's message of "Thu, 31 Aug 2017 10:28:06
        +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org


Hi Suganath,

> Let me explain - NVME device fast path is possible in two ways.  IEEE
> SGL and PRP SGL. Due to h/w constraint we choose IEEE SGL only for
> smaller IO size.  Both above is true h/w Fast Path and no firmware
> involvement.

> Agree with you. We are planning to see if we can keep only simple Fast
> Path using only PRP.

That would be great, thank you!

> Currently there is no performance issue for UNMAP translation in FW.

Good!

>> And yet patch 4 circumvents that statement by adding support for
>> encapsulated commands to bypass the FW translation...
>
> This path is not due to performance reason. User wants to interact
> with NVME drive in native NVME command for management.

Patch 4 states:

"This encapsulated NVMe command is used by applications to send direct
NVMe commands to NVMe drives or for handling unmap where the translation
at controller/firmware level is having performance issues."

-- 
Martin K. Petersen	Oracle Linux Engineering
