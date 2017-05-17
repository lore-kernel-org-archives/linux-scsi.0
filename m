From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/22] hisi_sas: hip08 support
Date: Wed, 17 May 2017 14:38:52 +0200
Message-ID: <CAK8P3a0=QtVNQ0JUxo8=YKeWN38_+LVfUqW_8xTtSRAkZ-=HRQ@mail.gmail.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33859 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754074AbdEQMix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 08:38:53 -0400
In-Reply-To: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com> wrote:
> This patchset adds support for the HiSilicon SAS controller
> in the hip08 chipset.
>
> The key difference compared to earlier chipsets is that the
> controller is an integrated PCI endpoint in hip08.
> As such, the controller is a pci device (not a platform device,
> like v2 hw in hip07).
>
> The driver is refactored so it can support both platform and
> pci device-based controllers.
>
> File hisi_sas_pci_init.c is introduced for pci device probing
> and initialization. Common functionality is still in
> hisi_sas_main.c, along with platform device probing and
> initialization.
>
> New hw layer file hisi_sas_v3_hw.c is added for hip08
> controller support. HW revisions v2 and v3 are very similar,
> but it was decided to keep support in separate files for now.
>
> As for the patches, (ignoring #1 and #2) the first few
> reorganise some functions from v2 hw.c into main.c, as they
> are required for v3 hw. Then support is added for pci
> device-based controller in subsequent patches.
> And then hip08 support is added in the final patches.

Looks good overall, but I have some high-level comments
on a couple of patches. I'm sure we can resolve them all
easily.

      Arnd
