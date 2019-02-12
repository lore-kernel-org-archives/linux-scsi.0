From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: sd: Optimal I/O size should be a multiple of
 physical block size
Date: Tue, 12 Feb 2019 00:04:09 -0800
Message-ID: <20190212080409.GB10547@infradead.org>
References: <20190208234147.1316-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190208234147.1316-1-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 08, 2019 at 06:41:47PM -0500, Martin K. Petersen wrote:
> It was reported that some devices report an OPTIMAL TRANSFER LENGTH of
> 0xFFFF blocks. That looks bogus, especially for a device with a
> 4096-byte physical block size.
> 
> Ignore OPTIMAL TRANSFER LENGTH if it is not a multiple of the device's
> reported physical block size.

Looks generally fine, but should we log a warning in case of a bogus
OPTIMAL TRANSFER LENGTH?
