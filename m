From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Wed, 21 Oct 2009 21:06:08 -0400
Message-ID: <20091022010608.GA10445@infradead.org>
References: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZJVBGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 21:06:05 -0400
Content-Disposition: inline
In-Reply-To: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com

On Wed, Oct 21, 2009 at 09:22:40AM -0700, Chandra Seetharaman wrote:
> Hello All,
> 
> Currently, device handlers process path activation in series. This leads
> to a lot of time delay when more than 100 luns are involved. For example,
> with lsi rdac 100+ luns take about 12-15 minutes. This was found by Moger
> Babu of LSI.

So what happened to the suggestion to just switch over per target
instead of per lun?   It's the obviously much better way to do, and
unless there are bugs in the hardware preventing it from working it
should be the way to go.

