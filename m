From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [patch 1/2] [SCSI] ipr: missing unlock before a return
Date: Mon, 30 Jul 2012 07:33:33 -0500
Message-ID: <50167F1D.5030406@linux.vnet.ibm.com>
References: <20120730081635.GE15702@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120730081635.GE15702@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/30/2012 03:16 AM, Dan Carpenter wrote:
> We recently changed the locking in this function, but this return was
> missed.  It needs an unlock and the IRQs need to be restored.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Thanks for catching this.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
