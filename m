From: Christoph Hellwig <hch@lst.de>
Subject: Re: ib_srpt status
Date: Tue, 18 Oct 2011 18:43:21 +0200
Message-ID: <20111018164321.GA588@lst.de>
References: <20111012092318.GA9405@lst.de> <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com> <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2011 at 09:41:15AM -0700, Nicholas A. Bellinger wrote:
> I'm having no problems with the patch posted for v3.2 review on MT26428
> HCAs
> 
> Can you verify you are actually using this patch, and not your private
> tree from github..?  The reason is that your tree did not contain the
> bugfix below to ib_srpt code that was originally causing problems:
> 
> ib_srpt: Fix bug with chainged SGLs in srpt_map_sg_to_ib_sge
> http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=commitdiff;h=ea485147563b6555a97dbf811825fbb586519252

Also it would be useful to know the workload that causes the corruption.
