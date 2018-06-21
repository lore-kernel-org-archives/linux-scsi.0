From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Thu, 21 Jun 2018 09:01:43 -0600
Message-ID: <20180621150143.GA26712@localhost.localdomain>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180620181601.GA24145@localhost.localdomain>
 <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
 <20180621081900.GA5183@lst.de>
 <df1633e8-7df4-976b-a7d5-77679c92843a@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <df1633e8-7df4-976b-a7d5-77679c92843a@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 09:13:30PM +0800, jianchao.wang wrote:
> Hi Christoph
> 
> On 06/21/2018 04:19 PM, Christoph Hellwig wrote:
> > On Thu, Jun 21, 2018 at 09:43:26AM +0800, jianchao.wang wrote:
> >> So we have to preserve the ability of block layer that it could prevent
> >> IO completion path from entering a timeout request.
> >>
> >> With scsi-debug module, I tried to simulate a scenario where timeout and IO
> >> completion path could occur concurrently, the system ran into crash easily.
> > 
> > Trace, please.  With the latest kernel.  I'm not saying that there
> > is nothing to fix, but the mode of never completing once timeout
> > requests as currently done is SCSI is clearly broken.
> > 
> 
> Sorry, I don't quite get your point.
> Do you mean we should do the modification in the scsi layer ?

I think it would just be helpful to start with the stack trace of your
observed crash + the reproduction steps so the problem (and hopefully
a solution) can be better understood.
