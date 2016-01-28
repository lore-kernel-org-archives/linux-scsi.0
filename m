From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] NVMe target support
Date: Thu, 28 Jan 2016 01:09:42 -0800
Message-ID: <1453972182.6746.248.camel@haakon3.risingtidesystems.com>
References: <1453956103.6746.195.camel@haakon3.risingtidesystems.com>
	 <20160128085210.GB18023@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44181 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbcA1JJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 04:09:45 -0500
In-Reply-To: <20160128085210.GB18023@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, "Minturn, Dave B" <dave.b.minturn@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Ming Lin <mlin@kernel.org>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@kernel.org>, Mike Christie <mchristi@redhat.com>

On Thu, 2016-01-28 at 00:52 -0800, Christoph Hellwig wrote:
> I think the frame is wrong, nevermind that I doubt I'll be able to
> discuss anything NVMe Fabrics related before the spec is public.  Which
> I doubt is in time for LSF/MM.

That fine, but NVMe_OF is certainly not going to be the only fabric
driver out there.

So what I'd like to discuss wrt this topic is what existing common code
relates to vhost-nvme, based on other's fabric driver work already out
there.





