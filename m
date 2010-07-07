From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Date: Tue, 6 Jul 2010 21:52:07 -0400
Message-ID: <20100707015207.GE2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-2-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-2-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looking at this again I don't like the foo_unlock_ioctl naming you're
adding.  Just rename the existing ioctl routines to foo_locked_ioctl
or move the lock_kernel/unlock_kernel calls into the function, which
would be even better.
