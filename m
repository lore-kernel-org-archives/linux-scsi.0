From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2] Don't
 blacklist nvme]
Date: Thu, 16 Feb 2017 20:05:36 +0200
Message-ID: <8ce207d3-844a-8190-9644-1f54dbd7d56b@grimberg.me>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org> <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org> <20170216151337.GA12678@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34398 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbdBPSFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 13:05:41 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so4351777wmi.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 10:05:40 -0800 (PST)
In-Reply-To: <20170216151337.GA12678@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org


> I'm fine with the path selectors getting moved out; maybe it'll
> encourage new path selectors to be developed.
>
> But there will need to be some userspace interface stood up to support
> your native NVMe multipathing (you may not think it needed but think in
> time there will be a need to configure _something_).  That is the
> fragmentation I'm referring to.

I guess one config option that we'd need is multibus vs. failover
which are used per use-case.

I'd have to say that having something much simpler than multipath-tools
does sound appealing.
