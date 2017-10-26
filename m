From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: Re: [PATCH 2/2] scsi: megaraid: Track the page allocations for struct
 fusion_context
Date: Thu, 26 Oct 2017 09:17:29 +0800
Message-ID: <5a4a6b21-bd94-910a-a278-265b848a50a5@huawei.com>
References: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
 <1508925428-51660-2-git-send-email-xieyisheng1@huawei.com>
 <yq17evjieug.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <yq17evjieug.fsf@oracle.com>
Sender: owner-linux-mm@kvack.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shu Wang <shuwang@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Martin K. Petersen，

Thanks for comment!
On 2017/10/25 20:36, Martin K. Petersen wrote:
> 
> Yisheng,
> 
>> I have get many kmemleak reports just similar to commit 70c54e210ee9
>> (scsi: megaraid_sas: fix memleak in megasas_alloc_cmdlist_fusion)
>> on v4.14-rc6, however it seems have a different stroy:
> 
> Do you still see leaks reported with the megaraid driver update recently
> merged into 4.15/scsi-queue?

No, the related code have been optimized, sorry to disturb. Please ignore
this one.

Thanks
Yisheng Xie


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
