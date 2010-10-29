From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Fri, 29 Oct 2010 09:50:19 +0200
Message-ID: <20101029075019.GC8287@gargoyle.fritz.box>
References: <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
 <1288133450.8283.723.camel@mulgrave.site>
 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
 <1288134713.19649.11.camel@mulgrave.site>
 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
 <20101027075349.GA32585@gargoyle.fritz.box>
 <1288189658.4692.13.camel@mulgrave.site>
 <20101028091020.GA7906@gargoyle.fritz.box>
 <4CC95BE8.3000909@panasas.com>
 <1288297634.5169.302.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab0J2HsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2010 03:48:08 -0400
Content-Disposition: inline
In-Reply-To: <1288297634.5169.302.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@suse.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, julia@diku.dk

> I would have to agree that approach does make a bit more sense..  Now
> can some brave soul (/me looks at ak) code another script to automate
> this for the identified legacy LLDs cases that need push down..?

For the drivers I looked at it doesn't really make too much difference,
I don't think there was any with a really large number of returns.
You can see that in the diffstat for the full changes.

Writing another script is probably not too hard, but the problem
is that I needed a significant amount of manual post processing
(both the select the right files to patch and to get rid
of misplaced newlines and some mismatches in cocci) 
So it's not a fully automated procedure.

-Andi

