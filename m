From: Dag Nygren <dag@newtech.fi>
Subject: Re: Bug in the sg driver
Date: Tue, 07 Oct 2003 15:50:10 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007125010.21495.qmail@dag.newtech.fi>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip213-185-39-113.laajakaista.mtv3.fi ([213.185.39.113]:6285
	"HELO dag.newtech.fi") by vger.kernel.org with SMTP id S262312AbTJGMuL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 08:50:11 -0400
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Tue, 07 Oct 2003 22:37:39 +1000." <3F82B393.4050900@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Dag Nygren <dag@newtech.fi>, Matthew Wilcox <willy@debian.org>, "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.orgdag@newtech.fi



Thanks for this response, this is of the kind that could
be useful.

> Dag,
> I presume the hp_ltt program is controlling a tape
> robot. hp_ltt sent a command to sg which passed it
> through the mid level to the aic7xxx driver which
> crashed. Hard to say why.

hp_ltt is a utility from HP to control their tapedrives,
ie. update firmware, diagnostic functions and so on.

The strange thing is that the URL I gave earlier in this thread 
would indicate the same behaviour with a completely
different SCSI-driver....

> New aic7xxx drivers can be found at:
>     http://people.freebsd.org/~gibbs/linux
> At the bottom of that page are newer rpms for RedHat 9
> (than distributed by redhat).

Thanks for that, I could try this out at some point.
Now the update of the tapedrive could be done by adding mem=512M
to the boot line, running the firmware update and then reboot again wo.
the memory limit.
So this was meant more like a report that something is wrong in there.

--- Dag

