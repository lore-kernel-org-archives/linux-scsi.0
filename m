From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (v2) -
 resend
Date: Mon, 7 May 2007 08:20:56 -0700
Message-ID: <20070507082056.dd0b2f9e.kristen.c.accardi@intel.com>
References: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
	<463DAAC6.3060300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <463DAAC6.3060300@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 06 May 2007 12:15:34 +0200
Tejun Heo <htejun@gmail.com> wrote:

> Kristen Carlson Accardi wrote:
> > This patch series implements Asynchronous Notification (AN) for SATA
> > ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> > which support this feature will send a notification when new media is
> > inserted and removed, preventing the need for user space to poll for
> > new media.  This support is exposed to user space via a flag that will
> > be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> > space can disable polling for the new media, and the genhd driver will
> > send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> > 
> > Note that this patch only implements support for directly attached
> > drives - AN with drives attached to a port multiplier requires 
> > additional changes.
> 
> No objection from me.  BTW, you're not setting ATA_FLAG_AN anywhere in
> the patch series, will that be a separate patch?
> 
> -- 
> tejun
> 

Yes - unfortunately I realized I'd forgotten to add that file to my
quilt patch about 5 minutes after I sent it :).  I thought if there were
no other revisions to this patch, I'd just send a separate one, otherwise
I'd incorporate it into the next version.
