From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PATCH] aic7xxx: fix compiler warning from dma mask assignement
Date: Mon, 22 Nov 2004 13:02:55 -0800
Message-ID: <20041122130255.3dde4fed@zqx3.pdx.osdl.net>
References: <20041118122415.539351f9@zqx3.pdx.osdl.net>
	<1100809690.1574.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:35558 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S262406AbUKVU7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 15:59:38 -0500
In-Reply-To: <1100809690.1574.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 18 Nov 2004 14:28:04 -0600
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Thu, 2004-11-18 at 14:24, Stephen Hemminger wrote:
> > Get rid of a compiler warning because assignment truncating a 64 bit constant
> > and use existing definitions.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
> 
> Actually, I floated a slightly more comprehensive version of the patch
> here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110064141503088
> 
> Could you check that this works for you?

It builds and the adapter is there, but don't have a disk attached yet
(waiting for new drive from IT).
