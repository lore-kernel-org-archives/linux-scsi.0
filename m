From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules automatically
 inserted
Date: Mon, 15 Jun 2009 14:29:52 -0400
Message-ID: <4A369320.2080202@redhat.com>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbZFOS35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 14:29:57 -0400
In-Reply-To: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, hare@suse.de

On 04/27/2009 02:06 PM, Chandra Seetharaman wrote:
> Hello,
> 
> Currently, SCSI targets doesn't have modalias support. It wasn't an issue
> until SCSI device handler came along.
> 
> We want the SCSI device handler modules to be insmodded automatically
> when the specific SCSI targets are probed and found.
> 
> This set of patches adds the modalias support for SCSI targets and
> also makes the relevant changes to SCSI device handler modules to 
> make use of it.
> 
> Applies cleanly on 2.6.30-rc3 and is tested on the same.
> 
> Please review and consider this for inclusion.
> 
> Originally sent on March 17 2009 (http://marc.info/?l=linux-scsi&m=123734001009654&w=2).
> 
> Resending after testing on 2.6.30-rc3 and with an ack from Hannes.

Was there ever any followup to this?

-- 
        Peter
