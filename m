From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/10] handles queue_depth adjustments in scsi_error.c
Date: Tue, 13 Oct 2009 16:59:27 -0500
Message-ID: <1255471167.2855.502.camel@localhost.localdomain>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49417 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761475AbZJMWAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:00:06 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Thu, 2009-09-03 at 15:22 -0700, Vasu Dev wrote:
> This patch series moves the QUEUE_FULL and then the ramp
> up code from drivers like qla2xxx and lpfc to scsi-ml.
> The change_queue_depth callback is used to allow the
> drivers to adjust the queue depth, so LLDs do not have
> to worry about parsing the sense, see some additional
> info on these changes in first RFC cover at:-
> 
> http://www.spinics.net/lists/linux-scsi/msg35959.html
> 
> I've tested this series with libfc/fcoe for queue_depth
> ramp down and up.
> 
> This series is based on scsi-misc -rc7 and also cleanly
> applies & works on top recently submitted 64 fcoe patches
> series by Rob "[PATCH 00/64] libfc, libfcoe and fcoe
> updates for scsi-misc"
> 
> I'm posting this series with Mike and Christof patches
> per this mail thread discussion
> http://marc.info/?l=linux-scsi&m=125196587107768&w=2
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>

OK, so this patch series isn't bisectable.  If I just apply 1  it won't
compile.

To get to bisectability it looks like patches 1,3,4 need combining. It
also looks like 5,6,7 are all really the same change, so could be
combined.

Could you repost with at least the bisectability fixed?

Thanks,

James




