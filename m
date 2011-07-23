From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/8] ida: Simplified functions for id allocation.
Date: Sat, 23 Jul 2011 12:04:25 +0200
Message-ID: <20110723100425.GL21089@mtj.dyndns.org>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
 <1311352886-4047-11-git-send-email-jic23@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:33531 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1GWKEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 06:04:32 -0400
Content-Disposition: inline
In-Reply-To: <1311352886-4047-11-git-send-email-jic23@cam.ac.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie

On Fri, Jul 22, 2011 at 05:41:19PM +0100, Jonathan Cameron wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> The current hyper-optimized functions are overkill if you simply want
> to allocate an id for a device.  Create versions which use an internal
> lock.
> 
> Thanks to Tejun for feedback.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Yeap, still looks good to me.

Thank you.

-- 
tejun
