From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: megaraid: Track the page allocations for struct fusion_context
Date: Tue, 31 Oct 2017 08:15:32 -0400
Message-ID: <yq160avecnv.fsf@oracle.com>
References: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
        <1508925428-51660-2-git-send-email-xieyisheng1@huawei.com>
        <yq17evjieug.fsf@oracle.com>
        <25c40edd-7c4a-5e6a-2079-6ffd356da7e8@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25c40edd-7c4a-5e6a-2079-6ffd356da7e8@huawei.com> (Yisheng Xie's
        message of "Sat, 28 Oct 2017 08:28:12 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Shu Wang <shuwang@redhat.com>
List-Id: linux-scsi@vger.kernel.org


Yisheng,

>> Do you still see leaks reported with the megaraid driver update recently
>> merged into 4.15/scsi-queue?
>> 
> No, the related code have been optimized and __get_free_pages is not used
> to allocate fusion_context anymore. So, please ignore this one, and sorry
> for disturbing.
>
> BTW, what about the Patch 1/2, which is just a minor clean up?

Kashyap? Shivasharan? Sumit?

-- 
Martin K. Petersen	Oracle Linux Engineering
