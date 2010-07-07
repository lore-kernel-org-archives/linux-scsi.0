From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/6] scsi/sd: remove big kernel lock
Date: Wed, 7 Jul 2010 15:54:38 +0200
Message-ID: <201007071554.38395.arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-7-git-send-email-arnd@arndb.de> <20100707020623.GA28839@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100707020623.GA28839@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> 
> This looks fine, although relying on the bd_mutex held in the caller
> for ->openers seems a bit fragile.  At least add a big comment about
> this fact.

Ok, added the comment.

	Arnd
