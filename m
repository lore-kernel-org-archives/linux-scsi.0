From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: qla1280 compile problems
Date: 05 Aug 2003 08:54:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3wudsuuwe.fsf@trained-monkey.org>
References: <20030805121813.GA24647@lst.de>
	<m31xw0wa58.fsf@trained-monkey.org> <20030805124904.GA25181@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trained-monkey.org ([209.217.122.11]:9744 "EHLO
	trained-monkey.org") by vger.kernel.org with ESMTP id S272749AbTHEMys
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 08:54:48 -0400
In-Reply-To: <20030805124904.GA25181@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> On Tue, Aug 05, 2003 at 08:40:03AM -0400, Jes Sorensen
Christoph> wrote:
>> Which version of the driver are you testing and what kernel? I
>> tried it out fairly recently on 2.5.x (2.5.59 or so) and it
>> compiled without any problems.

Christoph> That's Jame's latest scsi-misc-2.5 tree, i.e. Linus' tree
Christoph> from four days ago plus lots of scsi-related chanhges
Christoph> including qla 3.23.34.

Ok, will take a look at this.

Christoph> It does make sense.  Your punishing all ia64 users for SN2
Christoph> breakage although 95% (or probably more) of the IA64 boxens
Christoph> won't ever need it.

Punishing? thats why you have the option to compile the kernel as
CONFIG_IA64_HP_ZX1 or CONFIG_IA64_DIG. The point of the generic kernel
is that it will boot on all boxes, thats why this feature is only
enabled for generic kernels or sn2 specific. Second, the 'cost' of
this is a test and a branch and even on sn2 it just flips a
bit. Hardly comparable to the cost of loading the address into the
device.

Christoph> And no, so far SN2 isn't part of the generic IA64 build in
Christoph> either 2.4 or 2.5 although it's hopefully going to happen
Christoph> soon for 2.5.

I'll check what the status is, if it prevents current kernels from
building I'll of course take it out for now.

Jes
