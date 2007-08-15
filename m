From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 2/4] scsi: expose AN support to user space
Date: Wed, 15 Aug 2007 09:01:49 -0500
Message-ID: <1187186509.3327.7.camel@localhost.localdomain>
References: <20070808190613.616085010@localhost.localdomain>
	 <20070808120822.9cf187bb.kristen.c.accardi@intel.com>
	 <46C2B59A.6070200@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46C2B59A.6070200@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-08-15 at 04:13 -0400, Jeff Garzik wrote:
> Kristen Carlson Accardi wrote:
> > If a scsi_device supports async notification for media change, then
> > let user space know this capability exists by creating a new sysfs
> > entry "media_change_notify", which will be 1 if it is supported, and
> > 0 if not supported.  Create a routine which allows scsi devices to
> > send a uevent when media change events occur.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> if James is happy with this patch, I'm happy with patch #2 and #3

Actually, we just got a second potential consumer ... although I'll
reprod to have the reporter send it to the list.  It's a device that
needs notice of report luns data changing.  The proposed mechanism looks
a bit narrow now (too tied to media change).  I'll see if I can propose
a more generic update.

James


