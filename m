From: Eugene Teo <eteo@redhat.com>
Subject: Re: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world writeable
 permissions
Date: Thu, 03 Dec 2009 08:08:20 +0800
Message-ID: <4B170174.5030805@redhat.com>
References: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755749AbZLCAIj@vger.kernel.org>
In-Reply-To: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Dahlin <cdahlin@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Bryn M. Reeves" <bmr@redhat.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Yang Hongyang <yanghy@cn.fujitsu.com>, Anand Gadiyar <gadiyar@ti.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
