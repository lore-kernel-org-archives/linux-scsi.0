From: Torsten Luettgert <ml-lkml@enda.eu>
Subject: Re: BUG: unable to handle kernel NULL pointer deref, bisected to
 746650160
Date: Wed, 22 Apr 2015 10:45:19 +0200
Message-ID: <20150422104519.772b0d39@goldlack.schiller106>
References: <20150408183333.493607a3@goldlack.schiller106>
	<20150413174105.GA14988@lst.de>
	<20150413202829.580e3801@goldlack.schiller106>
	<20150419165841.GA20332@lst.de>
	<20150420132424.0ce7965f@goldlack.schiller106>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150420132424.0ce7965f@goldlack.schiller106>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 20 Apr 2015 13:24:24 +0200
Torsten Luettgert <ml-lkml@enda.eu> wrote:

> > Can you test the patch below?
> 
> I'm running it right now and keeping my fingers crossed.

Just under two days uptime now, and no crashes. I'm pretty sure you
nailed it.

I'll keep this running, and if - when - it has been going for a week (3
times the max uptime without the patch) - I'll give a final notice.

Thanks a lot, Christoph! Will this patch be integrated into mainline?

Regards,
Torsten
