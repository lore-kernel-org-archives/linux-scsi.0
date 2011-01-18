From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: Fix tcm_mod_builder.py default EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 22:47:26 +0100
Message-ID: <20110118214726.GA13329@lst.de>
References: <1295386222-12869-1-git-send-email-nab@linux-iscsi.org> <20110118213604.GA13063@lst.de> <1295387162.22813.454.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59052 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1ARVrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 16:47:31 -0500
Content-Disposition: inline
In-Reply-To: <1295387162.22813.454.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jan 18, 2011 at 01:46:02PM -0800, Nicholas A. Bellinger wrote:
> This is correct on the -I$(srctree)/include/, and I will drop this as
> well..  However with the current fabric module include layout (all .h
> living in drivers/target/$FABRIC_MOD), the latter bit is still required
> AFAICS to build.

No, there's no need.  Just use ""-style includes and they'll always get
picked up in the local directory.

