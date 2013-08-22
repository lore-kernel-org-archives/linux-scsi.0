From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 2/2] ata: acpi: rework the ata acpi bind support
Date: Thu, 22 Aug 2013 14:36:18 -0400
Message-ID: <20130822183618.GB3490@mtj.dyndns.org>
References: <1374731223-28685-1-git-send-email-aaron.lu@intel.com>
 <1374731223-28685-3-git-send-email-aaron.lu@intel.com>
 <20130725145229.GB26107@mtj.dyndns.org>
 <520C2FE8.90009@intel.com>
 <20130815031954.GB4439@htj.dyndns.org>
 <5215BA84.20000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5215BA84.20000@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Dirk Griesbach <spamthis@freenet.de>, Dimitris Damigos <damigos@freemail.gr>, Dan van der Ster <dan@vanderster.com>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>, Shane Huang <shane.huang@amd.com>, Matthew Garrett <mjg@redhat.com>, Holger Macht <holger@homac.de>, Zhang Rui <rui.zhang@intel.com>, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Aaron.

On Thu, Aug 22, 2013 at 03:15:16PM +0800, Aaron Lu wrote:
> The patch series has two patches and the first has been taken, shall I
> send the 2nd one again without the RFC tag in the patch subject? There
> should be no other changes at the moment.

Yes, that was a request for you to send an updated patch.  I'm okay
with taking some risk with ACPI support for PMPs.  It most likely
won't matter as long as the code itself doesn't oops anyway, but can
you please describe what's tested and what's not but should be okay in
the patch description?

Thanks.

-- 
tejun
