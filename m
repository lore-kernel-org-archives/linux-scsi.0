From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: qla1280 compile problems
Date: 05 Aug 2003 08:40:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m31xw0wa58.fsf@trained-monkey.org>
References: <20030805121813.GA24647@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trained-monkey.org ([209.217.122.11]:5392 "EHLO
	trained-monkey.org") by vger.kernel.org with ESMTP id S272726AbTHEMkL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 08:40:11 -0400
In-Reply-To: <20030805121813.GA24647@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> The qla1280 update still has some issues, mostly because it
Christoph> backs out all the 2.5 changes applied to the driver in the
Christoph> last months, also it doesn't work on ia64 because the IA64
Christoph> generic build references sn2-specific symbols that don't
Christoph> exist in that build.

Christoph,

Which version of the driver are you testing and what kernel? I tried
it out fairly recently on 2.5.x (2.5.59 or so) and it compiled without
any problems.

Christoph> Jes, can you look at the 2.5 changes that went in after
Christoph> your last merge and make the SN2 vchan workaround a config
Christoph> option?

I will take a look at building it against the latest 2.6.0-test
kernel. However, I am not going to make the vchan workaround a new
config option, it doesn't make any sense as it's already protected by
CONFIG_IA64_SGI_SN2 || CONFIG_IA64_GENERIC. The appropriate patches
for that have already been pushed for 2.4 and Jesse is about to push
them out for 2.5.

Cheers,
Jes
