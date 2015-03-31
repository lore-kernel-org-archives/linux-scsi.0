From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Tue, 31 Mar 2015 02:23:23 -0700
Message-ID: <20150331092323.GA9964@infradead.org>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
 <20150330120823.GA20193@infradead.org>
 <5519A0F4.4020102@redhat.com>
 <20150330192130.GA27541@infradead.org>
 <5519A59B.7060903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbCaJXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 05:23:25 -0400
Content-Disposition: inline
In-Reply-To: <5519A59B.7060903@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On Mon, Mar 30, 2015 at 12:35:55PM -0700, Andy Grover wrote:
> So what's next? Were you going to do the LUNs too? In addition to +perf and
> less mem usage, going down this path also leads to >256 LUNs per tpg.

This just started as a rework of Nic' series, so I'd like to avoid scope
creep.  I think applying the same dynamic allocation + rcu scheme should
work fine for the LUNs, too.
