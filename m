From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: status of block-integrity
Date: Tue, 7 Jan 2014 16:34:10 -0700
Message-ID: <20140107233410.GA1263@parisc-linux.org>
References: <20131222192128.GA28532@infradead.org> <yq11u134rmt.fsf@sermon.lab.mkp.net> <52CBBABD.50902@gmail.com> <52CC0216.5060900@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52CC0216.5060900@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Ric Wheeler <ricwheeler@gmail.com>, "Martin K. Petersen" <mkp@mkp.net>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 07, 2014 at 02:33:10PM +0100, Hannes Reinecke wrote:
> I would indeed like to have a discussion at LSF about the future of
> DIX. DIF is not an issue, as most HBAs support it already and we
> actually need it for proper connectivity.
> 
> DIX, OTOH, has been left dormant since time immemorial, with the
> only known (supposed) user being Oracle.
> (I actually talked to the DB/2 folks about it, and the response
> was a polite feigned interest ...)

I think there's a terminology confusion here; you seem to be using DIX
to mean the TCP CRC and DIF to mean T10DIF.  I've seen other people use
DIX to mean separate SGLs for metadata and DIF to mean interleaved data.
Can you confirm which thing you mean here?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
