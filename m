From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_dh_rdac: Add dynamic match functionality to rdac
 handler
Date: Fri, 20 Apr 2012 11:48:17 -0500
Message-ID: <4F919351.3050000@cs.wisc.edu>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com> <1334939232.3420.30.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35002 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab2DTQs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 12:48:28 -0400
In-Reply-To: <1334939232.3420.30.camel@chandra-lucid.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>

On 04/20/2012 11:27 AM, Chandra Seetharaman wrote:
> Babu,
> 
> So, in effect, any SCSI devices with INQ C8 page with "edid" would be
> treated as a rdac device, right ?
> 
> Is that enough to identify _any_ SCSI device as a rdac device (even in
> future) ?
> 
> Also, instead of repeating the code, can you use submit_inquiry() ?
> 

Yeah you are right, I think we should modify submit_inquiry to take in
the sense and data buffers instead of taking in the rdac_dh_data struct.
At the time the match function is run rdac_dh_data might not be allocated.
