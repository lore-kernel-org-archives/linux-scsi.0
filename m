From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 10:51:09 -0500
Message-ID: <yq1y6zva61e.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	<20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com>
	<20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>
	<20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com>
	<49145E0C.4030705@hp.com>
	<Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26>
	<49146031.70003@hp.com> <20081107154655.GH9543@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081107154655.GH9543@mit.edu> (Theodore Tso's message of "Fri\, 7 Nov 2008 10\:46\:55 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: jim owens <jowens@hp.com>, David Woodhouse <dwmw2@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ted" == Theodore Tso <tytso@mit.edu> writes:

Ted> How much of a disk wear factor is there with modern disk drives?
Ted> The heads aren't touching the disk, and we have plenty of sectors
Ted> which are constantly getting rewritten with traditional
Ted> filesystems, with no ill effects as far as I know.

Modern disk firmware maintains a list of write hot spots and will
regularly rewrite adjacent sectors to prevent bleed.

-- 
Martin K. Petersen	Oracle Linux Engineering
