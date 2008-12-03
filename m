From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Wed, 3 Dec 2008 05:06:43 -0500
Message-ID: <20081203100643.GA29340@infradead.org>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 03, 2008 at 10:38:54AM +0900, FUJITA Tomonori wrote:
> This is for 2.6.29 (not 2.6.28) as feature-removal-schedule.txt says.
> 
> It's against linux-next (which seems to has some changes to ide-scsi
> for 2.6.29 from the ide tree). 

Isn't ide-scsi the only way to use ATAPI OnStream tapes supported by
the osst driver?

