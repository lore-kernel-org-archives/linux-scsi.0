From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v13 1/9] scsi: sr: support runtime pm
Date: Wed, 16 Jan 2013 15:45:48 +0000
Message-ID: <1358351148.2384.34.camel@dabdike.int.hansenpartnership.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
	 <1358241665-2156-2-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1358241665-2156-2-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-01-15 at 17:20 +0800, Aaron Lu wrote:
> This patch adds runtime pm support for sr.
> 
> It did this by increasing the runtime usage_count of the device when:
> - its block device is opened;
> - the events checking is to run.
> 
> And decreasing the runtime usage_count of the device when:
> - its block device is closed;
> - After the events checking is done.
> 
> The idea is discussed in this mail thread:
> http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

I'd like an ack from Alan Stern as well, please, but with that, you can
add my acked-by.

James


