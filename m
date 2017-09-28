From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: fix wrong command type of UTRD for UFSHCI v2.1
Date: Wed, 27 Sep 2017 21:47:25 -0400
Message-ID: <yq1poab8uhe.fsf@oracle.com>
References: <1504691919-30832-1-git-send-email-kehuanlin@pinecone.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504691919-30832-1-git-send-email-kehuanlin@pinecone.net>
        (kehuanlin's message of "Wed, 6 Sep 2017 17:58:39 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: kehuanlin <chgokhl@gmail.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kehuanlin@pinecone.net
List-Id: linux-scsi@vger.kernel.org


kehuanlin,

> Since the command type of UTRD in UFS 2.1 specification is the same with
> UFS 2.0. And it assumes the future UFS specification will follow the same
> definition.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
