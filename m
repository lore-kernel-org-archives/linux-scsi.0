From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world
 writeable permissions
Date: Thu, 3 Dec 2009 08:01:16 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B78D7030@cosmail02.lsi.com>
References: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>,<4B170174.5030805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51475 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125AbZLCPCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2009 10:02:24 -0500
In-Reply-To: <4B170174.5030805@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eugene Teo <eteo@redhat.com>, Casey Dahlin <cdahlin@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Bryn M. Reeves" <bmr@redhat.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Yang Hongyang <yanghy@cn.fujitsu.com>, Anand Gadiyar <gadiyar@ti.com>, Jiri Kosina <jkosina@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

How do you turn on poll_mode_io?

Thanks,

Bo Yang

________________________________________
From: Eugene Teo [eteo@redhat.com]
Sent: Wednesday, December 02, 2009 7:08 PM
To: Casey Dahlin
Cc: linux-kernel@vger.kernel.org; Bryn M. Reeves; DL-MegaRAID Linux; James E.J. Bottomley; Andrew Morton; Yang Hongyang; Anand Gadiyar; Jiri Kosina; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world writeable permissions

On 12/02/2009 11:17 PM, Casey Dahlin wrote:
> From: Bryn M. Reeves<bmr@redhat.com>
>
> /sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
> world-writable, which seems bad (letting any user affect kernel driver
> behavior).
>
> This turns off group and user write permissions, so that on typical
> production systems only root can write to it.
>
> Signed-off-by: Bryn M. Reeves<bmr@redhat.com>
> Signed-off-by: Casey Dahlin<cdahlin@redhat.com>

CC: Eugene Teo <eteo@redhat.com>

The subject should read: megaraid_sas: remove poll_mode_io world
writeable permissions instead, and this has been assigned with
CVE-2009-3939.

Thanks, Eugene
--
Eugene Teo / Red Hat Security Response Team