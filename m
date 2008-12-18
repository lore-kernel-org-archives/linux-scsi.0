From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Disabling scatter gather
Date: Thu, 18 Dec 2008 07:35:09 -0700
Message-ID: <20081218143508.GJ19967@parisc-linux.org>
References: <5fdb3af3-6283-4ca4-856f-9028ed52f789@d36g2000prf.googlegroups.com> <1aa5e34d0812180627r56625723k840f5b8080335644@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33175 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYLROfK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 09:35:10 -0500
Content-Disposition: inline
In-Reply-To: <1aa5e34d0812180627r56625723k840f5b8080335644@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tarrot termite <tarrottermite@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Dec 18, 2008 at 07:57:25PM +0530, tarrot termite wrote:
> Hi,
> I am trying to disable scatter gather for my fake SCSI HBA driver but
> somehow I still get use_sg set in my scsi commands.
> 
> I have set sg_tablesize to SG_NONE in host template. I remember it
> used to work well in 2.4. Has this part change under 2.6.18?

Yes, you now have to use scatter-gather.

As far as fake SCSI HBA drivers go, there's one in-tree called
scsi_debug, or there's scsi_ram that I wrote and you can find here:
http://marc.info/?l=linux-scsi&m=120331663227540&w=2

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
