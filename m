From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 13:18:21 +0100
Message-ID: <1156853901.5036.0.camel@imp.csi.cam.ac.uk>
References: <44EFBEFA.2010707@student.ltu.se>
	 <20060828093202.GC8980@infradead.org>
	 <20060828171804.09c01846.akpm@osdl.org> <44F3952B.5000500@yahoo.com.au>
	 <1156836578.26009.6.camel@imp.csi.cam.ac.uk>
	 <20060829114634.GE4076@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:61595 "EHLO
	ppsw-0.csi.cam.ac.uk") by vger.kernel.org with ESMTP
	id S1750714AbWH2MSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 08:18:48 -0400
In-Reply-To: <20060829114634.GE4076@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2006-08-29 at 12:46 +0100, Christoph Hellwig wrote:
> On Tue, Aug 29, 2006 at 08:29:38AM +0100, Anton Altaparmakov wrote:
> > Not sure whether this is meant in favour of one or the other but we are
> > not programming in C strictly speaking but in C99+gccisms and C99
> > includes _Bool...
> 
> as does it include float, double, _Complex and other things we don't use.

We don't use those for completely different reasons...  But you knew
that already...

Best regards,

        Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer / IRC: #ntfs on irc.freenode.net
WWW: http://www.linux-ntfs.org/ & http://www-stu.christs.cam.ac.uk/~aia21/

