From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/6] block: Make max_discard_sectors sector_t
Date: Fri, 20 Aug 2010 10:59:17 +0200
Message-ID: <20100820085917.GC27033@lst.de>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com> <1282232941-9910-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1282232941-9910-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2010 at 11:48:58AM -0400, Martin K. Petersen wrote:
> With 4KB ATA TRIM payloads we can express ranges above the 32 bits
> allowed by SCSI.  Convert max_discard_sectors to sector_t.

Looks good from a correctnes point of view, but as long as bi_size
is just an unsgined int it's not going to help us much with larger
discard sizes.

