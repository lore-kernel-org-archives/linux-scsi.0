From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patches] rq_dev removal
Date: Thu, 31 Oct 2002 17:57:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210312257.g9VMvQ706240@localhost.localdomain>
References: <viro@math.psu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA24570
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2002 14:57:28 -0800
In-Reply-To: Message from Alexander Viro <viro@math.psu.edu>
   of "Thu, 31 Oct 2002 17:43:19 EST." <Pine.GSO.4.21.0210311715330.16688-100000@weyl.math.psu.edu>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Viro <viro@math.psu.edu>
Cc: linux-scsi@vger.kernel.org

viro@math.psu.edu said:
> 	Please, review.  If somebody has objections - yell, otherwise this
> stuff goes to Linus tomorrow.  Interesting things are in the small
> patches - huge pair in the beginning of series is tape_name() stuff,
> i.e. purely mechanical work. 

To facilitate quick review, there's also a BK tree with this in at 

http://linux-scsi.bkbits.net/scsi-viro-2.5

NOTE: The patches in this tree will not be the official BK ones, so watch out 
for contaminating your own trees

James


