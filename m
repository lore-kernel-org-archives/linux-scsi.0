From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] [Trivial Patch] scsi_register-002
Date: Tue, 24 Jun 2003 01:42:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623235717.86B342C01B@lists.samba.org>
References: <1056377839.13528.46.camel@dhcp22.swansea.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:47299 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264454AbTFWXnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 19:43:09 -0400
In-reply-to: Your message of "23 Jun 2003 15:17:20 +0100."
             <1056377839.13528.46.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org

In message <1056377839.13528.46.camel@dhcp22.swansea.linux.org.uk> you write:
> On Llu, 2003-06-23 at 07:56, Rusty Trivial Russell wrote:
> > (Included in 2.5)
> > From:  Michael Still <mikal@stillhq.com>
> > 
> >   
> >   This patch has been generated as part of my scsi_register audit of the 2.
5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the f
ailure case was not being handled here...
> 
> Fix is subtly wrong because of aac_count, fixed up in my tree will push
> to Marcelo with the rest of the aacraid updates soon

Are you planning on updating the 2.5 one too?  This patch went in 2.5,
as indicated above, which is bad...

Thanks!
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
