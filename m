From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] IB/mlx5: Fix signature rule constants according to FW
 specifications
Date: Sun, 19 Jan 2014 15:07:10 +0200
Message-ID: <52DBCDFE.3080005@dev.mellanox.co.il>
References: <1390127858-9806-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390127858-9806-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/19/2014 12:37 PM, Sagi Grimberg wrote:
> Use DIF CRC INC with apptag escape (0x8) and update IP-CSUM entries.
>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>   drivers/infiniband/hw/mlx5/qp.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 7981620..58c4735 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -1952,9 +1952,9 @@ static int format_selector(struct ib_sig_attrs *attr,
>   {
>   
>   #define FORMAT_DIF_NONE		0
> -#define FORMAT_DIF_CRC_INC	4
> -#define FORMAT_DIF_CSUM_INC	12
> -#define FORMAT_DIF_CRC_NO_INC	13
> +#define FORMAT_DIF_CRC_INC	8
> +#define FORMAT_DIF_CRC_NO_INC	12
> +#define FORMAT_DIF_CSUM_INC	13
>   #define FORMAT_DIF_CSUM_NO_INC	14
>   
>   	switch (domain->sig.dif.type) {

Just a clarification,

This patch along with "Fix smatch warnings" are incremental patches to 
v4 of pending Signature verbs patchset.

Sagi.
