From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Wed, 23 May 2007 15:16:09 -0700
Message-ID: <20070523151609.3b7456df.akpm@linux-foundation.org>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
	<4654BB27.6050706@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553AbXEWWQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:16:15 -0400
In-Reply-To: <4654BB27.6050706@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, 23 May 2007 18:07:35 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> akpm@linux-foundation.org wrote:
> > From: Jeff Garzik <jeff@garzik.org>
> > 
> > Signed-off-by: Jeff Garzik <jeff@garzik.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/aacraid/aacraid.h |    2 +-
> >  drivers/scsi/qla2xxx/qla_isr.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> hrm.  This appears to have been sent to linux-scsi at least three times.

One of these patches is appearing on linux-scsi for the fifteenth time.

> If it doesn't stick, I'll go ahead and send it up myself.

Well I've had it.  If nothing happens this time I shall re-review the
ancient and neglected patches and I will merge them up myself.

