From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH v4.3-rc7] be2iscsi : Fix bogus WARN_ON length check
Date: Sun, 1 Nov 2015 08:43:59 -0700
Message-ID: <5636333F.7000903@canonical.com>
References: <1446229378-2956-1-git-send-email-tim.gardner@canonical.com>
 <mqdbnbgxec5.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mqdbnbgxec5.fsf@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Minh Tran <minh.tran@avagotech.com>, John Soni Jose <sony.john-n@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2015 02:59 PM, Johannes Thumshirn wrote:
> Hi Tim,
> tim.gardner@canonical.com writes:
> 
>> From: Tim Gardner <tim.gardner@canonical.com>
>>
>> drivers/scsi/be2iscsi/be_main.c: In function 'be_sgl_create_contiguous':
>> drivers/scsi/be2iscsi/be_main.c:3187:18: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
>>   WARN_ON(!length > 0);
>>
>> gcc version 5.2.1
> 
> This patch (or similar) was already posted on Oct 1 by Joel Stanley.
> See http://comments.gmane.org/gmane.linux.scsi/105462
> 
> Thanks,
>         Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Mechanical application of prarens makes that expression more complicated
then it needs to be. It is, after all, an unsigned integer.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
