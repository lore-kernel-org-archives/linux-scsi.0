From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
Date: Thu, 18 Aug 2011 14:58:53 +0200
Message-ID: <20110818145853.7bf4ae3e@stein>
References: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40918 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab1HRM74 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2011 08:59:56 -0400
In-Reply-To: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Aug 17 Stephen M. Cameron wrote:
> +What:           /sys/class/scsi_device/..../device/type
> +Date:           December, 2002
> +KernelVersion:  Unknown
> +Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +		This read only decimal integer value indicates the
> +		SCSI device type.
> +
> +What:           /sys/class/scsi_device/..../device/scsi_level
> +Date:           January, 2003
> +KernelVersion:  Unknown
> +Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
> +Description:
> +		This read only decimal integer value indicates the
> +		SCSI revision level the device claims to support.

Perhaps a reference to the pertaining SCSI specifications would be good
to have at these two attribute descriptions.  (I am too lazy to look those
up right now though.)
-- 
Stefan Richter
-=====-==-== =--- =--=-
http://arcgraph.de/sr/
