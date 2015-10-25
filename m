From: punit vara <punitvara@gmail.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: Use kzalloc instead of kmalloc
Date: Sun, 25 Oct 2015 14:47:56 +0530
Message-ID: <CABXAfNJSpttL=jGL1CwQ0CWQis_zEiXMTedcujZb7vcZEJtDmQ@mail.gmail.com>
References: <1445630633-14209-1-git-send-email-punitvara@gmail.com>
	<1445630633-14209-2-git-send-email-punitvara@gmail.com>
	<C55884B0-E8D4-4EE2-AB46-40A871F8A073@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C55884B0-E8D4-4EE2-AB46-40A871F8A073@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: JBottomley@odin.com, don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 24, 2015 at 4:56 AM, Matthew R. Ochs
<mrochs@linux.vnet.ibm.com> wrote:
> Hi Punit,
>
> Aren't you missing the removal of the memset() as part of this conversion?
>
>
> -matt
>
>> On Oct 23, 2015, at 3:03 PM, Punit Vara <punitvara@gmail.com> wrote:
>>
>> This patch is to the lpfc_els.c which resolves following warning
>> reported by coccicheck:
>>
>> WARNING: kzalloc should be used for rdp_context, instead of
>> kmalloc/memset
>>
>> Signed-off-by: Punit Vara <punitvara@gmail.com>
>> ---
>> drivers/scsi/lpfc/lpfc_els.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
>> index 36bf58b..422c800 100644
>> --- a/drivers/scsi/lpfc/lpfc_els.c
>> +++ b/drivers/scsi/lpfc/lpfc_els.c
>> @@ -4990,7 +4990,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>>       if (RDP_NPORT_ID_SIZE !=
>>                       be32_to_cpu(rdp_req->nport_id_desc.length))
>>               goto rjt_logerr;
>> -     rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
>> +     rdp_context = kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
>>       if (!rdp_context) {
>>               rjt_err = LSRJT_UNABLE_TPC;
>>               goto error;
>
Thanks for reviewing my patches.
Can I send more patches ? my all previous patches already reviewed by
you . Should I wait to apply this patch to tree or i can send new
patch set ? Please suggest me sir.
