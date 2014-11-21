From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 0/7] megaraid_sas : Description Patch
Date: Fri, 21 Nov 2014 14:50:17 +0100
Message-ID: <546F4319.1060705@redhat.com>
References: <201411170957.sAH9vYLa008937@palmhbs0.lsi.com> <CAKYY47Ub-cSATE6kdv=YzW=+zMZW84=oC9kockaD4XwG9UvHpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbaKUNuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 08:50:51 -0500
In-Reply-To: <CAKYY47Ub-cSATE6kdv=YzW=+zMZW84=oC9kockaD4XwG9UvHpQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumitsaxena86@gmail.com>, sumit saxena <Sumit.Saxena@avagotech.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 11/21/2014 12:37 PM, Sumit Saxena wrote:
> On Mon, Nov 17, 2014 at 3:23 PM,  <Sumit.Saxena@avagotech.com> wrote:
>> megaraid_sas driver changes.
>> This resent patch series has some additional changes in few patches on top of last patch series.
>> [PATCH RESNED 1/7] additionally rmeoves some meta data of megaraid_sas driver.
>> [PATCH RESEND 2/7] has additional copyright changes as well.
>> Please consider this patch set for next kernel release.
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>>
>> ---
>> [PATCH RESEND 0/7] megaraid_sas : Description Patch.
>> [PATCH RESEND 1/7] megaraid_sas : Driver version upgrade and remove some meta data of driver.
>> [PATCH RESEND 2/7] megaraid_sas : Update MAINTAINERS and copyright information for megaraid drivers.
>> [PATCH RESEND 3/7] megaraid_sas : Do not process IOCTLs and SCSI commands during driver removal.
>> [PATCH RESEND 4/7] megaraid_sas : Online Firmware upgrade support for Extended VD feature.
>> [PATCH RESEND 5/7] megaraid_sas : Make HBA operational after LD_MAP_SYNC DCMD in OCR path.
>> [PATCH RESEND 6/7] megaraid_sas : Corrected return of wait_event from abort frame path.
>> [PATCH RESEND 7/7] megaraid_sas : Endinaness related bug fixes.
> Tomas,
> This patch series is almost same as last series reviewed by you, only
> two patches(patch#1 and patch#2) are modified
> to accommodate your feedback. Can you provide Reviewed-by tag for this series.

I missed it when it was sent, I think the series is fine now.

>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

