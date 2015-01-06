From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 0/2] Add the PMP support for APM X-Gene SoC AHCI SATA
 Host Controller driver.
Date: Tue, 6 Jan 2015 08:41:54 -0500
Message-ID: <20150106134154.GC3077@htj.dyndns.org>
References: <1420538536-32165-1-git-send-email-stripathi@apm.com>
 <20150106125252.GB3077@htj.dyndns.org>
 <CAOHikRBs=tH+MTPTmhDkEpV67grLWJK+6a-i8qeMyx_dJ9oyeA@mail.gmail.com>
 <CAOHikRAcSnD=5gvNkNZz8vUXTjkXQo8W4-KQcGajMeajxd73HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRAcSnD=5gvNkNZz8vUXTjkXQo8W4-KQcGajMeajxd73HQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 06, 2015 at 07:10:31PM +0530, Suman Tripathi wrote:
> Hi ,
> 
> For more info here is the git log output before applying the patch.
> 
> git log
> 
> commit b84b25cb0900b99b28c742dd33101be779f58259
> Merge: 0628ee7 36aae28
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Jan 6 07:48:24 2015 -0500
>  Merge branch 'for-3.19-fixes' of git://git.kernel.org/pub/scm/linux/kernel/g
> 
>     Pull to receive the following two ahci_xgene fixes for the planned
>     xgene PMP support patches.
> 
>      5c0b8e0de76a8 ("ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI
>      1102407bb714d ("ahci_xgene: Fix the DMA state machine lockup for the ATA_CM
> 
>     Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> commit 36aae28e3df4127e296f2680d65cb6310ce61021
> Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date:   Fri Dec 12 17:16:31 2014 +0200
> 
>     libata: export ata_get_cmd_descript()
> 
>     The driver sata_dwc_460ex is using this symbol. To build it as a
>     module we have to have the symbol exported. This patch adds
> Broken pipe

Ah, this was me being stupid.  I was using the old patches.  Sorry
about that.  Applied to libata/for-3.20.

Thanks.

-- 
tejun
