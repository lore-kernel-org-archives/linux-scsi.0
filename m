From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 10:21:13 -0600
Message-ID: <1225988473.4703.85.camel@localhost.localdomain>
References: <4913028B.6010405@redhat.com> <49130CF2.6010403@hp.com>
	 <491313E5.6060505@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <491313E5.6060505@hp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-11-06 at 10:57 -0500, jim owens wrote:
> James Bottomley wrote:
> 
> > By the way, the latest (from 2 days ago) version of the Thin
> > Provisioning proposal is here:
> > 
> > http://www.t10.org/ftp/t10/document.08/08-149r4.pdf
> 
> If I understand the spec [ not likely ;) ] ...
> 
> jim owens wrote:
> 
>  > And the vendors need to provide the device trim chunk size in
>  > a standard way (like scsi geometry) to the filesystem.
> 
> It may be that the READ CAPACITY (16) provides the trim chunk
> size via the "logical blocks per physical block exponent".
> 
> But since this is just a T10 spec, I would want that
> interpretation verified by the array vendors.

This could be ... I think it's original intention was to allow us to
figure out that we had a 4k sector disk emulating a 512b sector one.
However, it's also a useful way to parametrise the erase block size for
SSDs as well as the array track size.

James


