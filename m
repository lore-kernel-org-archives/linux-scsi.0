From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 08/10] fcoe,	libfc: fix an libfc issue with queue ramp
 down in libfc
Date: Thu, 10 Sep 2009 15:15:30 -0700
Message-ID: <1252620930.3384.10362.camel@fritz>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
	 <20090903222310.24946.70140.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46360 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZIJWP1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2009 18:15:27 -0400
In-Reply-To: <20090903222310.24946.70140.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dev, Vasu" <vasu.dev@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Thu, 2009-09-03 at 15:23 -0700, Dev, Vasu wrote:
> The cmd_per_lun value is used by scsi-ml as fall back lowest
> queue_depth value but in case of libfc cmd_per_lun is set to
> same value as max queue_depth = 32.
> 
> So this patch reduces cmd_per_lun value to 3 and configures
> each lun with default max queue_depth 32 in fc_slave_alloc.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>

Acked-by: Robert Love <robert.w.love@intel.com>


