From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v13 8/9] libata: do not suspend port if normal ODD is
 attached
Date: Tue, 22 Jan 2013 19:27:46 +0800
Message-ID: <20130122112746.GA26380@aaronlu.sh.intel.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
 <1358241665-2156-9-git-send-email-aaron.lu@intel.com>
 <50FDA84F.8030204@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50FDA84F.8030204@pobox.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 21, 2013 at 03:42:55PM -0500, Jeff Garzik wrote:
> On 01/15/2013 04:21 AM, Aaron Lu wrote:
> >For ODDs, the upper layer will poll for media change every few
> >seconds, which will make it enter and leave suspend state very
> >often. And as each suspend will also cause a hard/soft reset,
> >the gain of runtime suspend is very little while the ODD may
> >malfunction after constantly being reset. So the idle callback
> >here will not proceed to suspend if a non-ZPODD capable ODD is
> >attached to the port.
> >
> >Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> >Acked-by: Tejun Heo <tj@kernel.org>
> >---
> >  drivers/ata/libata-core.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> 
> applied patches #2-6 and #8

Thanks!

Now that patch 1 has ack from Alan Stern(and thus James), and consider
the smatch warning of patch #3, I can either send out the remaining 3
patches(#1, #7 and #9) together with a small fix patch for the smatch
warning or I can re-send the whole patchset. Just let me know which way
you prefer, thanks.

-Aaron

