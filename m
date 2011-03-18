From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
Date: Fri, 18 Mar 2011 15:09:24 +0100
Message-ID: <20110318140924.GA29373@lst.de>
References: <1300396040-24253-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41463 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1CROJY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 10:09:24 -0400
Content-Disposition: inline
In-Reply-To: <1300396040-24253-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>

Now that everything is in one C file all functions can be marked static,
and there is no need to have prototypes in the header file.

