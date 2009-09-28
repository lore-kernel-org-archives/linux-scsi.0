From: Allan Wind <allan_wind@lifeintegrity.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 28 Sep 2009 01:32:28 -0400
Message-ID: <20090928053228.GB28978@lifeintegrity.com>
References: <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca> <4AB25736.1060601@suse.de> <4AB260CA.8040308@rtr.ca> <4AB2610F.8010904@rtr.ca> <20090918170517.GI2141@arachsys.com> <20090920173543.GA19717@lifeintegrity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-173-48-39-13.bstnma.fios.verizon.net ([173.48.39.13]:58918
	"EHLO lifeintegrity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZI1FcZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2009 01:32:25 -0400
Received: from vent.lifeintegrity.com (Wireless_Broadband_Router [173.48.39.13])
	by submission.lifeintegrity.com (Postfix) with ESMTPS id 32CA763
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2009 01:32:29 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20090920173543.GA19717@lifeintegrity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2009-09-20T13:35:43, Allan Wind wrote:
> On 2009-09-18T18:05:17, Chris Webb wrote:
> > Mark Lord <liml@rtr.ca> writes:
> > 
> > > Speaking of which..
> > > 
> > > Chris:  I wonder if the errors will also vanish in your situation
> > > by disabling the onboard write-caches in the drives ?
> > > 
> > > Eg.  hdparm -W0 /dev/sd?
> > 
> > Hi Mark. I've got a test machine on its way at the moment, so I'll make sure
> > I check this one out on it too.
> 
> It has been stable for me the last 3 days with the write cached 
> disabled.

My mirrored raid array has been stable for over a week now.  Too 
bad disabling the write cache did not resolve it for Chris.


/Allan
-- 
Allan Wind
Life Integrity, LLC
<http://lifeintegrity.com>

