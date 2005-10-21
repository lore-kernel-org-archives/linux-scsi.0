From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Fri, 21 Oct 2005 14:12:49 -0400
Message-ID: <43592FA1.8000206@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com> <20051020170330.GA16458@lst.de> <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew> <43583A53.2090904@pobox.com> <435929FD.4070304@adaptec.com> <20051021180455.GA6834@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965063AbVJUSM4@vger.kernel.org>
In-Reply-To: <20051021180455.GA6834@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, andrew.patterson@hp.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On 10/21/05 14:04, Christoph Hellwig wrote:
>>How about this: Why not as a char device?
> 
> you can implement a char device using the block layer.  See
> drivers/scsi/{ch.c,osst.c,sg.c,st.c} for examples.

Christoph, you failed to see that my question was _rhetorical_.

> That beeing said I tried this approach.  It looks pretty cool when you
> think about it, but the block layer is quite a bit too heavyweight for
> queueing up a few SMP requests, and we need to carry too much useless
> code around for it.

That's the last reason not to implement SMP as a block device.
But this is good that you tried it and it "flopped".  This way
people will stop repeating "SMP... block device".

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
