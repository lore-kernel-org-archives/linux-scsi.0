From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 2.6] cciss: CCISS_GETLUNINFO fix
Date: Tue, 30 Nov 2004 08:21:54 -0600
Message-ID: <20041130142154.GB32035@beardog.cca.cpqcorp.net>
References: <20041129220725.GA32035@beardog.cca.cpqcorp.net> <1101800364.2640.25.camel@laptop.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ztxmail05.ztx.compaq.com ([161.114.1.209]:55054 "EHLO
	ztxmail05.ztx.compaq.com") by vger.kernel.org with ESMTP
	id S262086AbUK3OWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 09:22:10 -0500
Content-Disposition: inline
In-Reply-To: <1101800364.2640.25.camel@laptop.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: mike.miller@hp.com, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, akpm@osdl.org

On Tue, Nov 30, 2004 at 08:39:24AM +0100, Arjan van de Ven wrote:
> On Mon, 2004-11-29 at 16:07 -0600, mike.miller@hp.com wrote:
> > This patch addresses a problem with reading the partition table struct.
> > The last time this was submitted it was rejected on the grounds that the driver
> > has no business reading the partition table. I don't disagree with that, but
> > we have legacy apps to consider. Changing the ioctl would break those apps
> > already in customers hands.
> 
> Can we at least get your / HP's commitment that future versions of said
> tools will not use the ioctl ? (eg so that it eventually can be phased
> out)
> -- 
I will work with our application folks to phase this out. Some apps will
continue to require the LUN ID and usage count. Hopefully in the near
future I can obsolete this ioctl and reintroduce CCISS_GETLUNID which
only returns those values.

Thanks, 
mikem
> 
