From: Alan Cox <alan@redhat.com>
Subject: Re: Prototype SATA -> SCSI error mapper
Date: Tue, 17 Aug 2004 07:57:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817115759.GE3204@devserv.devel.redhat.com>
References: <20040816141243.GA3898@devserv.devel.redhat.com> <4121D0DE.5070307@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:9633 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265287AbUHQL6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 07:58:54 -0400
Content-Disposition: inline
In-Reply-To: <4121D0DE.5070307@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Alan Cox <alan@redhat.com>, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On Tue, Aug 17, 2004 at 07:33:18PM +1000, Douglas Gilbert wrote:
> Alan,
> With a MEDIUM or HARDWARE ERROR if you know the LBA of
> the failure, then that value can be placed in the
> (fixed format) sense buffer.
> 
> if (LBA_of_failure_known) {
>     sb[0] |= 0x80;       /* set VALID bit */
>     sb[3] = msb_of_LBA;  /* put LBA in INFORMATION field */
>     sb[4] = umb_of_LBA;
>     sb[5] = lmb_of_LBA;
>     sb[6] = lsb_of_LBA;
> }

Ok I'll add that, the LBA28/48 fail sector is in the taskfile at this
point. 



