From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: 06 Dec 2004 11:20:47 -0600
Message-ID: <1102353654.1714.17.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C734893@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52354 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261584AbULFRVB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 12:21:01 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C734893@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-12-06 at 11:12, Moore, Eric Dean wrote:
> Our concern is the impact to linux distributions installers and
> end users that upgrade to these newer drivers.  
> Example: Someone having older driver using boot device attached
> to our controller.  Then they download a newer kernel from Kernel.org with
> newer
> drivers having mptfc.  They mkinitrd, or mk_initrd (without modifing
> linuxrc),
> reboot then what?  Can they see the boot partition?   

That's a concern only for people who boot from your fibre adapters.  How
many such users are there?

> Can we change the time when LLDs register themselves to the 
> transport layer?  Like from the probe routine.

Well, not really, unless you have a proposal to get around the
fundamental problem Christoph already pointed out:  any reference to the
fc_ transport methods will automatically cause modprobe to load it
regardless of whether it is used.

James


