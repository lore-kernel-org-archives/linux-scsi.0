From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH 07/12] ics932s401: New driver
Date: Wed, 8 Oct 2008 13:09:59 +0200
Message-ID: <20081008130959.174cc38a@hyperion.delvare>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
	<20081007011859.12701.8929.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:48458 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYJHLKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 07:10:14 -0400
In-Reply-To: <20081007011859.12701.8929.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi Darrick,

On Mon, 06 Oct 2008 18:18:59 -0700, Darrick J. Wong wrote:
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/ics932s401 |   31 ++
>  drivers/hwmon/Kconfig          |   10 +
>  drivers/hwmon/Makefile         |    1 
>  drivers/hwmon/ics932s401.c     |  516 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 558 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/ics932s401 b/Documentation/hwmon/ics932s401
> new file mode 100644
> index 0000000..c2e2c4a
> --- /dev/null
> +++ b/Documentation/hwmon/ics932s401
> @@ -0,0 +1,31 @@
> +Kernel driver ics932s401
> +======================
> +
> +Supported chips:
> +  * Analog Devices ICS932S401
> +    Prefix: 'ics932s401'
> +    Addresses scanned: I2C 0x69
> +    Datasheet: Publicly available at the Integrated Circuits website
> +
> +Author: Darrick J. Wong
> +
> +Description
> +-----------
> +
> +This driver implements support for the Integrated Circuits ICS932S401 chip family.
> +
> +This chip has 4 clock outputs--a base clock for the CPU (which is likely
> +multiplied to get the real CPU clock), a system clock, a PCI clock, a USB
> +clock, and a reference clock.  The driver reports selected and actual
> +frequency.  If spread spectrum mode is enabled, the driver also reports by what
> +percent the clock signal is being spread, which should be between 0 and -0.5%.
> +All frequencies are reported in KHz.
> +
> +The ICS932S401 monitors all inputs continuously. The driver will not read
> +the registers more often than once every other second.

I fail to see how this has anything to do with hardware monitoring.

-- 
Jean Delvare
