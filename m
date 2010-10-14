From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
Date: Thu, 14 Oct 2010 02:04:21 +0200
Message-ID: <20101014000421.GB15583@lst.de>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org> <20101013110653.GA26366@lst.de> <1287001189.7334.47.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45827 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0JNAEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 20:04:40 -0400
Content-Disposition: inline
In-Reply-To: <1287001189.7334.47.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>

On Wed, Oct 13, 2010 at 01:19:49PM -0700, Nicholas A. Bellinger wrote:
> I should point out that the majority of values mentioned here (other
> than the two INQUIRY strings) are already present in struct
> se_dev_attrib and which appear as configfs attributes under
> under /sys/kernel/config/target/core/$HBA/$DEV/attrib/.  This means that
> the struct se_subsystem_api calls only really used by during init
> target_core_device.c:se_dev_set_default_attribs() and
> DEV_ATTRIB(dev)->block_size, etc are used in TCM Core code.
> 
> I am happy to include the two INQUIRY strings needed for emulation into
> struct se_subsystem_api directly, but I would still prefer to keep the
> function pointers for extracting values from subsystem specific code for
> the initial device attribute setup.

What's the point?  It's a lot of boilerplate code that does nothing
but obsfucating what's actually going on there.

