From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: Mon, 23 Jun 2003 09:45:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623094559.A3460@infradead.org>
References: <20030623070135.AF6A72C292@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:50447 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265865AbTFWIb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 04:31:59 -0400
Content-Disposition: inline
In-Reply-To: <20030623070135.AF6A72C292@lists.samba.org>; from rusty@rustcorp.com.au on Mon, Jun 23, 2003 at 04:47:25PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Jes Sorensen <jes@wildopensource.com>, linux-scsi@vger.kernel.org

On Mon, Jun 23, 2003 at 04:47:25PM +1000, Rusty Trivial Russell wrote:
> [ This function is unused if kernel > 2.1.95, so put #ifdef around whole thing
>   to avoid warning. --RR ]

I'd say kill it completly.  qlogic has stopped maintaining the driver
and there's other places in the driver that won't work anymore with 2.0.

