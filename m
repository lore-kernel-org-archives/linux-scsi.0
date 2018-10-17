From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Thu, 18 Oct 2018 10:01:22 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810180937590.8@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au> <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de> <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
 <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de> <alpine.LNX.2.21.1810161611150.130@nippy.intranet> <20181017080923.GC24540@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080923.GC24540@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 17 Oct 2018, Christoph Hellwig wrote:

> 
> Please leave the possibly unused exports as-is.
> 

I take that to mean "leave the conditional export as-is". Hence, I think 
v3 (posted on the 16th) should address all of the concerns raised by 
reviewers...

-- 
