From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Convert megaraid2 to compat_ioctl
Date: Mon, 7 Feb 2005 21:07:39 +0000
Message-ID: <20050207210739.GD20386@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E570366267F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9662 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261326AbVBGVHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 16:07:46 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570366267F@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: 'Andi Kleen' <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, Feb 07, 2005 at 04:01:11PM -0500, Ju, Seokmann wrote:
> The kernel that I'm using is 2.6.9 and there is NO entry 'compat_ioctl' on
> file_operations structure which is defined in <linux/fs.h>.

You need to use 2.6.11-rc3 (maybe the patches were in -rc1 or -rc2 as well).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
