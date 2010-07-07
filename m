From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] block: BKL removal, version 4
Date: Wed, 7 Jul 2010 12:44:28 -0400
Message-ID: <20100707164428.GA19667@infradead.org>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I haven't verified that the work in each ->ioctl method is correct,
but the concept and core code changes look good to me.

ACK for the series.

