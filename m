From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: qla2xxx tcq question/bug
Date: Sun, 11 Jul 2004 23:28:56 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0407112327200.8012@poirot.grange>
References: <40EF2697.20804@us.ibm.com> <20040709234644.GB14787@praka.san.rr.com>
  <20040709235443.GA14953@praka.san.rr.com> <1089427459.2342.149.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:24557 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266527AbUGKVeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jul 2004 17:34:37 -0400
In-Reply-To: <1089427459.2342.149.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <praka@users.sourceforge.net>, Mike Christie <mikenc@us.ibm.com>, andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 9 Jul 2004, James Bottomley wrote:

> On Fri, 2004-07-09 at 18:54, Andrew Vasquez wrote:
>> BTW: 53c700.c appears to be the only scsi driver which calls
>> scsi_activate_tcq()???
>
> That would be because two years ago the scsi maintainer tried to make it
> an example to other driver writers of how to use the block layer tag
> command queueing.
>
> You could say that was one of the less successful instances of leading
> by example...

Wow! I was all this time wondering why the tagged-command queuing was done 
in LLD, and was going to ask if it shouldn't be indeed done 
generically:-)) I know now!:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

