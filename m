From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Mon, 21 Jan 2013 15:56:43 +0100
Message-ID: <1671780.QshOn4REzF@linux-5eaq.site>
References: <50FA5F67.4080102@intel.com> <CAGRGNgWc2QTnY==NdMeZpw-7L3WwQfBFOwm=UZZ3Jcz+dp=h3g@mail.gmail.com> <20130121091104.GA11010@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20130121091104.GA11010@aaronlu.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Julian Calaby <julian.calaby@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 21 January 2013 17:11:04 Aaron Lu wrote:
> It is not easy for the OS to tell if the drive is being used or not
> sometimes 
> 
> Alan has reminded me it is possible for an app to open the block device
> file(/dev/sr0), issue a command(play audio), then close the device file.
> From the OS' point of view, we think nobody is using it. But actually,
> the drive is playing cd for the user, so we can't suspend the device.

Are there drives that support ZPODD and have an audio output?

	Regards
		Oliver

