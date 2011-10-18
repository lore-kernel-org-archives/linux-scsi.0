From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ib_srpt status
Date: Tue, 18 Oct 2011 09:41:15 -0700
Message-ID: <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
References: <20111012092318.GA9405@lst.de>
	 <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-18 at 08:13 +0200, Bart Van Assche wrote:
> On Wed, Oct 12, 2011 at 11:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> > what is the status of queueing up ib_srpt for mainline?  It's a very
> > clean looking driver that was submitted 8 month ago and after an initial
> > round of fixes only saw updates for changing core APIs.
> 
> The ib_srpt driver was working fine last time I tested it. But with
> the current (3.1-rc9) LIO core performing I/O triggers grave memory
> corruption and random kernel crashes. Something must have changed in
> the LIO core that broke ib_srpt.
> 

Hi Bart,

I'm having no problems with the patch posted for v3.2 review on MT26428
HCAs

Can you verify you are actually using this patch, and not your private
tree from github..?  The reason is that your tree did not contain the
bugfix below to ib_srpt code that was originally causing problems:

ib_srpt: Fix bug with chainged SGLs in srpt_map_sg_to_ib_sge
http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=commitdiff;h=ea485147563b6555a97dbf811825fbb586519252

Thanks,

--nab
