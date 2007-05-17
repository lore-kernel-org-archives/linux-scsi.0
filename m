From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Fri, 18 May 2007 00:34:40 +0530
Message-ID: <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
References: <20070515120228.GI10562@parisc-linux.org>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	 <20070516025121.GK10562@parisc-linux.org>
	 <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
	 <20070517172023.GL10562@parisc-linux.org>
	 <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
	 <20070517182414.GA12170@infradead.org>
	 <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
	 <20070517185115.GA13207@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:28524 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbXEQTEl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 15:04:41 -0400
Received: by wr-out-0506.google.com with SMTP id 76so729322wra
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2007 12:04:40 -0700 (PDT)
In-Reply-To: <20070517185115.GA13207@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>, Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On 5/18/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 18, 2007 at 12:17:40AM +0530, Satyam Sharma wrote:
> > However, Ben does have a point that we shouldn't force those
> > using SCSI (and wishing to use the new async scanning
> > feature) to depend on and use sysfs too
>
> yes, we do.  an no, procfs is a much worse filesystem to depend
> on for drivers.

By depend on I meant being forced to build and run it. /proc is
clearly more-or-less standard that almost everybody uses, otoh
users that do not run sysfs are more common.

> if people don't want sysfs they can either do the synchronous scan
> or do their own scan in userspace.

Hmmm, actually those other users could easily write and maintain
a 20-line patch that does the wait for async scans thing for them
using /proc/scsi/scsi in any case.
