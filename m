From: Torsten Duwe <duwe@lst.de>
Subject: Re: [PATCH v2 1/3] crypto: Introduce notifier for new crypto
 algorithms
Date: Tue, 4 Sep 2018 15:30:06 +0200
Message-ID: <20180904133006.GA28715@lst.de>
References: <20180827060918.tfz7ljufqhlej4kq@gondor.apana.org.au> <20180830150016.15661-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180830150016.15661-1-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: herbert@gondor.apana.org.au, Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 30, 2018 at 11:00:14AM -0400, Martin K. Petersen wrote:
> Introduce a facility that can be used to receive a notification
> callback when a new algorithm becomes available. This can be used by
> existing crypto registrations to trigger a switch from a software-only
> algorithm to a hardware-accelerated version.

While this is apparently fine with the patch set you sent, what about
cases where the crypto context of old and new implementation is not
100% compatible? The switch will still work for sure if there are no
current active users of the algo, but otherwise...? Just a thought.

	Torsten
