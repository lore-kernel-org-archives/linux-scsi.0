From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: some iscsi vendor has been hitting a crash
Date: Fri, 1 Nov 2013 22:28:16 +0100
Message-ID: <20131101212816.GA27918@glanzmann.de>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
 <5273BEBF.2090008@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from infra.glanzmann.de ([78.47.70.69]:56152 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3KAV2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 17:28:20 -0400
Content-Disposition: inline
In-Reply-To: <5273BEBF.2090008@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>

Hello Mike,

* Mike Christie <michaelc@cs.wisc.edu> [2013-11-01 15:56]:
> On a related note, some iscsi vendor has been hitting a crash with
> your tree.

I hit an 'IO stall' with the tree, but was not able to reproduce this.
Has this vendor information on it (dmesg, OOPS)? I reverted back to
RTSOS for production classes that I do not give myself, but will run the
Nab's tree as soon as I give a VMware class myself in order to reproduce
the issue and than track it down.

Cheers,
        Thomas
