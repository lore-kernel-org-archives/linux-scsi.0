From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup
Date: Mon, 28 Mar 2005 16:17:14 -0600
Message-ID: <1112048239.5531.83.camel@mulgrave>
References: <1111430484.9918.9.camel@markh1.pdx.osdl.net>
	 <1112047128.5531.78.camel@mulgrave>
	 <1112047471.5560.26.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22230 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261903AbVC1WRp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 17:17:45 -0500
In-Reply-To: <1112047471.5560.26.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-03-28 at 14:04 -0800, Mark Haverkamp wrote:
> On Mon, 2005-03-28 at 15:58 -0600, James Bottomley wrote:
> > What exactly is this for?  I know of no platforms that implement readl
> > and friends incorrectly, so all of this should be unnecessary.
> 
> I wondered about this.  Mark S. thought that there were some.  If there
> aren't, I can remove all that code.

Thanks.

Please, the next time, ask first before patching ....  it should be
fairly clear that if every driver did this, we'd have a huge mess and
great impetus to fix whichever embedded platform was causing
problems ...

James


