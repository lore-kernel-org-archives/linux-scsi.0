From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v6 00/11] SATA ZPODD support
Date: Fri, 29 Jun 2012 11:20:33 +0800
Message-ID: <CAF1ivSYwRFkt4PJ=nMLO=Ux50c9WfCt8VGnuVYLp5HpfA4Cc9Q@mail.gmail.com>
References: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41295 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2F2DUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2012 23:20:34 -0400
In-Reply-To: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org

On Mon, Jun 25, 2012 at 4:13 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi all,
>
> This is the v6 patches to add SATA ZPODD support, to try it:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git=
 zpodd
>
> Holger and Mathtew,
> Patch 1 to Patch 3 are the libata acpi binding patches from you.
> I removed dock related code from your original version.
>
> v6:
> - rebase to v3.5-rc4
> - merge patch 4("libata: use correct PCI devices") with patch 2 (Dan =
Williams)
> - makes ata_acpi_find_device mostly independent of the topology,
> =A0gives some type safety, and drops some redundant work finding the =
ata_port
> =A0(Dan Williams)

Hi Jeff,

Dan has reviewed the changes.

Would you like to apply these v6 patches?

Thanks,
Lin Ming

>
> v5:
> http://lkml.org/lkml/2012/6/18/62
> - rebase to v3.5-rc3
> - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu=
)
> - rename is_pci_ata to compat_pci_ata (Alan Cox)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
