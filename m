From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: document generic scsi host sysfs attributes
Date: Thu, 18 Aug 2011 14:55:59 +0200
Message-ID: <20110818145559.37cd9e67@stein>
References: <20110817182047.8821.55211.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110817182047.8821.55211.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Aug 17 Stephen M. Cameron wrote:
> What:		/sys/bus/scsi/devices/host*/scsi_host/host*/unchecked_isa_dma
> +Date:		February, 2003
> +KernelVersion:	Unknown
> +Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +
> +What:		/sys/bus/scsi/devices/host*/scsi_host/host*/proc_name
> +Date:		March, 2004
> +KernelVersion:	Unknown
> +Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +
> +What:		/sys/bus/scsi/devices/host*/scsi_host/host*/scan
> +Date:		August, 2003
> +KernelVersion:	Unknown
> +Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +		Read only integer which indicates whether the host is an
> +		ancient ISA device which therefore requires extra bounce
> +		buffering.

The last description obviously belongs to unchecked_isa_dma.

scan is a write-only attribute that may or may not initiate a bus rescan,
I suppose.

proc_name is the "name of proc directory" of a driver, if the driver
maintained one; though it seems all drivers provide proc_name
independently of the obsolete proc interface for driver data.
-- 
Stefan Richter
-=====-==-== =--- =--=-
http://arcgraph.de/sr/
