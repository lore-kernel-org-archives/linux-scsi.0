From: Doug Ledford <dledford@redhat.com>
Subject: Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 18:08:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020617180818.C30391@redhat.com>
References: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020615133606.GC11016@gum01m.etpnet.phys.tue.nl>; from garloff@suse.de on Sat, Jun 15, 2002 at 03:36:06PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, Jun 15, 2002 at 03:36:06PM +0200, Kurt Garloff wrote:
> Hi SCSI users,
> 
> from people using SCSI devices, there's one question that turns up again 
> and again: How can one assign stable device names to SCSI devices in
> case there are devices that may or may not be switched on or connected.


> Life would be easier if the scsi subsystem would just report which SCSI
> device (uniquely identified by the controller,bus,target,unit tuple) belongs
> to which high-level device. The information is available in the kernel.

Umm, this patently fails to meet the criteria you posted of "stable device 
name".  Adding a controller to a system is just as likely to blow this 
naming scheme to hell as it is to blow the traditional linux /dev/sd? 
scheme.  IOW, even though the /proc/scsi/map file looks nice and usefull, 
it fails to solve the very problem you are trying to solve.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
