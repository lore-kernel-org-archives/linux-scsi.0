From: Matthew Jacob <mjacob@feral.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: Fri, 20 Jun 2003 15:06:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030620150609.I305@wonky.in0.lcl>
References: <1055971780.2075.484.camel@mulgrave> <20030620101224.B305@wonky.in0.lcl>
 <1056129548.2102.19.camel@mulgrave> <20030620102448.O305@wonky.in0.lcl>
 <1056133068.1804.22.camel@mulgrave> <20030620183417.GB9164@gtf.org>
 <20030620113759.B305@wonky.in0.lcl> <3EF383D1.7070900@pobox.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:7693 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S264942AbTFTVya (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 17:54:30 -0400
In-Reply-To: <3EF383D1.7070900@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>



> Matthew Jacob wrote:
> > a) Historically, MMIO has been buggy on ia32. This is no longer the
> > case, but there definitely were a lot of platforms with this broken.
>
> Could you elaborate?
>
> What I've mostly found is (in order of frequency):  coders unfamiliar
> with x86 CPU write coalescing/posting rules, and PCI boards whose
> hardware designs contain inherent races when driven in MMIO mode
> (particularly on CPUs with deeply posted writes).

The latter, I believe.

>
>
> > b) MMIO is consumption of mapping resources, while PIO isn't.
>
> agreed
>
> 	Jeff
>
>
>
>
