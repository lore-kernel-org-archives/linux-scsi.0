From: Mark Haverkamp <markh@osdl.org>
Subject: Re: PATCH: fix crashes with aacraid
Date: Mon, 03 Jan 2005 12:32:28 -0800
Message-ID: <1104784348.25281.4.camel@markh1.pdx.osdl.net>
References: <1104158617.20952.51.camel@localhost.localdomain>
	 <1104771922.21673.4.camel@markh1.pdx.osdl.net>
	 <1104776060.13297.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:53226 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261693AbVACUcc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2005 15:32:32 -0500
In-Reply-To: <1104776060.13297.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-01-03 at 18:43 +0000, Alan Cox wrote:
> On Llu, 2005-01-03 at 17:05, Mark Haverkamp wrote:
> > On Mon, 2004-12-27 at 14:43 +0000, Alan Cox wrote:
> > > Is this change still needed for 2.6.10  Mark ?
> > 
> > I thought that the consensus was to remove aac_handle_aif altogether
> > like the patch sent in by Tom Coughlan on Dec. 8th.
> 
> Thats what I assumed but then I could find nothing in 2.6.10 that made
> aacraid work so I wasn't sure what if anything had been applied

Yes, I looked and it hasn't been applied to either the scsi-misc-2.6 or
the scsi-rc-fixes-2.6 bk trees either.


-- 
Mark Haverkamp <markh@osdl.org>

