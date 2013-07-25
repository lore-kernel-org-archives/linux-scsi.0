From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 1/2] ata: acpi: remove dead code for ata_acpi_(un)bind
Date: Thu, 25 Jul 2013 10:50:14 -0400
Message-ID: <20130725145014.GA26107@mtj.dyndns.org>
References: <1374731223-28685-1-git-send-email-aaron.lu@intel.com>
 <1374731223-28685-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374731223-28685-2-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 25, 2013 at 01:47:02PM +0800, Aaron Lu wrote:
> Commit 7381fe737 "libata-acpi: remove redundent code for power resource
> handling" removed ata_acpi_(un)bind but left their prototypes in libata.h,
> so remove them.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Applied to libata/for-3.12.

Thanks.

-- 
tejun
