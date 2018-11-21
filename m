From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iser: set sector for ambiguous mr status errors
Date: Wed, 21 Nov 2018 16:02:40 -0700
Message-ID: <20181121230240.GC29924@ziepe.ca>
References: <20181114181701.26417-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114181701.26417-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 14, 2018 at 10:17:01AM -0800, Sagi Grimberg wrote:
> If for some reason we failed to query the mr status, we need to make sure
> to provide sufficient information for an ambiguous error (guard error on
> sector 0).
> 
> Fixes: 0a7a08ad6f5f ("IB/iser: Implement check_protection")
> Cc: <stable@vger.kernel.org>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/infiniband/ulp/iser/iser_verbs.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Applied to for-rc

Thanks,
Jason
