From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] Remove remainig MCR SCSI drivers
Date: Fri, 06 Jul 2018 10:52:56 -0700
Message-ID: <1530899576.3142.3.camel@HansenPartnership.com>
References: <20180706133349.28508-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706133349.28508-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-07-06 at 15:33 +0200, Johannes Thumshirn wrote:
> MCR Support was ripped out of the kernel in 2012. I think 6 years
> later we can kill the remaining drivers which couldn't have been
> compiled since then.
> 
> Johannes Thumshirn (2):
>   scsi: remove NCR_D700 driver
>   scsi: remove NCR_Q720 driver

Since they're my drivers,

Acked-by: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>

James
