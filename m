From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] add request prep functions to SCSI
Date: Wed, 6 Nov 2002 18:16:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106231645.GK22177@redhat.com>
References: <200211062218.gA6MI2t04813@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211062218.gA6MI2t04813@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 05:18:02PM -0500, J.E.J. Bottomley wrote:
> This patch adds request prep functions to the mid-layer.  At the moment, its a single request prep function for all of SCSI.  I've altered the logic in scsi_request_fn so that we now do early preparation (this should improve throughput slightly in the untagged case with only a single command block).
> 

Hmmm...the current pace of scsi patches is starting to get hard to keep up 
with.  Do we have a unified bk tree with all the patches we want Linus to 
apply in it as of yet?  I know a lot of stuff has come through just in the 
last day and I'm starting to see a lot of areas where there is going to be 
conflict between patches going forward.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
