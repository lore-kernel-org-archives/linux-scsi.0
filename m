From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi/lpfc/lpfc_sli.c: Use dma_zalloc_coherent
Date: Wed, 21 Nov 2018 07:56:24 +0000
Message-ID: <5229ccbb-e6de-e114-52fb-235ea703a7ef@huawei.com>
References: <5bf1797b.1c69fb81.2368c.1ccc@mx.google.com>
 <16c3b882-6e0e-b712-b4d6-78f68172da65@huawei.com>
 <34556d50-562b-43b2-873f-ba68056e5af5@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <34556d50-562b-43b2-873f-ba68056e5af5@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 20/11/2018 21:52, James Smart wrote:
> On 11/20/2018 1:40 AM, John Garry wrote:
>>
>> please ensure that you maintain alignment with opening brackets
>
> I don't think this is a requirement.  From the rules I've read
> preference is tabs-only indentation.

This is the only rule (enforcement) I see:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20181120&id=d1fe9c099cecc6e49324355f1b15573e9dbbe0f9

Spacing (less than a tab), after
> tabs, for open brace alignment is allowed, thus is coder's choice.

It seems that alignment was being implemented with tab+space, and now it 
would be tab+space but no alignment.

cheers,
John

>
> -- james
>
>
>
>
>
>
>
