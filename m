From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] aic7xxx: fix firmware build with O=path
Date: Tue, 18 Jul 2017 18:52:39 -0700
Message-ID: <20170718185239.2179cdb6@cakuba.netronome.com>
References: <20170629041716.26865-1-jakub.kicinski@netronome.com>
        <20170718183536.35e00175@cakuba.netronome.com>
        <yq1wp75b3n6.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1wp75b3n6.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, oss-drivers@netronome.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 18 Jul 2017 21:45:49 -0400, Martin K. Petersen wrote:
> Jakub,
> 
> > I just noticed this patch got marked as "Deferred, archived" in
> > patchwork.  I'm not entirely sure by whom and why?  Could someone
> > explain what is the issue?  I would really appreciate if we could 
> > merge this patch and have this driver not break builds randomly...  
> 
> It's an indication that the patch sat around without any reviews for way
> too long.
> 
> People generally don't go chasing around in their mail archives for
> several week old patches to review. The best thing to do for patches I
> mark as deferred is to resubmit them so they get back on people's radar.

OK, I will repost then.  Thanks for the explanation!  I hope someone
will find time to review, the driver is a bit old :)
