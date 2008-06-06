From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 6 Jun 2008 13:55:05 +0100
Message-ID: <20080606125505.GB19246@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605104042.GB20308@shareable.org> <20080605191935.GZ2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080605191935.GZ2961@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andreas Dilger wrote:
> > Is there scope to extend FIEMAP to pass this sort of information?
> 
> I have ideas in that direction, but have been gun-shy about presenting
> them until the existing controversy dies down...  I think it is actually
> fairly straight forward to enhance FIEMAP to allow arbitrary file layouts
> to be returned to an application.

>From the pipe2(), dup3() saga: just remember to include room for a
"flags" argument somewhere :-)

-- Jamie
