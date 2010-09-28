From: Ted Ts'o <tytso@mit.edu>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 16:57:41 -0400
Message-ID: <20100928205741.GA22257@thunk.org>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <4CA0CC38.5010804@fusionio.com>
 <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
 <4CA118FF.1080100@fusionio.com>
 <yq18w2mddav.fsf@sermon.lab.mkp.net>
 <20100927231551.GA15653@redhat.com>
 <4CA16F6A.1090904@fusionio.com>
 <4CA17B13.7080801@redhat.com>
 <20100928141545.GA21587@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100928141545.GA21587@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2010 at 10:15:45AM -0400, Mike Snitzer wrote:
> Actually, -F allows one to override fs blocksize < physical_block_size.
> 
> In this instance we have the following:
> # cat /sys/block/dm-2/queue/physical_block_size 
> 1048576
> # cat /sys/block/dm-2/queue/logical_block_size 
> 512
>  
> > Should we change something?
> 
> Unclear.  I could see maybe automatically capping the fs block size at
> 4096 if physical_block_size is larger and is a multiple of 4096?

Can we decide soon what the right thing should be?  I'm about to
release e2fsrogs 1.41.13, and if I should put in some sanity checking
code so mke2fs does something sane when it sees a 1M physical block
size, I can do that.

Or if the kernel is going to do that, it's fine too....

      	  	    	     	      	   - Ted
