From: Andrew Morton <akpm@digeo.com>
Subject: Re: Possible explanation for SCSI benchmark problems in 2.5
Date: Mon, 30 Sep 2002 00:46:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D980142.971B70AD@digeo.com>
References: <200209292048.g8TKmN424799@localhost.localdomain> <3D976864.65C82D7B@digeo.com> <20020930073033.GA27420@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id AAA20675
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 00:46:17 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> 
> On Sun, Sep 29 2002, Andrew Morton wrote:
> > But high-IO is bust for IDE as well at present, so at least
> > we're being fair ;)
> 
> Nah that's fixed, it worries me that you say otherwise. Doesn't it work
> for you in stock 2.5.39?
> 

Ah you're right, it went away.  I was assuming that it was still
a problem because my fixit patch wasn't throwing rejects...

Thanks.
