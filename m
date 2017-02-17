From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2] Don't
 blacklist nvme]
Date: Fri, 17 Feb 2017 09:37:17 -0500
Message-ID: <20170217143717.GB19043@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
 <20170216151337.GA12678@redhat.com>
 <8ce207d3-844a-8190-9644-1f54dbd7d56b@grimberg.me>
 <20170217090545.GB29629@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933976AbdBQOhR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 09:37:17 -0500
Content-Disposition: inline
In-Reply-To: <20170217090545.GB29629@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Feb 17 2017 at  4:05am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Feb 16, 2017 at 08:05:36PM +0200, Sagi Grimberg wrote:
> > I guess one config option that we'd need is multibus vs. failover
> > which are used per use-case.
> 
> Which fundamentally is a property of the target first, and it should
> tell us that.  There might be the occasional need for an override,
> but certainly not locally maintained tables of targets and their
> preferences.

Think you're being idealistic to think that once NVMe is on the roadmap,
and an engineering priority, of every player in the industry that your
more-or-less prestine implementation isn't going to get stretched to its
limits and ultimately need a fair amount of vendor specific tweaks.

But hopefully I'm wrong.  I just know what has happened with SCSI/FC/IB
multipathing vendor hardware and the jockeying that all these vendors do
ultimately results in the need for quirks because they raced to market
and ultimately missed something or invented their own ways forward to
allow NVMe to dove-tail into their preexisting legacy "enterprise"
offerings.
