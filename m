From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Thin provisioning fixes
Date: Thu, 26 Nov 2009 06:05:45 -0500
Message-ID: <20091126110545.GA364@infradead.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <20091126105947.GA28120@infradead.org> <20091126110157.GV8742@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091126110157.GV8742@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2009 at 12:01:57PM +0100, Jens Axboe wrote:
> I was waiting for the discussion to settle and a repost. Let me know if
> I should just pick up the current #1.

As far as I'm concerned the discussion was just about the example use
case Martin mentioned.  Exposing wether a device zeroes discarded blocks
is a good thing in general.

Note that we might have to add blacklists for this in libata pretty soon
as the OCZ Vertex seems to get it wrong, but that's material for another
patch not touching the block layer..

