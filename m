From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: megaraid: Track the page allocations for struct fusion_context
Date: Wed, 25 Oct 2017 08:36:39 -0400
Message-ID: <yq17evjieug.fsf@oracle.com>
References: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
	<1508925428-51660-2-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1508925428-51660-2-git-send-email-xieyisheng1@huawei.com>
	(Yisheng Xie's message of "Wed, 25 Oct 2017 17:57:08 +0800")
Sender: owner-linux-mm@kvack.org
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shu Wang <shuwang@redhat.com>
List-Id: linux-scsi@vger.kernel.org


Yisheng,

> I have get many kmemleak reports just similar to commit 70c54e210ee9
> (scsi: megaraid_sas: fix memleak in megasas_alloc_cmdlist_fusion)
> on v4.14-rc6, however it seems have a different stroy:

Do you still see leaks reported with the megaraid driver update recently
merged into 4.15/scsi-queue?

-- 
Martin K. Petersen	Oracle Linux Engineering

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
