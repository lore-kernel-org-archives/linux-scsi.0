From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 16:46:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165AB1B.8000204@pobox.com>
References: <4161A06D.8010601@rtr.ca> <416547B6.5080505@rtr.ca> <20041007150709.B12688@infradead.org> <4165624C.5060405@rtr.ca> <416565DB.4050006@pobox.com> <4165A45D.2090200@rtr.ca> <4165A766.1040104@pobox.com> <4165A85D.7080704@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61110 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268179AbUJGUqd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 16:46:33 -0400
In-Reply-To: <4165A85D.7080704@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Mark Lord <lkml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
> 
>> Overall, I don't see why it is so damned difficult to delete the hooks 
>> then add them back when they _are_ needed.  I would certainly support 
>> you in that effort.
> 
> 
> Okay, that can work.
> 
> Except that the hooks ARE needed NOW.
> 
> Right NOW, there is a programmer working on the RAID management
> interface, and he needs those hooks (or something similar)
> to compile and test his code against the driver.

You're the only person in the world that (a) needs these hooks NOW and 
(b) can utilize the hooks NOW, by your own admission ;-)

That's the best reasoning I've heard for why a piece of code _shouldn't_ 
be in the kernel.  And I'm quite certain you are capable of compiling 
and testing the driver with a local patch held back from upstream.

Upstream is for stuff that's either finished, or at least usable...

	Jeff


