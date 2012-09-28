From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] [SCSI] mvumi: GFP_KERNEL under spin lock
Date: Fri, 28 Sep 2012 14:51:33 +0300
Message-ID: <20120928115133.GX13767@mwanda>
References: <20120814145926.GA29090@elgon.mountain>
 <20120928113022.GW13767@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120928113022.GW13767@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 28, 2012 at 02:30:22PM +0300, Dan Carpenter wrote:
> Whatever happened with this?  You could just change the GFP_KERNEL
> to GFP_ATOMIC.
> 

Ah, that email address is dead is what happened.  I'll send a patch
that changes this to GFP_ATOMIC.

regards,
dan carpenter
