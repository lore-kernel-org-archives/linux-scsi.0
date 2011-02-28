From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Mon, 28 Feb 2011 03:49:29 -0500
Message-ID: <20110228084929.GA27227@infradead.org>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: "djwong@us.ibm.com" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2011 at 09:13:49AM -0700, Andreas Dilger wrote:
> Can you please attach your reproducer? IIRC it needed mmap() to hit this problem?  Did you measure CPU usage during your testing?

Running XFSQA on a DIF target reproduces it.  Even scsi_debug in the
right mode is enough.
