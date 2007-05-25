From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/7] libata: check for AN support
Date: Thu, 24 May 2007 23:15:56 -0400
Message-ID: <465654EC.9080805@garzik.org>
References: <20070510072247.063476979@intel.com>	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com>	<20070509220952.5fa34822.akpm@linux-foundation.org> <20070510100215.94c3a2ea.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070510100215.94c3a2ea.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, "Randy.Dunlap" <rdunlap@xenotime.net>
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> Check to see if an ATAPI device supports Asynchronous Notification.
> If so, enable it.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
> Andrew, I cleaned up the function header to properly comply with kernel
> doc requirements.  Other than that, this patch is the same.  

I would ask for a simple revision:  update ata_dev_set_AN() such that it 
takes a second argument 'enable'.  This boolean indicates to the 
function whether SETFEATURES_SATA_ENABLE or SETFEATURES_SATA_DISABLE 
should be passed to the device.

Otherwise than that, it's ready to merge I would say.

