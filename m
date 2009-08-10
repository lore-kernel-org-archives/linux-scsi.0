From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] SCSI: Allow platform-specific code to be run
 against the SCSI tree
Date: Mon, 10 Aug 2009 14:55:25 +0000
Message-ID: <1249916125.4089.4.camel@mulgrave.site>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
	 <20090810133815.GB22763@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752840AbZHJOza@vger.kernel.org>
In-Reply-To: <20090810133815.GB22763@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, shaohua.li@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-08-10 at 14:38 +0100, Matthew Garrett wrote:
> On Mon, Jul 13, 2009 at 10:03:05PM +0100, Matthew Garrett wrote:
> > In certain cases (such as ACPI) we want to be able to associate
> > platform-specific data against the SCSI device tree. Handling this
> > properly requires the ability to run platform code at SCSI init time.
> > This patch adds stub functions that can be overridden if the platform
> > defines CONFIG_SCSI_PLATFORM.
> 
> James, any thoughts on this?

Sorry, I'd thought this had all moved to libata so I'd stopped paying
attention ... why are extra bits in SCSI necessary?

James
