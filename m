From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Fri, 17 Feb 2017 01:05:45 -0800
Message-ID: <20170217090545.GB29629@infradead.org>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
 <20170216151337.GA12678@redhat.com>
 <8ce207d3-844a-8190-9644-1f54dbd7d56b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755308AbdBQJFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2017 04:05:51 -0500
Content-Disposition: inline
In-Reply-To: <8ce207d3-844a-8190-9644-1f54dbd7d56b@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Feb 16, 2017 at 08:05:36PM +0200, Sagi Grimberg wrote:
> I guess one config option that we'd need is multibus vs. failover
> which are used per use-case.

Which fundamentally is a property of the target first, and it should
tell us that.  There might be the occasional need for an override,
but certainly not locally maintained tables of targets and their
preferences.
