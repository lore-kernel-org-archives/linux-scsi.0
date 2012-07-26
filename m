From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Date: Thu, 26 Jul 2012 12:44:24 +0200
Message-ID: <1476441.ovA4GKBza3@linux-lqwf.site>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com> <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 26 July 2012 18:05:24 Aaron Lu wrote:
> If the device is using autosuspend, when scsi_autopm_put_device is
> called for it, use autosuspend runtime pm calls instead of the sync
> call.

What is the purpose of this approach?
You need a very good reason to have an API do two different things
based on this.

	Regards
		Oliver
