From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: qlogicpti: Fix an error handling path in
 'qpti_sbus_probe()'
Date: Thu, 10 May 2018 15:45:46 +0300
Message-ID: <20180510124546.gp5f66ugkivwfbhn@mwanda>
References: <20180510114558.20769-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510114558.20769-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 10, 2018 at 01:45:58PM +0200, Christophe JAILLET wrote:
> The 'free_irq()' call is not at the right place in the error handling path.
> The changed order has been introduced in commit 3d4253d9afab
> ("[SCSI] qlogicpti: Convert to new SBUS device framework.")
> 
> Fixes: 3d4253d9afab ("[SCSI] qlogicpti: Convert to new SBUS device framework.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Please review carefully.  This patch is proposed because it triggers one of
> my coccinelle scripts. I'm not 100% sure if correct.

Looks good to me.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
