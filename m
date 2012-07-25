From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [git patches] libata updates
Date: Wed, 25 Jul 2012 17:38:15 -0400
Message-ID: <50106747.8070501@pobox.com>
References: <20120725203551.GA19762@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120725203551.GA19762@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>, Aaron Lu <aaron.lu@amd.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 04:35 PM, Jeff Garzik wrote:
>
> Please pull 641589bff714f39b33ef1d7f02eaa009f2993b64 from
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream
>
> (text copied from the upstream-linus tag)
> Notable changes:
>
> * Updating libata to directly bind with ACPI / runtime power mgmt.
>    This is a pre-req for SATA ZPODD (CD-ROM power management).
>
>    Touches ACPI (exports++) and SCSI in minor ways.  Has been in linux-next
>    for weeks.
>
>    The rest of [ZPODD] will probably come via SCSI tree, as it involves
>    a lot of updates to the 'sr' driver etc.

BTW Lin and Aaron, note that this did not include these changes:

       sr: check support for device busy class events
       sr: support zero power ODD
       sr: make sure ODD is in resumed state in block ioctl

as in the end I wanted to put the brakes on SCSI-touching patches. 
These should be able to go into James' scsi-misc tree with the other 
SCSI-area ZPODD changes.

For those three 'sr' changes listed above, you may add

	Acked-by: Jeff Garzik <jgarzik@redhat.com>

when moving them over.

	Jeff
