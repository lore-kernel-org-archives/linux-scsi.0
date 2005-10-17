From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Mon, 17 Oct 2005 13:25:48 +0200
Message-ID: <1129548348.2907.20.camel@laptopd505.fenrus.org>
References: <20051015013824.GA25248@linux-mips.org>
	 <1129544373.2907.18.camel@laptopd505.fenrus.org>
	 <4353830F.3010104@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40598 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932270AbVJQL0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 07:26:13 -0400
In-Reply-To: <4353830F.3010104@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Ralf Baechle <ralf@linux-mips.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Mon, 2005-10-17 at 20:55 +1000, Douglas Gilbert wrote:
> Arjan van de Ven wrote:
> > On Sat, 2005-10-15 at 02:38 +0100, Ralf Baechle wrote:
> > 
> >>FYI and reviewing pleassure.
> >>
> >>Author: Thiemo Seufer <ths@networkno.de>
> >>Date:   Tue Apr 12 14:00:38 2005 +0000
> >>
> >>Enable proc support, minor code cleanup.
> > 
> > 
> > isn't this the wrong way around; eg afaik we're deprecating proc support
> > from LLDD's...
> 
> No more ioctls for LLDDs, no more procfs, just a sysfs
> straight jacket

for this purpose sysfs and procfs are "enough the same" that it doesn't
warrant the term "staight jacket" imo.
And /proc is realistically the wrong place for such info....


