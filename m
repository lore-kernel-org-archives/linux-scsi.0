From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 05/10] libata: separate ATAPI code
Date: Tue, 13 Nov 2012 20:49:24 +0800
Message-ID: <20121113124923.GA11672@aaronlu.sh.intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-6-git-send-email-aaron.lu@intel.com>
 <20121112185710.GD5560@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121112185710.GD5560@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2012 at 10:57:10AM -0800, Tejun Heo wrote:
> On Fri, Nov 09, 2012 at 02:51:57PM +0800, Aaron Lu wrote:
> > The atapi_eh_tur and atapi_eh_request_sense can be reused by ZPODD
> > code, so separate them out to a file named libata-atapi.c, and the
> > Makefile is modified accordingly. No functional changes should result
> > from this commit.
> 
> Why is this change necessary?  This doesn't seem to help anything to
> me.

Function zpready introduced in patch 6 used these 2 functions to see if
an ODD is in a zero power ready state.

Thanks,
Aaron

> 
> Thanks.
> 
> -- 
> tejun
