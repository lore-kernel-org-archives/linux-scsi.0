From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: 2.6.0-test9 kernel oops
Date: Mon, 24 Nov 2003 07:41:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124154148.GA7715@beaverton.ibm.com>
References: <20031123231037.44115c6f.akpm@osdl.org> <1069687425.1900.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:64496 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263771AbTKXPiF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 10:38:05 -0500
Content-Disposition: inline
In-Reply-To: <1069687425.1900.9.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Tomas Kostrian <kostrian@deepblue.sk>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Mon, 2003-11-24 at 01:10, Andrew Morton wrote:
> > Can anyone else with an aic7xxx reproduce (and hence fix) this?
> > /proc/scsi/aic7xxx/0 works happily on my test box.
> 
> Actually (since I managed to dig out an x86 aic7xxx based machine), I've
> tried this and not seen the problem...it could be because I've been
> testing out with the two SCSI refcount fixes as well...I'll try
> stripping them back.

I tried with just plain test9 and cannot get the error to reproduce. 

Tomas, Can you send the dmesg output of the driver loading.

-andmike
--
Michael Anderson
andmike@us.ibm.com

