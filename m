From: Andy Grover <agrover@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Thu, 26 Jan 2012 12:53:16 -0800
Message-ID: <4F21BD3C.8050809@redhat.com>
References: <4F19A981.4080502@redhat.com> <20120125174411.GB12620@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2AZUxX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 15:53:23 -0500
In-Reply-To: <20120125174411.GB12620@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tony Asleson <tasleson@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/25/2012 09:44 AM, Christoph Hellwig wrote:
> There's another project which is creating a very ad-hoc storage
> management abstraction, the nova-volume code in openstack.  Right now
> it supports iSCSI with a few vendor-specific extensions for management,
> RBD and sheepdog, but it looks like the numbers of vendors that want
> to be supported is growing.
> 
> See https://github.com/openstack/nova/blob/master/nova/volume/driver.py
> and other files in that directory for the little bits that exist at the
> moment.

<two minutes prior>
On 01/25/2012 09:42 AM, Christoph Hellwig wrote:
> Wrapping tools from libraries is more of a last resort than a proper
> solution.  But if we can't get better APIs that's probably what we
> will have to resort to if vendors don't cooperate.

Nova is wrapping cmdline tools, and all the vendors interested so far
are foss/cloudy.

This definitely shows others see a need for an API, but if we really
want big storage vendor buy-in, then a better (C?/sockets?) API and
working with non-foss code seems key.

Also, Nova code executes on the target machine, whereas libstoragemgmt
is running on the mgmt node and the plugins are responsible for
communication with the target node. (just wanted to point out another
difference.)

-- Andy
