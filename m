From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: Oops in unmap_thread_fn()
Date: Sun, 06 Aug 2017 16:27:53 -0700
Message-ID: <1502062073.22966.45.camel@haakon3.daterainc.com>
References: <20170801200917.brigs5x47eujfx7a@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170801200917.brigs5x47eujfx7a@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Xiubo Li <lixiubo@cmss.chinamobile.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-08-01 at 23:09 +0300, Dan Carpenter wrote:
> Calling list_del() on the iterator pointer in list_for_each_entry() will
> cause an oops.  We need to user the _safe() version for that.
> 
> Fixes: c73d02f63c16 ("tcmu: Add fifo type waiter list support to avoid starvation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Applied to target-pending/for-next.

Thanks DanC.

