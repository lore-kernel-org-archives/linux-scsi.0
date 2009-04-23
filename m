From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 09:16:05 -0400
Message-ID: <yq1r5zjbje2.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	<d14109aa6209be628074.1240464572@sermon.lab.mkp.net>
	<20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org>
	<20090423113841.GK1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090423113841.GK1926@parisc-linux.org> (Matthew Wilcox's
	message of "Thu, 23 Apr 2009 05:38:41 -0600")
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> I already did that.  The only problem is that you made me
Matthew> include the stupid:

Matthew>         if (ata_id_major_version(args->id) > 7) {

Matthew> so of course it doesn't work on any existing hardware.  How
Matthew> about applying this patch:

Maybe we could incubate your patch in the next tree for a bit and see
what breaks without the version check?

We could even be somewhat conservative like we were with RC16 in SCSI.
The SATA devices I have here with valid rotational flags all report
version 7.  I wonder if > 6 do the trick?

-- 
Martin K. Petersen	Oracle Linux Engineering
