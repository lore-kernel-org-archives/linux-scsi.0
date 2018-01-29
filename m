From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Mon, 29 Jan 2018 12:56:30 -0800
Message-ID: <1517259390.3969.41.camel@HansenPartnership.com>
References: <20180129154455.GB17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39692 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751900AbeA2U4d (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 15:56:33 -0500
In-Reply-To: <20180129154455.GB17176@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org

On Mon, 2018-01-29 at 23:46 +0800, Ming Lei wrote:
[...]
> 2. When to enable SCSI_MQ at default again?

I'm not sure there's much to discuss ... I think the basic answer is as
soon as Christoph wants to try it again.

> SCSI_MQ is enabled on V3.17 firstly, but disabled at default. In
> V4.13-rc1, it is enabled at default, but later the patch is reverted
> in V4.13-rc7, and becomes disabled at default too.
> 
> Now both the original reported PM issue(actually SCSI quiesce) and
> the sequential IO performance issue have been addressed.

Is the blocker bug just not closed because no-one thought to do it:

https://bugzilla.kernel.org/show_bug.cgi?id=178381

(we have confirmed that this issue is now fixed with the original
reporter?)

And did the Huawei guy (Jonathan Cameron) confirm his performance issue
was fixed (I don't think I saw email that he did)?

James
