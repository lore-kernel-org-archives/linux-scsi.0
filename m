From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Date: Fri, 8 Mar 2013 22:58:39 +0300
Message-ID: <20130308195839.GL9189@mwanda>
References: <20130308120215.GB18712@longonot.mountain>
 <513A2678.5000803@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <513A2678.5000803@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 08, 2013 at 12:57:12PM -0500, Douglas Gilbert wrote:
> On 13-03-08 07:02 AM, Dan Carpenter wrote:
> 
> For 32 bytes, why not use the stack?
> 

It's a good point.  I'll resend on Monday.

regards,
dan carpenter
