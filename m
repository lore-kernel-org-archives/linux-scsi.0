From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] bfa: Files to support BFA debugfs node creation,
	node query and node deletion.
Date: Tue, 12 Jan 2010 03:52:28 -0500
Message-ID: <20100112085228.GA21015@infradead.org>
References: <1263254172-18675-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0ALIwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2010 03:52:32 -0500
Content-Disposition: inline
In-Reply-To: <1263254172-18675-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com, huangj@brocade.com, xmzhang@brocade.com

Please add documentation for each file what it's useful for and how
users can use it.  And some files should not be there at all - e.g. the
trace file - please use the standard kernel tracing infrastructure
instead.

And to be frank - as long as the driver is such a fucking mess as it is
right now adding any additional features should be postponed until that
is sorted out.

