From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Make scsi.h nominally userspace-clean
Date: Mon, 9 Aug 2004 19:56:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809175638.GA28171@suse.de>
References: <200408091753.i79Hrg9q010822@burner.fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17065 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266808AbUHIR4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 13:56:43 -0400
Content-Disposition: inline
In-Reply-To: <200408091753.i79Hrg9q010822@burner.fokus.fraunhofer.de>
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <schilling@fokus.fraunhofer.de>
Cc: noah@cs.caltech.edu, James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Aug 09 2004, Joerg Schilling wrote:
> >From axboe@suse.de  Mon Aug  9 19:52:11 2004
> 
> >> scsi/scsi.h does not compile cleanly in userspace programs due to its
> >> use of ``u8''.  I have confirmed this bug and prepared and tested a
> >> fix that simply changes all such uses to ``__u8''.  Please consider
> >> for inclusion.
> >> 
> >> I do not argue that including this header file in a program is
> >> appropriate, but other kernel headers already take as many precautions
> >> as this patch introduces.  I chose __u8 over uint8_t as more in the
> >> style of the kernel generally.
> >> 
> >> Please keep me on cc:; I do not subscribe to the lists.
> 
> >I already sent such a patch to Linus.
> 
> thank you! Did you also send a patch for sg.h to include linux/compiler.h?

Yes I did.

-- 
Jens Axboe

