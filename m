From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/7] block: BKL removal, version 4
Date: Wed, 07 Jul 2010 21:36:42 +0200
Message-ID: <4C34D74A.4060308@kernel.dk>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57253 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab0GGTgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 15:36:47 -0400
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org

On 07/07/10 16.51, Arnd Bergmann wrote:
> This series removes the big kernel lock from the common
> block layer code by pushing it into the individual
> device drivers.
> 
> This version incorporates further changes to address
> comments from Christoph Hellwig and Sam Ravnborg,
> many thanks for the valuable feedback!
> 
> I'd like to get this into 2.6.36 in order to remove
> the BKL from all the core kernel code.
> 
> Once Christoph is happy with the series, in particular
> the third patch, I'd like to add it to linux-next
> for broader testing, preferrably though Jens Axboe's
> linux-2.6-block.git tree.

I'll go over each one tomorrow and add the series. Thanks
a lot for getting this done!

-- 
Jens Axboe

