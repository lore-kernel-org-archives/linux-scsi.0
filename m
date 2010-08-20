From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Fri, 20 Aug 2010 10:58:01 +0200
Message-ID: <20100820085801.GB27033@lst.de>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com> <1282232941-9910-3-git-send-email-martin.petersen@oracle.com> <AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com> <yq1fwyamq9s.fsf@sermon.lab.mkp.net> <4C6DA713.40601@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59063 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0HTI6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 04:58:09 -0400
Content-Disposition: inline
In-Reply-To: <4C6DA713.40601@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Freemyer <greg.freemyer@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Thu, Aug 19, 2010 at 05:50:11PM -0400, Mark Lord wrote:
> On 10-08-19 02:05 PM, Martin K. Petersen wrote:
> >I'm only aware of one drive that currently
> >supports more than 512 bytes of payload and it also caps at 4KB.
> 
> SSDs based upon the Indilinx Barefoot controller support
> more or less "infinite" payload for TRIM, with no cap.
> But it predates idword[105], so just has a zero there.

Is there an easy way to identify them?  If so we could add a quirk
for them if it provides enough benefit.

