From: Doug Ledford <dledford@redhat.com>
Subject: Re: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 17:24:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122222459.GC18664@redhat.com>
References: <20021122183603.GC16865@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id gAMMOxeh018898
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2002 17:24:59 -0500
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id gAMMOxOD018896
	for linux-scsi@vger.kernel.org; Fri, 22 Nov 2002 17:24:59 -0500
Content-Disposition: inline
In-Reply-To: <20021122183603.GC16865@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 22, 2002 at 01:36:03PM -0500, Doug Ledford wrote:
> Like last time, this has been through a full compile test, but not a boot 
> test.  I'm heading up to the office next so the boot test will come 
> shortly.

BTW, boot and run tests were successful.  No I'm trying to isolate why 
certain modules blow up when you load them, unload them, then reload them.  
Right now, the aic7xxx_old, sd_mod, and scsi_mod modules are working.  The 
st module is blowing chunks.  I haven't tried sr_mod yet.  I also haven't 
tried any other lldd modules yet.

Anyway, back to hacking st.c

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
