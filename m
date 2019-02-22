From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi: sd: Optimal I/O size should be a multiple of
 physical block size
Date: Fri, 22 Feb 2019 06:30:44 -0800
Message-ID: <20190222143044.GB17324@infradead.org>
References: <20190212080409.GB10547@infradead.org>
 <20190212212105.17522-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190212212105.17522-1-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 12, 2019 at 04:21:05PM -0500, Martin K. Petersen wrote:
> It was reported that some devices report an OPTIMAL TRANSFER LENGTH of
> 0xFFFF blocks. That looks bogus, especially for a device with a
> 4096-byte physical block size.
> 
> Ignore OPTIMAL TRANSFER LENGTH if it is not a multiple of the device's
> reported physical block size.
> 
> To make the sanity checking conditionals more readable--and to
> facilitate printing warnings--relocate the checking to a helper
> function. No functional change aside from the printks.
> 
> Cc: <stable@vger.kernel.org>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199759
> Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
