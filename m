From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] scsi/sd: remove big kernel lock
Date: Tue, 6 Jul 2010 22:06:23 -0400
Message-ID: <20100707020623.GA28839@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-7-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-7-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

This looks fine, although relying on the bd_mutex held in the caller
for ->openers seems a bit fragile.  At least add a big comment about
this fact.
