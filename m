From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: When must the io_request_lock be held?
Date: Wed, 7 Aug 2002 09:55:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807095532.A12951@eng2.beaverton.ibm.com>
References: <dledford@redhat.com> <200208071526.g77FQOt03034@localhost.localdomain> <20020807121846.F10872@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020807121846.F10872@redhat.com>; from dledford@redhat.com on Wed, Aug 07, 2002 at 12:18:46PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, linux-scsi@vger.kernel.org

On Wed, Aug 07, 2002 at 12:18:46PM -0400, Doug Ledford wrote:

> Again, if Marcello takes my patch, this will become easier as well since 
> it adds a host->lock lock that allows you to get your driver off the 
> horrible io_request_lock once and for all.  (Note: I may have to change 
> the name to host->host_lock to make it match 2.5, but that just annoys the 
> hell out of me because I *detest* totally redundant names like that...)

Such code looks a bit odd, but I would rather have it and be able to
more easily find or audit all the references; using cscope, there
are about 6700 references to lock in the 2.5 kernel (only looking at
i386 sources, so there are probably more), and about 300 references to
host_lock.

-- Patrick Mansfield
