From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] iscsi_tcp: bound max_r2t in iscsi_sw_tcp_conn_set_param()
Date: Thu, 9 Feb 2012 08:04:00 -0800
Message-ID: <20120209160400.GA27492@kroah.com>
References: <1325368867-13696-1-git-send-email-xi.wang@gmail.com>
 <4F015753.1010106@cs.wisc.edu>
 <2EB25344-4C9E-4D3C-8406-5A4D015CB364@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40753 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2BIQUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 11:20:02 -0500
Content-Disposition: inline
In-Reply-To: <2EB25344-4C9E-4D3C-8406-5A4D015CB364@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Mon, Jan 02, 2012 at 09:18:07AM -0500, Xi Wang wrote:
> On Jan 2, 2012, at 2:05 AM, Mike Christie wrote:
> > Are you actually hitting this and if so with what tools and target? And
> > when using greater than 1 do you see any throughput improvements?
> 
> No, I was worrying about security.
> 
> > What about the attached patch? It also fixes cxgb*i.
> > <0001-libiscsi_tcp-fix-max_r2t-manipulation.patch>
> 
> Looks good to me.  Thanks!

What ever happened to this patch, is it in Linus's tree yet?

thanks,

greg k-h
