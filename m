From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] target: remove unneeded array
Date: Mon, 01 Dec 2014 22:12:47 -0800
Message-ID: <1417500767.11477.2.camel@haakon3.risingtidesystems.com>
References: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1417371255-2282-2-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417371255-2282-2-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-11-30 at 19:14 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete a local array that is only used to be initialized by memset.
> 
> A semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> type T;
> @@
> 
> {
> ... when any
> -T x[...];
> <+... when != x
> - memset(x,...);
> ...+>
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/target/target_core_pr.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Julia!

--nab
