From: "Alexander Stohr" <alexander.stohr@gmx.de>
Subject: Re: return value warnings about scsi_add_host, anything in progre ss?
Date: Tue, 8 Feb 2005 12:13:52 +0100
Message-ID: <009301c50dcf$4f446180$8511050a@alexs>
References: <0E3FA95632D6D047BA649F95DAB60E570366267A@exa-atlanta> <20050207161022.GZ20386@parcelfarce.linux.theplanet.co.uk> <20050207162914.GA20386@parcelfarce.linux.theplanet.co.uk> <001e01c50d44$da125960$8511050a@alexs> <20050207185759.GC20386@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Received: from pop.gmx.de ([213.165.64.20]:64656 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261513AbVBHLNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2005 06:13:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> I think you misunderstood my point.  megaraid does not produce a warning
> about a missing return check when I compile it with gcc-3.4.  Does it
> warn for you?  If not, why did you include it in the list?

I grepped the whole source tree and discared the locations where
in the very same line the return value got obviousely used for something.
I am not sure right now why megaraid got into the list.
The listing was meant as a summary information where
the described sitatuion might be present as well.
I agree, i should have checked the lines in front of the statement
for every single location, to avoid any false positives. I didnt do that.

-Alex.
