From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/7] block: BKL removal, version 4
Date: Thu, 08 Jul 2010 10:53:20 +0200
Message-ID: <4C359200.8070105@kernel.dk>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <4C34D74A.4060308@kernel.dk> <201007072218.24013.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007072218.24013.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2010-07-07 22:18, Arnd Bergmann wrote:
> On Wednesday 07 July 2010 21:36:42 Jens Axboe wrote:
>> I'll go over each one tomorrow and add the series.
> 
> Ok, thanks!
> 
> If it makes your life easier, feel free to get this series from
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git block

I applied it manually with the fixups mention, one of them also needed
a bit of hand holding (applying with fuzz). The end result looks good
and it survives an allmodconfig at least.

-- 
Jens Axboe
