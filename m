From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: linux-next: manual merge of the scsi-mkp tree with the char-misc
 tree
Date: Fri, 7 Apr 2017 13:29:20 -0600
Message-ID: <ba19c6cf-a762-f7f7-6e27-ef64e3e578c1@deltatee.com>
References: <20170407153351.0ecafd59@canb.auug.org.au>
 <47b500d6-0700-812f-dda3-44a14014b66e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <47b500d6-0700-812f-dda3-44a14014b66e@sandisk.com>
Sender: linux-next-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

On 07/04/17 09:49 AM, Bart Van Assche wrote:
> Sorry that I had not yet noticed Logan's patch series. Should my two
> patches that conflict with Logan's patch series be dropped and reworked
> after Logan's patches are upstream?

Yeah, Greg took my patchset around a few maintainers relatively quickly.
This is the second conflict, so sorry about that. Looks like the easiest
thing would be to just base your change off of mine. It doesn't look too
difficult. If you can do it before my patch hits upstream, I'd
appreciate some testing and/or review as no one from the scsi side
responded and that particular patch was a bit more involved than I would
have liked.

Thanks,

Logan
