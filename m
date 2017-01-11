From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers: block: Remove unnecessary cast
Date: Wed, 11 Jan 2017 21:04:18 +0100
Message-ID: <20170111200418.GA16314@kroah.com>
References: <20170111184105.GA10766@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111184105.GA10766@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: don.brace@microsemi.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 12:41:05PM -0600, Gustavo A. R. Silva wrote:
> This issue was detected using Coccinelle and the following semantic patch:
> 
> @@
> expression * e;
> expression arg1, arg2;
> type T;
> @@
> 
> - e = (T *)
> + e =
> kmalloc(arg1, arg2);
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/block/cciss_scsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Why send this to me?
