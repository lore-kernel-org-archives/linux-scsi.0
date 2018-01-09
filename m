From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 7/9] scsi: bnx2fc: Use zeroing allocator rather than allocator/memset
Date: Mon, 08 Jan 2018 22:35:16 -0500
Message-ID: <yq1tvvvn1qj.fsf@oracle.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
        <1514647712-6332-8-git-send-email-himanshujha199640@gmail.com>
        <yq1o9mauoz3.fsf@oracle.com>
        <20180104073831.GA5862@himanshu-Vostro-3559>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180104073831.GA5862@himanshu-Vostro-3559> (Himanshu Jha's
        message of "Thu, 4 Jan 2018 13:08:31 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, aacraid@adaptec.com, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Himanshu,

> scsi: qedi: Use zeroing allocator instead of allocator/memset --Resend
> scsi: mvsas: Use zeroing allocator rather than allocator/memset
> scsi: fnic: Use zeroing allocator rather than allocator/memset
> scsi: dpt_i2o: Use zeroing allocator rather than allocator/memset
> scsi: bnx2fc: Use zeroing allocator rather than allocator/memset --Resend
>
> But do I also need to send those mentioned above, which didn't receive
> any response from you ?

I typically only merge cleanup patches if the driver maintainer acks
them. So you should poke the relevant maintainers.

-- 
Martin K. Petersen	Oracle Linux Engineering
