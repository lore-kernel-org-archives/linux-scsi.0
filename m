From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH v2 1/2] scsi: lpfc: Use kzalloc instead of kmalloc
Date: Wed, 16 Dec 2015 15:20:54 -0800
Message-ID: <5671F1D6.70302@avagotech.com>
References: <1445670416-3705-1-git-send-email-punitvara@gmail.com>
 <BF724B49-BF78-472D-B117-87E47780FDCC@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BF724B49-BF78-472D-B117-87E47780FDCC@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Punit Vara <punitvara@gmail.com>
Cc: JBottomley@odin.com, don.brace@pmcs.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

fyi - this patch was just pushed in our 11.0.0.10 patch set - patch 16/17

-- james s



On 10/24/2015 8:25 PM, Matthew R. Ochs wrote:
>> On Oct 24, 2015, at 2:06 AM, Punit Vara <punitvara@gmail.com> wrote:
>>
>> This patch is to the lpfc_els.c which resolves following warning
>> reported by coccicheck:
>>
>> WARNING: kzalloc should be used for rdp_context, instead of
>> kmalloc/memset
>>
>> Signed-off-by: Punit Vara <punitvara@gmail.com>
> Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
