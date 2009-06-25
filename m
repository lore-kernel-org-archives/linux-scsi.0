From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 13:43:23 -0400
Message-ID: <yq1fxdoqkec.fsf@sermon.lab.mkp.net>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<4A43612F.2000100@anonymous.org.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A43612F.2000100@anonymous.org.uk> (John Robinson's message of
	"Thu, 25 Jun 2009 12:36:15 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Robinson <john.robinson@anonymous.org.uk> writes:

John> Even sadder, when a raid 0/4/5/6 is reshaped over more discs (and
John> probably other scenarios outwith md),

I'm not sure I agree with the whole "sad" sentiment.  Just because
ext[234] doesn't query devices automatically doesn't mean the technology
doesn't exist.  I wrote the MD/LVM extraction code for XFS in 2001.


John> both stripe-width and stride-size change. Is there any prospect
John> this new stacking could give us the opportunity to tell our client
John> (LVM, filesystem, whatever) about the change, or that they'll be
John> able to take advantage of it?

When you resize the fs it would have to compare the new topology to the
old one and adjust accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
