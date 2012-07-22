From: Tejun Heo <tj@kernel.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Sun, 22 Jul 2012 10:31:46 -0700
Message-ID: <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FFB32E5.1050109@farcaster.org>
 <4FFB7354.8040809@matthiasprager.de>
 <4FFB8A86.7000009@farcaster.org>
 <4FFCBA4C.4000502@farcaster.org>
 <4FFD6F3D.2030708@matthiasprager.de>
 <4FFD8410.7050604@matthiasprager.de>
 <20120717180932.GB2878@google.com>
 <5005BF7D.2050703@matthiasprager.de>
 <20120717200136.GC24336@google.com>
 <500A9D7C.8080801@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48042 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2GVRbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2012 13:31:51 -0400
Received: by pbbrp8 with SMTP id rp8so9476842pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2012 10:31:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <500A9D7C.8080801@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>

Hello,

On Sat, Jul 21, 2012 at 02:15:56PM +0200, Matthias Prager wrote:
> Now I'm not sure this isn't taping over another bug. Which leads me to
> my question: What is the correct behavior?
> 
> #1 Issuing a separate spin-up command (START UNIT?) prior to sending i/o
> by setting allow_restart=1 for sata disks on sas controllers
> 
> or
> 
> #2 Teaching the sas drivers they do not need spin-up commands and can
> simply start issuing i/o to sata disks

I haven't consulted SAT but it seems like a bug in SAS driver or
firmware.  If it's a driver bug, we better fix it there.  If a
firmware bug, working around those is one of major roles of drivers,
so I think setting allow_restart is fine.

Thanks.

-- 
tejun
