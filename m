From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Convert megaraid2 to compat_ioctl
Date: Mon, 07 Feb 2005 15:12:27 -0600
Message-ID: <1107810748.5537.25.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570366267F@exa-atlanta>
	 <20050207210739.GD20386@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:440
	"EHLO redscar") by vger.kernel.org with ESMTP id S261328AbVBGVMf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 16:12:35 -0500
In-Reply-To: <20050207210739.GD20386@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Ju, Seokmann" <sju@lsil.com>, 'Andi Kleen' <ak@muc.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-02-07 at 21:07 +0000, Matthew Wilcox wrote:
> On Mon, Feb 07, 2005 at 04:01:11PM -0500, Ju, Seokmann wrote:
> > The kernel that I'm using is 2.6.9 and there is NO entry 'compat_ioctl' on
> > file_operations structure which is defined in <linux/fs.h>.
> 
> You need to use 2.6.11-rc3 (maybe the patches were in -rc1 or -rc2 as well).

Actually, if you could just try 

bk://linux-scsi.bkbits.net/scsi-misc-2.6

which is where I've put all the compat_ioctl conversions

The diffs (against -rc2 or -rc3) are in

http://parisc-linux.org/~jejb/scsi_diffs/

James


