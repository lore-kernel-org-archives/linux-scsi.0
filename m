From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] ses: Fix racy cleanup of /sys in remove_dev()
Date: Fri, 12 Aug 2016 10:45:05 -0700
Message-ID: <1471023905.2407.42.camel@linux.vnet.ibm.com>
References: <4912ec551a8ec01181cc3e7ad1e01d3d36758810.1463170976.git.calvinowens@fb.com>
	 <5750B821.7010600@fb.com>
	 <20160615202416.GA52103@calvinowens-mba.dhcp.thefacebook.com>
	 <617c5fc1-ecc5-c825-ecb9-eeae2b637dfd@fb.com>
	 <yq1popx2q5t.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1popx2q5t.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Calvin Owens <calvinowens@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-07-28 at 21:23 -0400, Martin K. Petersen wrote:
> > > > > > "Calvin" == Calvin Owens <calvinowens@fb.com> writes:
> 
> > > Any thoughts? Squinting at this more it still seems racy, but a
> > > narrow race is surely better than just blatantly freeing
> > > everything
> > > while the file is still exposed in /sys? Is there a better way
> > > you'd
> > > prefer I accomplish this?
> > > 
> > > (I have boxes that OOPS all the time from monitoring code reading
> > > the
> > > /sys files, with this patch I haven't seen a single one.)
> 
> Calvin> Ping? Thoughts, comments?
> 
> James: This is your puppy...

I thought it would be bigger by now going by the early paw size
indicator ...

Anyway

Reviewed-by: James Bottomley <jejb@linux.vnet.ibm.com>

James
