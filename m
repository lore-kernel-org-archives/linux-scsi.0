From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Thu, 21 Jun 2018 10:19:00 +0200
Message-ID: <20180621081900.GA5183@lst.de>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com> <20180620181601.GA24145@localhost.localdomain> <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Keith Busch <keith.busch@intel.com>, axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 09:43:26AM +0800, jianchao.wang wrote:
> So we have to preserve the ability of block layer that it could prevent
> IO completion path from entering a timeout request.
> 
> With scsi-debug module, I tried to simulate a scenario where timeout and IO
> completion path could occur concurrently, the system ran into crash easily.

Trace, please.  With the latest kernel.  I'm not saying that there
is nothing to fix, but the mode of never completing once timeout
requests as currently done is SCSI is clearly broken.
