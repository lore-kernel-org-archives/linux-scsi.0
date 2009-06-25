From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 10:46:41 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0906251045450.3605@localhost.localdomain>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1k530qkm7.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On Thu, 25 Jun 2009, Martin K. Petersen wrote:
> 
> Neil> So I asked git why it as added, and it pointed to
> Neil>   commit 1308835ffffe6d61ad1f48c5c381c9cc47f683ec
> 
> Neil> which suggests that it was added so that user space could tell the
> Neil> kernel whether the device was rotational, rather than the other
> Neil> way around.
> 
> There's an option to do it via udev for broken devices that don't report
> it.  But both SCSI and ATA have a setting that gets queried and the
> queue flag set accordingly.

.. except few devices actually set it. 

That flag is _definitely_ all about the user being able to override it.

		Linus
