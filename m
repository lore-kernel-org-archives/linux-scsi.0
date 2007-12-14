From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] scsi device recovery
Date: Fri, 14 Dec 2007 13:28:48 +0100
Message-ID: <200712141328.49196.bs@q-leap.de>
References: <200712121354.14474.bs@q-leap.de> <200712141304.12490.bs@q-leap.de> <20071214122255.GU26334@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:39931 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXLNM2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 07:28:51 -0500
In-Reply-To: <20071214122255.GU26334@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Friday 14 December 2007 13:22:55 Matthew Wilcox wrote:
> On Fri, Dec 14, 2007 at 01:04:12PM +0100, Bernd Schubert wrote:
> > PS: Do you have some links to scsi and SPI specs?
>
> The final versions are available for a fee from ANSI.  However,
> you can download the final draft versions for free from
> http://www.t10.org/drafts.htm  You probably want:
>
> http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf (SCSI Architecture)
> http://www.t10.org/ftp/t10/drafts/spi5/spi5r06.pdf (Parallel SCSI)
> http://www.t10.org/ftp/t10/drafts/sdv/sdv-r08b.pdf (Domain Validation)
> http://www.t10.org/ftp/t10/drafts/spc3/spc3r23.pdf (Primary Commands)
> http://www.t10.org/ftp/t10/drafts/sbc2/sbc2r16.pdf (Block Commands)
>
> I sometimes find it easier to look at SCSI-2 to find
> things which haven't changed in the last fourteen years:
> http://www.t10.org/ftp/t10/drafts/s2/s2-r10l.pdf

Thanks a lot!!!


-- 
Bernd Schubert
Q-Leap Networks GmbH
