From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v2 1/4] scsi: introduce sync_before_stop flag
Date: Tue, 18 Sep 2012 09:30:11 +0200
Message-ID: <1676757.rqQnA7IDdg@linux-lqwf.site>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com> <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 18 September 2012 15:00:28 Aaron Lu wrote:
> When scsi device received stop command, it will take care of its
> internal cache before enters stopped power condition. This command is
> translated to standby immediate in libata-scsi, but standby doesn't
> imply flush cache for ATA device, so to issue stop command to ATA
> device, an additional flush cache has to be issued.

Why not just set WCE?

	Regards
		Oliver

