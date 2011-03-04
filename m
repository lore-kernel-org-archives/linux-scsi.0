From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Fri, 4 Mar 2011 15:53:15 -0500
Message-ID: <20110304205315.GA10389@infradead.org>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <4D634D8F.4070401@panasas.com>
 <20110222114222.GA24728@quack.suse.cz>
 <20110304205143.GE27190@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110304205143.GE27190@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 04, 2011 at 12:51:43PM -0800, Darrick J. Wong wrote:
> Hmm.  Any interest in pushing the page copy patch as an interim solution while
> I work on getting the wait-on-writeback strategy to function?  I agree it's not
> the fastest solution, but at least it won't be running broken while I find the
> faster solution(s).

It's not only slow but also butt ugly.  NAK from me - we need to get
this completely right, not hack around it.
