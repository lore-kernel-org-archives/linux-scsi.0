From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Wed, 17 Nov 2010 17:37:36 -0500
Message-ID: <20101117223735.GA514@infradead.org>
References: <1290032322-4899-1-git-send-email-nab@linux-iscsi.org>
 <20101117222752.GA26760@infradead.org>
 <1290032970.31890.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:37:37 -0500
Content-Disposition: inline
In-Reply-To: <1290032970.31890.61.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On Wed, Nov 17, 2010 at 02:29:30PM -0800, Nicholas A. Bellinger wrote:
> Hmmm, this is following jgarzik's recommendation for LLDs that we could
> not immediately identify a internal spin_lock to disable interrupts
> upon.  (eg: not libiscsi and libata).

In that case wait for the driver author to identify it.  If there's
no maintainer in reach chance is the driver doesn't care about the push
down.  No need to rush any of this, do it one driver at a time and get
it right.
