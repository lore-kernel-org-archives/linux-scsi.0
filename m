From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 19:51:15 +0100
Message-ID: <20070517185115.GA13207@infradead.org>
References: <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com> <20070516025121.GK10562@parisc-linux.org> <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55529 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbXEQSv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 14:51:27 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>, Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

On Fri, May 18, 2007 at 12:17:40AM +0530, Satyam Sharma wrote:
> However, Ben does have a point that we shouldn't force those
> using SCSI (and wishing to use the new async scanning
> feature) to depend on and use sysfs too

yes, we do.  an no, procfs is a much worse filesystem to depend
on for drivers.  if people don't want sysfs they can either do
the synchronous scan or do their own scan in userspace.

