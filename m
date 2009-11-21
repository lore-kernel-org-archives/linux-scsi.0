From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Thin provisioning fixes
Date: Sat, 21 Nov 2009 01:55:21 -0500
Message-ID: <yq1aaygs6xy.fsf@sermon.lab.mkp.net>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>
	<4B077312.3050501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B077312.3050501@redhat.com> (Eric Sandeen's message of "Fri, 20
	Nov 2009 22:56:50 -0600")
Sender: linux-ide-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

Eric> Doing a test on an OCZ ssd, by patterning 16GB and then discarding
Eric> it via a single ioctl call, ends in an unhappy drive:

Nothing to see here, move along.  It was a bug in my userland
instrumentation and not in ata_set_lba_range_entries().  Sorry, Matthew.

So just drop this last patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
