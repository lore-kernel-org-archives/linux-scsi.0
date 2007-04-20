From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: qla2xxx hba crashes with older 2310 cards
Date: Fri, 20 Apr 2007 16:33:09 -0400
Message-ID: <1177101189.3718.49.camel@mulgrave.il.steeleye.com>
References: <4628DEEE.3060205@redhat.com>
	 <20070420.132402.119227720.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55210 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767240AbXDTUdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 16:33:20 -0400
In-Reply-To: <20070420.132402.119227720.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: rpeterso@redhat.com, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, hch@lst.de, linux-scsi@vger.kernel.org

On Fri, 2007-04-20 at 13:24 -0700, David Miller wrote:
> From: Robert Peterson <rpeterso@redhat.com>
> Date: Fri, 20 Apr 2007 10:40:30 -0500
> 
> > I've seen some chatter about the qla2xxx driver but not paid attention, so
> > I'm sorry if this is a known issue.  I've got an older qlogic hba, and recent
> > drivers don't seem to play nice with it.  I've got the latest firmware from
> > qlogic's web site.  I'm using a 2.6.21-rc6 kernel from Steve Whitehouse's
> > -nmw git tree.  Reverting to an older driver (but same kernel) and it works.
> > The current driver gives this:
> 
> Yes, known problem, I'm sorry these guys broke the driver for
> you as well, please see this thread:
> 
> 	http://marc.info/?l=linux-kernel&m=117671067701124&w=2
> 
> This was really a stupid change to make.

OK,OK, we heard you the first time ... the maintainers will try to fix
this in a manner acceptable to all concerned ... could we try to cool
down the public traductions now?

James


