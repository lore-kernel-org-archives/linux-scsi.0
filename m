From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] scsi: ufs: add real time/inline crypto support to
 UFS HCD
Date: Tue, 11 Dec 2018 06:06:43 -0800
Message-ID: <20181211140643.GA6576@infradead.org>
References: <20181211094910.GA28288@lvlogina.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181211094910.GA28288@lvlogina.cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parshuram Thombare <pthombar@cadence.com>
Cc: axboe@kernel.dk, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mchehab+samsung@kernel.org, gregkh@linuxfoundation.org, davem@davemloft.net, akpm@linux-foundation.org, nicolas.ferre@microchip.com, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org, jbacik@fb.com, michaelcallahan@fb.com, snitzer@redhat.com, osandov@fb.com, keith.busch@intel.com, ming.lei@redhat.com, shli@fb.com, dennisszhou@gmail.com, adouglas@cadence.com, jank@cadence.com, rafalc@cadence.com
List-Id: linux-scsi@vger.kernel.org

Patch 1 is missing in your series.

But even without looking at it I think your design doesn't make a whole
lot of sense.  If the encryption is implemented in the ufs driver you
should not need device mapper support for it, just ufs driver support
and maybe a little block layer glue.
