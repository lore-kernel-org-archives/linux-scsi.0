From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3.4.106] SCSI: libsas: no expander revalidation for
 SAS_END_DEV
Date: Thu, 05 Mar 2015 16:07:08 -0800
Message-ID: <1425600428.2169.54.camel@HansenPartnership.com>
References: <3e3458d5d8c64018bd4b16bd2128403f@EX01.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34935 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbbCFAHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 19:07:10 -0500
In-Reply-To: <3e3458d5d8c64018bd4b16bd2128403f@EX01.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>

On Thu, 2015-03-05 at 18:57 +0000, Praveen Murali wrote:
> The kernel crashed in mutex_lock called from smp_execute_task. The reason
> is that the mutex is initialized only for devices with type EDGE_DEV or
> FANOUT_DEV, but in some cases smp_execute_task gets called in the expander
> revalidation context for end devices too. Expander revalidation should not
> be performed for non-expander devices since they are discovered via their
> IDENTIFY frames and probing for expander capabilities is not required.
> 
> Signed-off-by: Praveen Murali <pmurali@logicube.com>

Heh, well, I know I'm known to drop patches (including my own) from time
to time, but give me some time before resending them. However, when you
do it needs a From: at the top with the correct authorship and a signoff
chain (which I made difficult by not putting a signoff on the original
test patch, I grant).  We'd also usually add reported-by and tested-by
in this instance, too.

Thanks,

James


