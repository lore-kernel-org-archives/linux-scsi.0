From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 16:11:23 +0200
Message-ID: <20051020141123.GA7119@lst.de>
References: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com> <4356B3D3.1010203@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57248 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932075AbVJTOLw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 10:11:52 -0400
Content-Disposition: inline
In-Reply-To: <4356B3D3.1010203@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Oct 19, 2005 at 05:00:03PM -0400, Luben Tuikov wrote:
> On 10/19/05 16:08, Moore, Eric Dean wrote:
> > Luben:  He is adding support for linkerrors and link/phy reset;
> > these for for CSMI/SDI API.
> > 
> > Can you in your driver retreive link errors for the links on the expanders?
> 
> Yes. (offloaded to user space)
> 
> You use the user space program called "expander_conf.c" to
> send SMP requests and receive SMP responses.

Yes, exactly.  On the other hand we don't have standard
hardware-indepent ways of doing that for the PHYs of the HBA because
the programming interfaces are to different and need to abstract it away
in the kernel.  That's why I need the local_attached flag as an internal
helper - it's not actually exposed to userland so the implementation
