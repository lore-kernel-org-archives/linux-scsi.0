From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: Sat, 18 Oct 2003 17:38:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031018163820.GC18370@parcelfarce.linux.theplanet.co.uk>
References: <1066265974.16761.426.camel@fuzzy> <3F8E8786.2020502@torque.net> <20031016132804.GA18370@parcelfarce.linux.theplanet.co.uk> <20031018082450.A6510@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9856 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261692AbTJRQi1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Oct 2003 12:38:27 -0400
Content-Disposition: inline
In-Reply-To: <20031018082450.A6510@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Wilcox <willy@debian.org>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com

On Sat, Oct 18, 2003 at 08:24:50AM -0700, Patrick Mansfield wrote:
> If you have not seen it, Badari's sd patch is in the mm tree:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.0-test7/2.6.0-test7-mm1/broken-out/support-zillions-of-scsi-disks.patch

I hadn't ... it doesn't address expanding the number of partitions or
the problem that the sd_index_bits array will grow to a huge size.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
