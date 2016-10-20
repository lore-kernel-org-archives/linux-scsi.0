From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] scsi: smartpqi: Replace semaphore lun_reset_sem with mutex
Date: Thu, 20 Oct 2016 11:08:22 +0200
Message-ID: <4950855.ODPuVsJ6pJ@wuerfel>
References: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org> <1476953642-2160-3-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476953642-2160-3-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday, October 20, 2016 2:24:02 PM CEST Binoy Jayan wrote:
> Semaphores are going away in the future, so replace the semaphore
> lun_reset_sem with the a mutex lock.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
