From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: libfc: directly call ELS request handlers
Date: Fri, 7 Apr 2017 12:15:00 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1704071214060.1980@n5127mncfb42q1.qlogic.org>
References: <20170407134224.14804-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170407134224.14804-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Fri, 7 Apr 2017, 1:42pm -0000, Johannes Thumshirn wrote:

> Directly call ELS request handler functions in fc_lport_recv_els_req
> instead of saving the pointer to the handler's receive function and then
> later dereferencing this pointer.
> 
> This makes the code a bit more obvious.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/libfc/fc_lport.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 

A reasonable refactoring.

Reviewed-by: Chad Dupuis <chad.dupuis@cavium.com>
