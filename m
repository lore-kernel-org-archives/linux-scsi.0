From: "Alexander Stohr" <alexander.stohr@gmx.de>
Subject: Re: return value warnings about scsi_add_host, anything in progre ss?
Date: Mon, 7 Feb 2005 19:42:44 +0100
Message-ID: <001e01c50d44$da125960$8511050a@alexs>
References: <0E3FA95632D6D047BA649F95DAB60E570366267A@exa-atlanta> <20050207161022.GZ20386@parcelfarce.linux.theplanet.co.uk> <20050207162914.GA20386@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Received: from pop.gmx.de ([213.165.64.20]:28882 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261232AbVBGSmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2005 13:42:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Ju, Seokmann" <sju@lsil.com>, linux-scsi@vger.kernel.org

> On Mon, Feb 07, 2005 at 04:10:22PM +0000, Matthew Wilcox wrote:
> > I'm not sure why returning the result doesn't count as a "use" of the result
> > (in the case of megaraid).
> > 
> > > > From: Alexander Stohr [mailto:Alexander.Stohr@gmx.de]
> > > > 
> > > > ./drivers/scsi/megaraid.c:4890: error = scsi_add_host(host, &pdev->dev);
> 
> I don't get a warning from this line, using gcc 3.4.4 20041218 (prerelease)
> (Debian 3.4.3-7):
> 
> drivers/scsi/megaraid.c: In function `megadev_ioctl':
> drivers/scsi/megaraid.c:3626: warning: ignoring return value of `copy_to_user', declared with attribute warn_unused_result
> 
> Were you confused with that warning?

My main concern was the adaptec aic7 and aic9 series,
and i am aware that a one-time loading device should
have good chances to succeed, i dont call it critical for
my particular application case (some few Gigs main memory).

But as the very same problem exists all over the place,
even in USB devices - which can be plugged and unplugged
any now and then. Producing a memory leak of a few 10 
to 100 kB on every plug and remove is nothing really 
acceptable for a system that is expected to have longer uptimes.

So if there are some solutions out there for getting the return
value interpreted and in the error case the device registering 
canceled, then i asked if the respective coders and maintainers 
could pop up for getting thoses messages removed from the 
compiler`s output. Can you please? I just dont want to duplicate
any works here, or much worser code something that no one
with a better understanding would ever integrate into the kernel.

-Alex.
