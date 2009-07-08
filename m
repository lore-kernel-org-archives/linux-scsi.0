From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
	automatically inserted
Date: Wed, 8 Jul 2009 11:58:08 -0400
Message-ID: <20090708155808.GA31204@infradead.org>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu> <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site> <4A3BDFE8.3090003@redhat.com> <4A44D37A.10903@redhat.com> <1246986723.6277.63.camel@mulgrave.site> <4A538B13.8050809@redhat.com> <1246990464.6277.74.camel@mulgrave.site> <1246995401.9541.15.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZGHP6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 11:58:12 -0400
Content-Disposition: inline
In-Reply-To: <1246995401.9541.15.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Jones <pjones@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

On Tue, Jul 07, 2009 at 12:36:41PM -0700, Chandra Seetharaman wrote:
> I do not know of all the out-of-tree multipath solutions and how they
> behave and at what layer they interact. In effect, I haven't tested
> hardware handler with other multipath solutions.

It doesn't matter anyway.  We've never cared about these out of tree
problems and they'll have to find a way by themselves to deal with any
changes we do to offer better multipath support upstream.

