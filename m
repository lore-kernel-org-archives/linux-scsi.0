From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: I can't use aic79xx with RAID
Date: 19 Apr 2003 00:46:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050709614.2269.21.camel@dhcp22.swansea.linux.org.uk>
References: <20030418154452.GA27820@galliera.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:47054
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S263324AbTDSAdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2003 20:33:03 -0400
In-Reply-To: <20030418154452.GA27820@galliera.it>
List-Id: linux-scsi@vger.kernel.org
To: debe@galliera.it
Cc: linux-scsi@vger.kernel.org

On Gwe, 2003-04-18 at 16:44, Marco De Benedetto wrote:
> I have compiled the kernel 2.4.20 with the 2.4.21-pre7 patch and the
> support for aic79xx, now I can see the two disks but after creating
> the RAID(0/1) the kernel does not see any disk.  I have also tried the
> latest drivers from Justin T. Gibbs.

Software raid is independant of the underlying driver so that bit should
just work.

> BTW, does someone know what are the performance of the Linux sw RAID1
> with respect to hw RAID1?

CPU wise its basically zero overhead. The PCI bus overhead kills you at
high performance rates so its a tradeoff. On the other hand most but not
all hardware raid cards have crappy on board controllers, firmware that
is funny, non free managemet tools and low power CPU's that mean they
still underperform software raid in most respects.


