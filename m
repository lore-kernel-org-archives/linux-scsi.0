From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [27/27]
Date: Thu, 17 Feb 2005 20:36:42 +0000
Message-ID: <20050217203642.GA9030@infradead.org>
References: <4214D6A6.4010100@adaptec.com> <4214FF23.2070505@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:62873 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262345AbVBQUgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 15:36:45 -0500
Content-Disposition: inline
In-Reply-To: <4214FF23.2070505@tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Feb 17, 2005 at 11:31:31PM +0300, Michael Tokarev wrote:
> Luben Tuikov wrote:
> >The readme file.
> >
> >diff -Nru a/drivers/scsi/adp94xx/readme.txt 
> []
> >+=                            README for                            =
> >+=                  Red Hat Linux Advanced Server 2.1               =
> >+=           Red Hat Enterprise Linux 3.0                           =   
> >+=           SuSE Linux Enterprise Server 8 / UnitedLinux 1.0       =
> >+=                   SuSE Linux Enterprise Server 9                 =
> 
> Hmm... will it work with a distribution not listed above? ;)
> Sorry can't resist...

Even if it does this README doesn't belong into the kernel tree.

