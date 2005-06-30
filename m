From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 64-bit SCSI LUN addressing on Linux
Date: Thu, 30 Jun 2005 18:06:34 +0100
Message-ID: <20050630170634.GA31249@infradead.org>
References: <42C41745.1020302@datadirectnet.com> <42C4245C.8010008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30856 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263006AbVF3RGg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 13:06:36 -0400
Content-Disposition: inline
In-Reply-To: <42C4245C.8010008@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "Martin W. Schlining III" <mschlining@datadirectnet.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Jun 30, 2005 at 12:57:00PM -0400, Douglas Gilbert wrote:
> Martin W. Schlining III wrote:
> >Does Linux support 64-bit SCSI LUN addressing?
> 
> No. Linux supports 32 bit LUNs.
> 
> >Suppose I have a system 
> >that can create SCSI LUNs that are greater than 2TB using a block size 
> >of 512 bytes and can accept 16 byte CDBs, can I use this LUN with a 2.6 
> >series Linux kernel?
> 
> There is no relationship between 64 bit LUNS (which,
> for example, support a hierarchy of up to 4, 16 bit LUNs)
> and the ability of a logical unit (LU) (e.g. a disk) to
> support 64 bit logical block addressing (LBA).
> 
> Christoph's reply more accurately addresses the question
> I think you were trying to ask...

Yeah, people tend to say LUNs when they mean storage devices a lot,
so I've started to look over the slight misuses if things make sense
otherwise.

