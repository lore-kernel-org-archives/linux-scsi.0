From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Tue, 11 Dec 2018 06:07:23 -0800
Message-ID: <20181211140723.GB6576@infradead.org>
References: <20181211095027.GA3316@lvlogina.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181211095027.GA3316@lvlogina.cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parshuram Thombare <pthombar@cadence.com>
Cc: axboe@kernel.dk, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mchehab+samsung@kernel.org, gregkh@linuxfoundation.org, davem@davemloft.net, akpm@linux-foundation.org, nicolas.ferre@microchip.com, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, adouglas@cadence.com, jank@cadence.com, rafalc@cadence.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 11, 2018 at 09:50:27AM +0000, Parshuram Thombare wrote:
> Add real time crypto support to UFS HCD using new device
> mapper 'crypto-ufs'. dmsetup tool can be used to enable
> real time / inline crypto support using device mapper
> 'crypt-ufs'.

Can you point to where in the UFS spec this support is specified?
