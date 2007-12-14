From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi device recovery
Date: Fri, 14 Dec 2007 05:22:55 -0700
Message-ID: <20071214122255.GU26334@parisc-linux.org>
References: <200712121354.14474.bs@q-leap.de> <200712121854.42669.bs@q-leap.de> <1197555513.3154.30.camel@localhost.localdomain> <200712141304.12490.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55799 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXLNMW4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2007 07:22:56 -0500
Content-Disposition: inline
In-Reply-To: <200712141304.12490.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Fri, Dec 14, 2007 at 01:04:12PM +0100, Bernd Schubert wrote:
> PS: Do you have some links to scsi and SPI specs? 

The final versions are available for a fee from ANSI.  However,
you can download the final draft versions for free from
http://www.t10.org/drafts.htm  You probably want:

http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf (SCSI Architecture)
http://www.t10.org/ftp/t10/drafts/spi5/spi5r06.pdf (Parallel SCSI)
http://www.t10.org/ftp/t10/drafts/sdv/sdv-r08b.pdf (Domain Validation)
http://www.t10.org/ftp/t10/drafts/spc3/spc3r23.pdf (Primary Commands)
http://www.t10.org/ftp/t10/drafts/sbc2/sbc2r16.pdf (Block Commands)

I sometimes find it easier to look at SCSI-2 to find
things which haven't changed in the last fourteen years:
http://www.t10.org/ftp/t10/drafts/s2/s2-r10l.pdf

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
