From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 17:50:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621165023.GZ12308@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta> <1087835531.2077.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5322 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262329AbUFUQua
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 12:50:30 -0400
Content-Disposition: inline
In-Reply-To: <1087835531.2077.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Eric Dean Moore <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jun 21, 2004 at 11:32:10AM -0500, James Bottomley wrote:
> -typedef int32_t   S32;
> -typedef u_int32_t U32;
> +#if defined(unix) || defined(__arm) || defined(ALPHA)
> +
> +    typedef signed   int   S32;
> +    typedef unsigned int   U32;
> +
> +#else
> +
> +    typedef signed   long  S32;
> +    typedef unsigned long  U32;
> +
> +#endif
> 
> Looks highly suspect.  What was wrong with the original?

They are actually restoring their beloved original.  What was wrong with
it is left as an exercise for anybody with a clue.

IOW, the patch is "let's take diff between whatever's in the tree and our
private repository".
