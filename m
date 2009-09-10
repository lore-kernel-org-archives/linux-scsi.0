From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 09/10] libfc: adds queue_depth ramp up to libfc
Date: Thu, 10 Sep 2009 15:18:43 -0700
Message-ID: <1252621123.3384.10367.camel@fritz>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
	 <20090903222315.24946.63010.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62205 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZIJWSk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2009 18:18:40 -0400
In-Reply-To: <20090903222315.24946.63010.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dev, Vasu" <vasu.dev@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Thu, 2009-09-03 at 15:23 -0700, Dev, Vasu wrote:
> Increases queue_depth by one on fc_change_queue_depth call back
> with reason SCSI_QDEPTH_RAMP_UP.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>

Acked-by: Robert Love <robert.w.love@intel.com>


