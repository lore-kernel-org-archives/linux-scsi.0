From: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/3] SCSI: Allow platform-specific code to be run
	against the SCSI tree
Date: Mon, 10 Aug 2009 15:58:09 +0100
Message-ID: <20090810145809.GD24956@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com> <20090810133815.GB22763@srcf.ucam.org> <1249916125.4089.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1249916125.4089.4.camel@mulgrave.site>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, shaohua.li@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 10, 2009 at 02:55:25PM +0000, James Bottomley wrote:
> On Mon, 2009-08-10 at 14:38 +0100, Matthew Garrett wrote:
> > On Mon, Jul 13, 2009 at 10:03:05PM +0100, Matthew Garrett wrote:
> > > In certain cases (such as ACPI) we want to be able to associate
> > > platform-specific data against the SCSI device tree. Handling this
> > > properly requires the ability to run platform code at SCSI init time.
> > > This patch adds stub functions that can be overridden if the platform
> > > defines CONFIG_SCSI_PLATFORM.
> > 
> > James, any thoughts on this?
> 
> Sorry, I'd thought this had all moved to libata so I'd stopped paying
> attention ... why are extra bits in SCSI necessary?

They're SCSI as far as the device tree is concerned, so the glue 
callbacks have to be registered from the SCSI layer. The only 
implementation so far is for ACPI and only covers libata, but it could 
potentially also be used to tie bay devices to the ofw tree on 
openfirmware systems.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
