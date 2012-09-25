From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Tue, 25 Sep 2012 22:20:21 +0800
Message-ID: <20120925142020.GA3653@mint-spring.sh.intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
 <201209242340.18318.rjw@sisk.pl>
 <20120925080133.GA1629@mint-spring.sh.intel.com>
 <201209251347.52407.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2IYOUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 10:20:25 -0400
Content-Disposition: inline
In-Reply-To: <201209251347.52407.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Tue, Sep 25, 2012 at 01:47:52PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 25, 2012, Aaron Lu wrote:
> > I'm thinking of enabling this GPE in sr_suspend once we decided that it
> > is ready to be powered off, so the time frame between sr_suspend and
> > when the power is actually removed in libata should be taken care of by
> > the GPE. If GPE fires, the notification function will request a runtime
> > resume of the device. Does this sound OK?
> 
> Well, depending on the implementation.  sr_suspend() should be rather
> generic, but the ACPI association (including the GPE thing) is specific to ATA.

Sorry, but don't quite understand this.

We have ACPI bindings for scsi devices, isn't that for us to use ACPI
when needed in scsi?

BTW, if sr_suspend should be generic, that would suggest I shouldn't
write any ZPODD related code there, right? Any suggestion where these
code should go then?

Thanks,
Aaron

