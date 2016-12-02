From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 02 Dec 2016 08:29:43 -0500
Message-ID: <1480685383.28416.147.camel@localhost.localdomain>
References: <1479752642.19792.43.camel@localhost.localdomain>
         <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
         <1479839407.28416.21.camel@localhost.localdomain>
         <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
         <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
         <1479932524.28416.43.camel@localhost.localdomain>
         <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
         <1194718949.74785.1480096576577.JavaMail.zimbra@redhat.com>
         <1480523188.28416.94.camel@localhost.localdomain>
         <yq18trzhink.fsf@sermon.lab.mkp.net> <20161202122133.GA14247@infradead.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751187AbcLBN3p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 08:29:45 -0500
In-Reply-To: <20161202122133.GA14247@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Laurence Oberman <loberman@redhat.com>, Eyal Ben David <bdeyal@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Fri, 2016-12-02 at 04:21 -0800, Christoph Hellwig wrote:
> On Thu, Dec 01, 2016 at 08:40:31AM -0500, Martin K. Petersen wrote:
> > Specifically, the problem appears to be caused by the removal of
> > the setting of bio->bi_bdev, which would previously be set to NULL.
> > If I add:
> 
> Very odd.  For one I would expect it to be NULL anyway, second
> I don't see why the behavior changed.  But given that this reverts
> to the original assignment and makes things work I'll happily hack it
> to get things working again:
> 
> Acked-by: Christoph Hellwig <hch@lst.de>

Yeah, I'm not sure I understand this either, apart from the change
adjusting the code to effectively do what it used to and making the
test case work.  I'm reluctant to cc: stable yet, let me look at this
a bit more and I'll post the actual patch soon.

-Ewan


