From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Fri, 7 Sep 2012 11:41:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209071138370.1674-100000@iolanthe.rowland.org>
References: <504A0A4E.9040801@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <504A0A4E.9040801@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Oliver Neukum <oneukum@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 7 Sep 2012, Aaron Lu wrote:

> > What I'd really like is a way to do the status polling without having
> > it reset the idle timer.
> 
> I like this, I'll try to see if this can be done.
> 
> If we idle the device immediately, we would suspend/resume the ODD every
> 2 seconds, which may not be a good idea.

It may be okay.  This depends on how long it takes to suspend and
resume the drive and its parents.  If it takes no more than a few
hundred ms then there shouldn't be any problem.  Especially if the 
polling interval is increased to something like 5 seconds.

Alan Stern

