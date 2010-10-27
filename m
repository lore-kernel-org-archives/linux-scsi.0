From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Wed, 27 Oct 2010 09:53:49 +0200
Message-ID: <20101027075349.GA32585@gargoyle.fritz.box>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
 <20101021150840.GA24309@linux.vnet.ibm.com>
 <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
 <1288132071.8283.689.camel@mulgrave.site>
 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
 <1288133450.8283.723.camel@mulgrave.site>
 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
 <1288134713.19649.11.camel@mulgrave.site>
 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0J0Hvf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 03:51:35 -0400
Content-Disposition: inline
In-Reply-To: <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

> This sounds like a pretty reasonable compromise that I think is slightly
> less risky for the LLDs with the ghosts and cob-webs hanging off of
> them.

They won't get tested either next release cycle. Essentially
near nobody uses them.

> 
> What do you think..?

Standard linux practice is to simply push the locks down. That's a pretty
mechanical operation and shouldn't be too risky

With some luck you could even do it with coccinelle.

-Andi
