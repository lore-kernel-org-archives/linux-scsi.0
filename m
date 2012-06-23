From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 0/13] SATA ZPODD support
Date: Sat, 23 Jun 2012 09:05:58 +0800
Message-ID: <1340413558.2672.8.camel@hp6530s>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	 <4FE4BC59.20400@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4FE4BC59.20400@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-06-22 at 14:41 -0400, Jeff Garzik wrote:
> On 06/18/2012 02:25 AM, Lin Ming wrote:
> > Hi all,
> >
> > This is the v5 patches to add SATA ZPODD support, to try it:
> > git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd
> >
> > Holger and Mathtew,
> > Patch 1 to Patch 4 are the libata acpi binding patches from you.
> > I removed dock related code from your original version.
> > Would you help to review?
> >
> > v5:
> > - rebase to v3.5-rc3
> > - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
> > - rename is_pci_ata to compat_pci_ata (Alan Cox)
> >
> > v4:
> > https://lkml.org/lkml/2012/5/28/11
> > - Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
> > - tell scsi layer device supports runtime power off
> > - check support for device busy class events
> 
> In the case of this patchset, the main worry are the crashes that were 
> introduced by the Macht/Garrett patchset.  Finally with v5 that 
> longstanding problem has been resolved, so we can move forward and get 
> this into linux-next (libata-dev.git#upstream).

I'm so glad to move forward.
I have some update suggested by Dan Williams, at
https://lkml.org/lkml/2012/6/21/26

I'll send out v6 for you to apply next Monday.

Thanks,
Lin Ming

> 
> 	Jeff



