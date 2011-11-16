From: Luis Henriques <henrix@camandro.org>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Wed, 16 Nov 2011 20:58:48 +0000
Message-ID: <20111116205848.61ab1ab0@hades>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	<20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
	<CAO+b5-pPTt9B1se3-oGrZZ4-mScJh7_9MA29UTbOSB3QR4L38A@mail.gmail.com>
	<20111108194939.1ddff5af4c877850cfb9e1f9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111108194939.1ddff5af4c877850cfb9e1f9@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 8 Nov 2011 19:49:39 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > > I don't get the WARNING any more, but now get lots of:
> > >
> > > scsi: killing requests for dead queue
> > 
> > This patch should help:
> > http://www.spinics.net/lists/linux-scsi/msg55373.html.
> 
> Thanks.  Will that be added to the scsi{,-rc-fixes} trees soon?

Any idea when this will hit mainline?  Its really annoying having all
these messages on the logs...

Cheers,
--
Luis Henriques
