From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 13:58:40 -0800
Message-ID: <20121118215840.GB25790@mtj.dyndns.org>
References: <20121118150555.GL7306@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1211181221350.4991-100000@netrider.rowland.org>
 <20121118215657.GA25790@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121118215657.GA25790@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 18, 2012 at 01:56:57PM -0800, Tejun Heo wrote:
> I think the only reason autopm doesn't blow up for SATA devices is
> that userland usually automatically mounts them thus effectively
> disabling autopm.  I *think* the only sane thing we can do is doing
> autopm iff zpodd is available && no media.

That is, at least for devices which get polled.  If devices are to
leave unused for some time, suspending is fine but auto-suspending
inbetween event polling wouldn't work.

Thanks.

-- 
tejun
