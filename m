From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] libata: Fix garbled Trim payload
Date: Sat, 21 Nov 2009 05:47:01 -0500
Message-ID: <20091121104701.GA30153@infradead.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1258771524-26673-5-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2009 at 09:45:24PM -0500, Martin K. Petersen wrote:
> ata_set_lba_range_entries confused indexes into a u64 buffer with byte
> offsets.  Fix this up and document the return value.
> 
> Update the libata write same translation to reflect this.

Once we fix up this beast we should also change the current max argument
to encode the buffer size, not the maximum number of entries which is a
rather confusing interface.

