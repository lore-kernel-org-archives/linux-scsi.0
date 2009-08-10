From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/3] SCSI: Allow platform-specific code to be run
	against the SCSI tree
Date: Mon, 10 Aug 2009 14:38:15 +0100
Message-ID: <20090810133815.GB22763@srcf.ucam.org>
References: <1247518987-10818-1-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1247518987-10818-1-git-send-email-mjg@redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, shaohua.li@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 13, 2009 at 10:03:05PM +0100, Matthew Garrett wrote:
> In certain cases (such as ACPI) we want to be able to associate
> platform-specific data against the SCSI device tree. Handling this
> properly requires the ability to run platform code at SCSI init time.
> This patch adds stub functions that can be overridden if the platform
> defines CONFIG_SCSI_PLATFORM.

James, any thoughts on this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
