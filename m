From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Thu, 18 Mar 2004 02:58:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040318025844.43f2ab43.ak@suse.de>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com>
	<20040318020948.2f884e89.ak@suse.de>
	<001201c40c89$c4fcef20$221015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:39107 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262286AbUCRB6r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 20:58:47 -0500
In-Reply-To: <001201c40c89$c4fcef20$221015ac@ericmoore>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Alexander.Stohr@gmx.de, rddunlap@osdl.org

On Wed, 17 Mar 2004 18:38:51 -0700
"Moore, Eric Dean" <emoore@lsil.com> wrote:

> Andi -
> 
> The fix in 3.01.02 was your request for commenting out the
> "queue is full message" which you posted to the
> mailing list earlier in the last week.  This has nothing to do with
> with todays issue.

I merged that. Thanks.
 
> Regarding todays issue.  There is a work around for your
> issue which I have already suggested earlier today. That is
> to modify the mpt fusion Makefile, by uncommenting out
> the FIFO FIX define.  This work around will set a dma mask
> for less 4GB, thus we don't hit the error condition in PrimeFifo's

Ok, I did that already independently. 

Thanks,
-Andi

