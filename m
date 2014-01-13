From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/11] IB/isert: Avoid frwr notation, user fastreg
Date: Mon, 13 Jan 2014 11:44:47 -0800
Message-ID: <1389642287.5567.449.camel@haakon3.risingtidesystems.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
	 <1389285658-7037-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-4-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-01-09 at 18:40 +0200, Sagi Grimberg wrote:
> Use fast registration lingo. fast registration will
> also incorporate signature/DIF registration.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c |   84 ++++++++++++++++---------------
>  drivers/infiniband/ulp/isert/ib_isert.h |    8 ++--
>  2 files changed, 47 insertions(+), 45 deletions(-)

Applied to for-next.

Thanks Sagi!

--nab
