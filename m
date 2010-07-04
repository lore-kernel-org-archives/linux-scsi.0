From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Sun, 4 Jul 2010 10:33:10 -0700
Message-ID: <20100704103310.368dee05@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
	<1278193640-24223-3-git-send-email-arnd@arndb.de>
	<20100704080146.GA31828@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100704080146.GA31828@merkur.ravnborg.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 4 Jul 2010 10:01:46 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:
> Lot's of other places could benefit from improved goto error handling.
> The driver maintainers should do this (if there is a maintainer).
> I stopped with the small replacement patches.

it's the floppy driver for amigas
not sure if any of those are still alive at all running linux.....

I think time can be more usefully spend on other drivers... 

this guy probably should move to staging instead


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
