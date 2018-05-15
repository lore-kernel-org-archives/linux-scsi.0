From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptlan: fix mpt_lan_sdu_send()'s return type
Date: Mon, 14 May 2018 22:51:38 -0400
Message-ID: <yq136ytmy11.fsf@oracle.com>
References: <20180424131558.3010-1-luc.vanoostenryck@gmail.com>
        <yq1h8niyb63.fsf@oracle.com>
        <20180508154415.neutsgpi2nwffwec@ltop.local>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508154415.neutsgpi2nwffwec@ltop.local> (Luc Van
        Oostenryck's message of "Tue, 8 May 2018 17:44:16 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Luc,

>> You forgot to update the function prototype accordingly.
>
> Hmmm, the function mpt_lan_sdu_send() has no other declaration
> than the one I modified the return type in this patch.
>
> Must be a misunderstanding somewhere.

My bad, I thought you were updating mpt_lan_send_reply().

Applied to 4.18/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
