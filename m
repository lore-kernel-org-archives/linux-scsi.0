From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh_rdac: Add dynamic match functionality to rdac
 handler
Date: Fri, 20 Apr 2012 13:05:30 -0500
Message-ID: <1334945131.3420.33.camel@chandra-lucid.austin.ibm.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com>
	 <1334939232.3420.30.camel@chandra-lucid.austin.ibm.com>
	 <4F919351.3050000@cs.wisc.edu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:53459 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2DTSGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2012 14:06:43 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <sekharan@us.ibm.com>;
	Fri, 20 Apr 2012 12:06:41 -0600
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id B8980C90060
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 14:06:09 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3KI6AGH266156
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 14:06:11 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3KI5WQQ024192
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 12:05:32 -0600
In-Reply-To: <4F919351.3050000@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>

On Fri, 2012-04-20 at 11:48 -0500, Mike Christie wrote:
> On 04/20/2012 11:27 AM, Chandra Seetharaman wrote:
> > Babu,
> > 
> > So, in effect, any SCSI devices with INQ C8 page with "edid" would be
> > treated as a rdac device, right ?
> > 
> > Is that enough to identify _any_ SCSI device as a rdac device (even in
> > future) ?
> > 
> > Also, instead of repeating the code, can you use submit_inquiry() ?
> > 
> 
> Yeah you are right, I think we should modify submit_inquiry to take in
> the sense and data buffers instead of taking in the rdac_dh_data struct.
> At the time the match function is run rdac_dh_data might not be allocated.

oh yeah,

I did not not realize that...
> 


