From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/9] srp: use the new CQ API
Date: Wed, 18 Nov 2015 15:03:37 +0100
Message-ID: <20151118140337.GG18820@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-7-git-send-email-hch@lst.de> <564B8677.8090903@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564B8677.8090903@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2015 at 11:56:39AM -0800, Bart Van Assche wrote:
> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>> +static void srp_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +	srp_handle_qp_err(cq, wc, "INV RKEY");
>> +}
> >
>> [ ... ]
> >
>> +static void srp_reg_mr_done(struct ib_cq *cq, struct ib_wc *wc)
>> +{
>> +	srp_handle_qp_err(cq, wc, "FAST REG");
>> +}
>
> How about using names like srp_inv_rkey_err() and srp_reg_mr_err() to make 
> clear that these completion functions are only called if an error occurred 
> ?

I can do that if you like.
