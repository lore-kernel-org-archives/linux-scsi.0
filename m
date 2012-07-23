From: Tejun Heo <tj@kernel.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Mon, 23 Jul 2012 08:26:19 -0700
Message-ID: <20120723152619.GD6823@google.com>
References: <4FFB8A86.7000009@farcaster.org>
 <4FFCBA4C.4000502@farcaster.org>
 <4FFD6F3D.2030708@matthiasprager.de>
 <4FFD8410.7050604@matthiasprager.de>
 <20120717180932.GB2878@google.com>
 <5005BF7D.2050703@matthiasprager.de>
 <20120717200136.GC24336@google.com>
 <500A9D7C.8080801@matthiasprager.de>
 <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
 <500C8938.2080607@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58319 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2GWP0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2012 11:26:24 -0400
Received: by pbbrp8 with SMTP id rp8so11033754pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jul 2012 08:26:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <500C8938.2080607@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, Matthias Prager <linux@matthiaspragers.de>

Hello,

On Mon, Jul 23, 2012 at 01:14:00AM +0200, Matthias Prager wrote:
> as it turns out my workaround (setting allow_restart=1) isn't all that
> useful after all. There are no more i/o errors because the drive just
> never goes to standby mode anymore (at least 'hdparm -y /dev/sda' does
> not seem to have any effect anymore). I don't really understand why - do
> sas drives ever get to standby mode? (they have allow_restart=1 set by
> default) And is this desired or expected behavior for sata disk on sas
> controllers?
> 
> For the moment the only way for me to have my sata drives sleeping
> without i/o errors is to revert your original commit
> (85ef06d1d252f6a2e73b678591ab71caad4667bb - tested with kernels 3.1.10,
> 3.4.4, 3.4.5, 3.4.6 and 3.5.0)

Hmmm... I think we definitely need help from mpt people.  Ping, guys.

> P.S. I hope I'm not getting on everybody's nerves here (especially yours
> Tejun)

Not at all. :)

Thanks.

-- 
tejun
