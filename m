From: David Miller <davem@davemloft.net>
Subject: Re: qla2xxx hba crashes with older 2310 cards
Date: Fri, 20 Apr 2007 13:24:02 -0700 (PDT)
Message-ID: <20070420.132402.119227720.davem@davemloft.net>
References: <4628DEEE.3060205@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38227
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030980AbXDTUX7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2007 16:23:59 -0400
In-Reply-To: <4628DEEE.3060205@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rpeterso@redhat.com
Cc: linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, hch@lst.de, linux-scsi@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>
Date: Fri, 20 Apr 2007 10:40:30 -0500

> I've seen some chatter about the qla2xxx driver but not paid attention, so
> I'm sorry if this is a known issue.  I've got an older qlogic hba, and recent
> drivers don't seem to play nice with it.  I've got the latest firmware from
> qlogic's web site.  I'm using a 2.6.21-rc6 kernel from Steve Whitehouse's
> -nmw git tree.  Reverting to an older driver (but same kernel) and it works.
> The current driver gives this:

Yes, known problem, I'm sorry these guys broke the driver for
you as well, please see this thread:

	http://marc.info/?l=linux-kernel&m=117671067701124&w=2

This was really a stupid change to make.
