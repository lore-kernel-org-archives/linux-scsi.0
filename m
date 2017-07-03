From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: Fix flushing cmd entry dcache page
Date: Sun, 02 Jul 2017 22:36:08 -0700
Message-ID: <1499060168.9866.6.camel@haakon3.risingtidesystems.com>
References: <1498810456-10609-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1498810456-10609-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-06-30 at 16:14 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> When feeding the tcmu's cmd ring, we need to flush the dcache page
> for the cmd entry to make sure these kernel stores are visible to
> user space mappings of that page.
> 
> For the none PAD cmd entry, this will be flushed at the end of the
> tcmu_queue_cmd_ring().
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied.

Thanks Xiubo + MNC.
