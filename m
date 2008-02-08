From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Fri, 8 Feb 2008 06:04:50 +0000
Message-ID: <20080208060450.GA1031@infradead.org>
References: <477CFC97.2010201@panasas.com> <477D0209.2000609@panasas.com> <1199384189.3122.22.camel@localhost.localdomain> <Pine.LNX.4.64.0801032003170.27528@anakin> <1199686061.31422.2.camel@kars.perseus.home> <1201802886.3131.35.camel@localhost.localdomain> <Pine.LNX.4.64.0801311953540.22762@anakin> <1201807916.3131.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60376 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYBHGEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 01:04:55 -0500
Content-Disposition: inline
In-Reply-To: <1201807916.3131.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Kars de Jong <jongk@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jan 31, 2008 at 01:31:56PM -0600, James Bottomley wrote:
> > Is git smart enough to follow history between files that get removed and
> > readded?
> 
> Yes.  git revert on the removal changeset will re-add all the files and
> try to put the entries back into Kconfig and Makefile.

Note that it doesn't really matter.  Looking at the existing conversion
there's been no line left the same except for the standard #include
statements.
