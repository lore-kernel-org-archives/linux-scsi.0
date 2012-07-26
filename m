From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [git patches] libata updates
Date: Thu, 26 Jul 2012 12:47:54 +0800
Message-ID: <5010CBFA.8020907@amd.com>
References: <20120725203551.GA19762@havoc.gtf.org> <50106747.8070501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50106747.8070501@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Lin Ming <minggr@gmail.com>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/26/2012 05:38 AM, Jeff Garzik wrote:
> On 07/25/2012 04:35 PM, Jeff Garzik wrote:
>> * Updating libata to directly bind with ACPI / runtime power mgmt.
>> This is a pre-req for SATA ZPODD (CD-ROM power management).
>>
>> Touches ACPI (exports++) and SCSI in minor ways. Has been in linux-next
>> for weeks.
>>
>> The rest of [ZPODD] will probably come via SCSI tree, as it involves
>> a lot of updates to the 'sr' driver etc.
>
> BTW Lin and Aaron, note that this did not include these changes:
>
> sr: check support for device busy class events
> sr: support zero power ODD
> sr: make sure ODD is in resumed state in block ioctl
>
> as in the end I wanted to put the brakes on SCSI-touching patches. These
> should be able to go into James' scsi-misc tree with the other SCSI-area
> ZPODD changes.
>
> For those three 'sr' changes listed above, you may add
>
> Acked-by: Jeff Garzik <jgarzik@redhat.com>
>
> when moving them over.

Thanks Jeff.

Hi James,
I'll prepare these dropped patches plus some other fixes for ZPODD which
I've sent v2 recently and merge them into v3 for you to review.

Thanks,
Aaron
