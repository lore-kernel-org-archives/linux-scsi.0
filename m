From: Christian Joensson <christian.joensson@gmail.com>
Subject: Re: [PATCH] kill qlogicpti inquiry sniffing
Date: Mon, 21 Nov 2005 18:31:42 +0100
Message-ID: <5460e3330511210931w5b0ff188o56feaeab66e41e22@mail.gmail.com>
References: <20051017120229.GA5834@lst.de> <20051112091251.GA15402@lst.de>
	 <20051119184447.GA29275@lst.de>
	 <20051121080951.zmygxh5miows4wk4@webmail.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20051121080951.zmygxh5miows4wk4@webmail.ele.uri.edu>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
To: "simoneau@ele.uri.edu" <simoneau@ele.uri.edu>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, davem@davemloft.net, tcallawa@redhat.com, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/21/05, simoneau@ele.uri.edu <simoneau@ele.uri.edu> wrote:
> Quoting Christoph Hellwig <hch@lst.de>:
>
> > On Sat, Nov 12, 2005 at 10:12:51AM +0100, Christoph Hellwig wrote:
> >> On Mon, Oct 17, 2005 at 02:02:29PM +0200, Christoph Hellwig wrote:
> >> > Inquiry sniffing is a really bad idea, and sneaking a patch in without
> >> > talking to the scsi maintainers doesn't make it any better ;-)
> >> >
> >> > Could one of the sparc people please test the patch below to kill it?
> >>
> >> ping?
> >
> > ping^2.  Hey, there must be sparc users with this hardware that noticed
> > the initial bug, could you please test this patch?
> >
>
> I have an SBUS qpti card which had some major problem (kernel BUG()
> during boot
> in the qlogicpti driver) last time when I tried 2.6.14, I can test the patch.
> SS20MP 2xSuperSPARC here, just give me a while to compile a kernel.

what is the status of linux SMP kernel 2.6 and sun4m?

--
Cheers,

/ChJ
