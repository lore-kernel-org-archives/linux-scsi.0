From: Doug Ledford <dledford@redhat.com>
Subject: Re: 2.5.43 scsi _eh_ buslogic
Date: Mon, 21 Oct 2002 12:23:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021162321.GC28914@redhat.com>
References: <Pine.LNX.4.30.0210181201060.29276-100000@tosko.alm.com> <20021018224311.GB1066@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021018224311.GB1066@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: andy barlak <andyb@island.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Oct 18, 2002 at 03:43:12PM -0700, Mike Anderson wrote:
> Andy,
> 	From looking at the driver it looks like the locking had been
> update to 2.5, but that the driver error handling has not been updated.
> scsi_obsolete.c has not existed in the 2.5 view for a while.

Actually, I sent a patch to Linus for this driver that I think made it 
into 2.5.44.  Andy, could you let me know if 2.5.44 works?  If not, then 
I'll see what I can find.  Side note: Mike's right about the error 
handling being horked, but that shouldn't really make any difference in 
bootup since it shouldn't be needing error recovery.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
