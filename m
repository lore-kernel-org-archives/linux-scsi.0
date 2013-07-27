From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC PATCH 2/2] ata: acpi: rework the ata acpi bind support
Date: Sat, 27 Jul 2013 07:34:21 +0100
Message-ID: <20130727063421.GA7393@srcf.ucam.org>
References: <1374731223-28685-1-git-send-email-aaron.lu@intel.com>
 <1374731223-28685-3-git-send-email-aaron.lu@intel.com>
 <20130725145229.GB26107@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130725145229.GB26107@mtj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 25, 2013 at 10:52:29AM -0400, Tejun Heo wrote:
> 
> I like it but am wondering why we weren't doing this before.  Was the
> acpi support added before we made ata objects proper devices?

Yes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
