From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 15/31] kdump: mpt fusion driver initialization failure
 fix
Date: Fri, 9 Jun 2006 09:30:23 -0700
Message-ID: <20060609093023.fd06609d.akpm@osdl.org>
References: <200606090523.k595Nlcs032294@shell0.pdx.osdl.net>
	<1149862359.3480.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:216 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751451AbWFIQac (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 12:30:32 -0400
In-Reply-To: <1149862359.3480.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, vgoyal@in.ibm.com, Eric.Moore@lsil.com

On Fri, 09 Jun 2006 09:12:39 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Thu, 2006-06-08 at 22:23 -0700, akpm@osdl.org wrote:
> > From: Vivek Goyal <vgoyal@in.ibm.com>
> > 
> > MPT fusion driver initialization fails while second kernel is booting,
> > after a system crash (if kdump kernel is configured).  Oops message is
> > pasted below.  I have attached a patch to fix the issue.  Your suggestions
> > are welcome.
> 
> This one's been in scsi-misc for quite a while ... is there some reason
> the normal processes didn't drop this?
> 

Remember that I'm picking up my git-scsi-misc via git-infiniband.  Roland
tells me he's pulling scsi-misc regularly but it does appear I don't have
it all.

Ho hum.  I need to have another run at getting the
diff-between-two-subsystem-trees working.
