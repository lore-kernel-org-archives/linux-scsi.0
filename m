From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v14 1/3] scsi: sr: support runtime pm
Date: Mon, 28 Jan 2013 09:36:14 +0800
Message-ID: <20130128013614.GA26742@aaronlu.sh.intel.com>
References: <1358924973-18269-1-git-send-email-aaron.lu@intel.com>
 <1358924973-18269-2-git-send-email-aaron.lu@intel.com>
 <5102ED08.2070201@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5102ED08.2070201@pobox.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 25, 2013 at 03:37:28PM -0500, Jeff Garzik wrote:
> On 01/23/2013 02:09 AM, Aaron Lu wrote:
> >This patch adds runtime pm support for sr.
> >
> >It did this by increasing the runtime usage_count of the device when
> >its block device is accessed. And decreasing the runtime usage_count
> >of the device when the access is done.
> >
> >If there is media inside, runtime suspend is not allowed as we don't
> >always know if the ODD is being used or not.
> >
> >The idea is discussed here:
> >http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703
> >and the restriction to check media inside is discussed here:
> >http://thread.gmane.org/gmane.linux.ide/53665/focus=58836
> >
> >Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> >Acked-by: Alan Stern <stern@rowland.harvard.edu>
> >Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >---
> >  drivers/scsi/sr.c | 42 +++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> applied 1-3

Now that the whole patchset is queued, I would like to thank all of you,
especially Alan Stern and Tejun Heo, for your kind help, without that I
would not be able to make it.

Thanks and best regards,
Aaron

