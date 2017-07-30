From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: Fix possible to/from address overflow when doing
 the memcpy
Date: Sun, 30 Jul 2017 15:13:31 -0700
Message-ID: <1501452811.1499.22.camel@haakon3.daterainc.com>
References: <1499845877-18931-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499845877-18931-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-07-12 at 15:51 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> For most case the sg->length equals to PAGE_SIZE, so this bug won't
> be triggered. Otherwise this will crash the kernel, for example when
> all segments' sg->length equal to 1K.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 

Applied to target-pending/master.

Thankx Xiubo + MNC.
