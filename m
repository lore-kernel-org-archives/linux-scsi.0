From: Roman Kagan <rkagan@mail.ru>
Subject: Re: [ANNOUNCE] hotplug-ng 001 release
Date: Fri, 18 Feb 2005 22:41:35 +0300
Message-ID: <20050218194135.GD4424@katya>
References: <20050212003458.GI2568@katya> <20050214224208.GC13110@suse.de> <20050216105117.GB2360@katya> <20050216110752.GC2360@katya> <1108594961l.5056l.5l@serve.riede.org> <20050216231741.GD2870@katya> <1108596771l.5056l.6l@serve.riede.org> <20050218171737.GA20012@us.ibm.com> <20050218181106.GC4424@katya> <20050218183350.GA21954@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from apachihuilliztli.mtu.ru ([195.34.32.124]:7697 "EHLO
	Apachihuilliztli.mtu.ru") by vger.kernel.org with ESMTP
	id S261453AbVBRTlu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 14:41:50 -0500
Content-Disposition: inline
In-Reply-To: <20050218183350.GA21954@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Willem Riede <osst@riede.org>, linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Fri, Feb 18, 2005 at 10:33:50AM -0800, Patrick Mansfield wrote:
> The block SG_IO handles the ioctls, but not devices without a SCSI upper
> level driver (i.e. not tape, disk or cdrom).

Then it might make sense to explicitly list in sg.c the TYPE_* not
matched by s[dtr].

> In my experience, there are always applications that want to use the
> standard device driver (/dev/sda etc.) and others that want to use a
> generic driver.

So these drivers can compete for the same device?  Are there
deterministic rules on which one is supposed to win?  And is there a
userspace interface to unbind one driver and bind another?  Otherwise it
may mean that automatic module loading is inappropriate here at all...

Roman.
