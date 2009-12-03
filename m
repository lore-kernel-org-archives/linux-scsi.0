From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 4/5] libata: Report zeroed read after Trim and max discard
 size
Date: Thu, 03 Dec 2009 02:57:54 -0500
Message-ID: <4B176F82.4050907@pobox.com>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>	<1259254843-8326-5-git-send-email-martin.petersen@oracle.com>	<4B0F3186.6000903@teksavvy.com> <yq18wds3a10.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq18wds3a10.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mark Lord <kernel@teksavvy.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/26/2009 10:46 PM, Martin K. Petersen wrote:
>>>>>> "Mark" == Mark Lord<kernel@teksavvy.com>  writes:
>
> Mark>  Is that correct, or should it be this:
>
> Mark>         if (ata_id_has_trim(id)&&  (id[ATA_ID_ADDITIONAL_SUPP]&
> Mark>         0x4020) == 0x4020)
>
> Good spotting!  You are right, I need both bits to be set...
>
>
> libata: Report zeroed read after Trim and max discard size
>
> Our current Trim payload is a single sector that can accommodate 64 *
> 65535 blocks being unmapped.  Report this value in the Block Limits
> Maximum Unmap LBA count field.
>
> If a storage device supports Trim and the DRAT and RZAT bits are set,
> report TPRZ=1 in Read Capacity(16).
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>

The two libata patches look good.  I need to review the thread one more 
time, and then will apply these...


