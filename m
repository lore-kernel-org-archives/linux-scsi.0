From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH 01/12] hwmon: Define sysfs interface for
 energy  consumption register.
Date: Wed, 8 Oct 2008 10:09:57 +0200
Message-ID: <20081008100957.258d1e80@hyperion.delvare>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
	<20081007011829.12701.29034.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:23040 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYJHIKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 04:10:22 -0400
In-Reply-To: <20081007011829.12701.29034.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi Darrick,

On Mon, 06 Oct 2008 18:18:29 -0700, Darrick J. Wong wrote:
> 
> Describe the sysfs files that were introduced in the ibmaem driver.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/sysfs-interface |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index 2d84573..6d47cb2 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -321,6 +321,14 @@ curr[1-*]_input	Current input value
>  		Unit: milliampere
>  		RO
>  
> +**********
> +* Energy *
> +**********
> +
> +energy[1-*]_input		Cumulative energy use
> +				Unit: microJoule
> +				RO
> +
>  *********
>  * Power *
>  *********
> @@ -329,6 +337,10 @@ power[1-*]_average		Average power use
>  				Unit: microWatt
>  				RO
>  
> +power[1-*]_average_interval	Power use averaging interval
> +				Unit: milliseconds
> +				RW
> +
>  power[1-*]_average_highest	Historical average maximum power use
>  				Unit: microWatt
>  				RO
> 
> 

I'm taking this in my tree, thanks (with a minor change: moving Energy
after Power for consistency.)

-- 
Jean Delvare
