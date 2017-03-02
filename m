From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Avoid sleeping in interrupt context
Date: Wed, 01 Mar 2017 21:53:42 -0500
Message-ID: <yq1lgsoqthl.fsf@oracle.com>
References: <20170301170036.11540-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170301170036.11540-1-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Wed, 1 Mar 2017 09:00:36 -0800")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, "# v4 . 10+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Commit 669f044170d8 ("scsi: srp_transport: Move queuecommand()
Bart> wait code to SCSI core") can make scsi_internal_device_block()
Bart> sleep.  However, the mpt3sas driver can call this function from an
Bart> interrupt handler. Hence add a second argument to
Bart> scsi_internal_device_block() that restores the old behavior of
Bart> this function for the mpt3sas handler.

Applied to 4.11/scsi-fixes.

Thanks, Bart!

-- 
Martin K. Petersen	Oracle Linux Engineering
