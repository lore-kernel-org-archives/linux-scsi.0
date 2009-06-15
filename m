From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
	automatically inserted
Date: Mon, 15 Jun 2009 16:14:15 -0700
Message-ID: <1245107655.24869.0.camel@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
	 <4A369320.2080202@redhat.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60329 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZFOXMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 19:12:21 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5FN8I0k020890
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 17:08:18 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5FNCO9w169506
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 17:12:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5FNCN1t007015
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 17:12:24 -0600
In-Reply-To: <4A369320.2080202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, hare@suse.de


On Mon, 2009-06-15 at 14:29 -0400, Peter Jones wrote:
> On 04/27/2009 02:06 PM, Chandra Seetharaman wrote:
> > Hello,
> > 
> > Currently, SCSI targets doesn't have modalias support. It wasn't an issue
> > until SCSI device handler came along.
> > 
> > We want the SCSI device handler modules to be insmodded automatically
> > when the specific SCSI targets are probed and found.
> > 
> > This set of patches adds the modalias support for SCSI targets and
> > also makes the relevant changes to SCSI device handler modules to 
> > make use of it.
> > 
> > Applies cleanly on 2.6.30-rc3 and is tested on the same.
> > 
> > Please review and consider this for inclusion.
> > 
> > Originally sent on March 17 2009 (http://marc.info/?l=linux-scsi&m=123734001009654&w=2).
> > 
> > Resending after testing on 2.6.30-rc3 and with an ack from Hannes.
> 
> Was there ever any followup to this?

Nope.
> 

