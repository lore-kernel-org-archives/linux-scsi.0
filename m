From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: continue to boot even with Boot LUN is disabled
Date: Wed, 27 Sep 2017 21:46:16 -0400
Message-ID: <yq1tvzn8ujb.fsf@oracle.com>
References: <1506076307-8462-1-git-send-email-kehuanlin@pinecone.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506076307-8462-1-git-send-email-kehuanlin@pinecone.net>
        (Huanlin Ke's message of "Fri, 22 Sep 2017 18:31:47 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Huanlin Ke <chgokhl@gmail.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kehuanlin@pinecone.net
List-Id: linux-scsi@vger.kernel.org


Huanlin,

> Several configurable fields of the Device Descriptor and the Unit
> Descriptors determine the Boot LUN status. The bBootEnable field and
> the bBootLunEn attribute is set to zero by default, so the Boot LUN is
> disabled by default.
>
> At which point the scsi device add for Boot LUN will fail, but we can
> continue to use the ufs device in fact. This failure shouldn't abort the
> device boot.

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
