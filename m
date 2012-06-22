From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v5 0/13] SATA ZPODD support
Date: Fri, 22 Jun 2012 14:41:29 -0400
Message-ID: <4FE4BC59.20400@pobox.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/18/2012 02:25 AM, Lin Ming wrote:
> Hi all,
>
> This is the v5 patches to add SATA ZPODD support, to try it:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd
>
> Holger and Mathtew,
> Patch 1 to Patch 4 are the libata acpi binding patches from you.
> I removed dock related code from your original version.
> Would you help to review?
>
> v5:
> - rebase to v3.5-rc3
> - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
> - rename is_pci_ata to compat_pci_ata (Alan Cox)
>
> v4:
> https://lkml.org/lkml/2012/5/28/11
> - Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
> - tell scsi layer device supports runtime power off
> - check support for device busy class events

In the case of this patchset, the main worry are the crashes that were 
introduced by the Macht/Garrett patchset.  Finally with v5 that 
longstanding problem has been resolved, so we can move forward and get 
this into linux-next (libata-dev.git#upstream).

	Jeff




