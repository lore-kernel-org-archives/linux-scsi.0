From: Roman Kagan <rkagan@mail.ru>
Subject: Re: [ANNOUNCE] hotplug-ng 001 release
Date: Fri, 18 Feb 2005 21:11:06 +0300
Message-ID: <20050218181106.GC4424@katya>
References: <20050211204626.GC2568@katya> <20050211211028.GB21512@suse.de> <20050212003458.GI2568@katya> <20050214224208.GC13110@suse.de> <20050216105117.GB2360@katya> <20050216110752.GC2360@katya> <1108594961l.5056l.5l@serve.riede.org> <20050216231741.GD2870@katya> <1108596771l.5056l.6l@serve.riede.org> <20050218171737.GA20012@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from apachihuilliztli.mtu.ru ([195.34.32.124]:16910 "EHLO
	Apachihuilliztli.mtu.ru") by vger.kernel.org with ESMTP
	id S261425AbVBRSLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 13:11:21 -0500
Content-Disposition: inline
In-Reply-To: <20050218171737.GA20012@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Willem Riede <osst@riede.org>, linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Fri, Feb 18, 2005 at 09:17:37AM -0800, Patrick Mansfield wrote:
> You could also append the sdev->vendor and sdev->model, and use alias wild
> cards.

String values haven't been used in the aliases so far, and I think for a
reason: with all the unpredictable weird characters and string lengths
they would make maintainance harder, not easier.

> That is, add aliases to osst.c like:
> 
> MODULE_ALIAS("scsi-type-1-onStream-SC-*");
> MODULE_ALIAS("scsi-type-1-onStream-DI-*");

I used dashes for the only reason of these aliases being static.  If
they are supposed to grow it may make sense to stick to the convention
used everywhere else, i.e. bus:devspec.

> Also, sg loading would want (along with modprobe load all feature):
> 
> MODULE_ALIAS("scsi-type-*");

Is it certain that it can live together with s[dtr]?  I thought these
guys now handled all the ioctls sg was supposed to themselves...

Roman.
