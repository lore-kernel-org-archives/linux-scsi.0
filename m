From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2/4] scsi: expose AN support to user space
Date: Wed, 15 Aug 2007 04:13:14 -0400
Message-ID: <46C2B59A.6070200@garzik.org>
References: <20070808190613.616085010@localhost.localdomain> <20070808120822.9cf187bb.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070808120822.9cf187bb.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> If a scsi_device supports async notification for media change, then
> let user space know this capability exists by creating a new sysfs
> entry "media_change_notify", which will be 1 if it is supported, and
> 0 if not supported.  Create a routine which allows scsi devices to
> send a uevent when media change events occur.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

if James is happy with this patch, I'm happy with patch #2 and #3


