From: Doug Ledford <dledford@redhat.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Fri, 30 Aug 2002 14:58:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020830145811.H30927@redhat.com>
References: <patmans@us.ibm.com> <200208301646.g7UGk2c15401@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200208301646.g7UGk2c15401@localhost.localdomain>; from James.Bottomley@steeleye.com on Fri, Aug 30, 2002 at 11:46:02AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, zaitcev@redhat.com

On Fri, Aug 30, 2002 at 11:46:02AM -0500, James Bottomley wrote:
> What about, instead of Pete's patch, changing the GFP_ATOMIC to GFP_KERNEL and 
> adding a BUG_ON(in_interrupt()) at the top and see who sends back bug 
> reports...

Works for me.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
