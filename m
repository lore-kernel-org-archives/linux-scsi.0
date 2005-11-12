From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC: 2.6 patch] remove ISA legacy functions
Date: Sat, 12 Nov 2005 07:12:02 +0000
Message-ID: <20051112071201.GA29136@infradead.org>
References: <20051107200336.GH3847@stusta.de> <20051110042857.38b4635b.akpm@osdl.org> <20051111021258.GK5376@stusta.de> <20051110182443.514622ed.akpm@osdl.org> <20051111201849.GP5376@stusta.de> <20051111202005.GQ5376@stusta.de> <20051111203601.GR5376@stusta.de> <20051112045216.GY5376@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42380 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932306AbVKLHMO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 02:12:14 -0500
Content-Disposition: inline
In-Reply-To: <20051112045216.GY5376@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, jonathan@buzzard.org.uk, tlinux-users@tce.toshiba-dme.co.jp, Jaroslav Kysela <perex@suse.cz>, viro@ftp.linux.org.uk

On Sat, Nov 12, 2005 at 05:52:16AM +0100, Adrian Bunk wrote:
> This patch removes the ISA legacy functions that are deprecated since 
> kernel 2.4 and that aren't available on all architectures.
> 
> The 7 drivers that were still using this obsolete API are now marked
> as BROKEN.

NACK.  Al has patches pending to convert them to proper APIs, please
wait until after that patchseries has landed.

