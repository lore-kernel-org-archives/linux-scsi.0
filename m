From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3]: blk-iopoll, a polled completion API for block
	devices
Date: Tue, 11 Aug 2009 16:39:19 +0200
Message-ID: <20090811143919.GU12579@kernel.dk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <e2e108260908110335tc500412mc6354359d85ae9b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755013AbZHKOjW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e2e108260908110335tc500412mc6354359d85ae9b6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 11 2009, Bart Van Assche wrote:
> On Thu, Aug 6, 2009 at 9:58 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Anyway, YMMV, I would appreciate some test results (and as usual, that
> > even includes just saying that it boots and functions for you). If
> > people feel adventurous, patches for other controllers will be happily
> > queued up for testing. I may even be convinced to implement support
> > for your controller of choice, if you have some fast storage hooked up
> > and would like to experiment. Generally, adding support to a driver is
> > not very hard and the two conversions included were also meant to serve
> > as an inspiration.
> 
> Sounds very interesting. Have you already considered patching the SRP
> initiator ? During the SRP performance tests I ran CPU usage on the
> initiator was more than 95% and on the target less than 10%.

No I haven't, if you point me at which srp files, I can take a look.

-- 
Jens Axboe
