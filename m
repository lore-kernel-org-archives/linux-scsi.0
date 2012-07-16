From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/7] target: Un-export target_get_sess_cmd()
Date: Mon, 16 Jul 2012 15:54:47 -0700
Message-ID: <1342479287.18004.297.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-3-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-3-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 11:04 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> There are no in-tree users of target_get_sess_cmd() outside of
> target_core_transport.c.  Any new code should use the higher-level
> target_submit_cmd() interface.  So let's un-export target_get_sess_cmd()
> and make it static to the one file where it's actually used.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/target/target_core_transport.c |    6 +++---
>  include/target/target_core_fabric.h    |    1 -
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 

Applied with some minor fuzz against for-next.

Thanks!
