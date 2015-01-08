From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM ATTEND] discuss blk-mq related to
	DM-multipath and status of XCOPY
Date: Thu, 08 Jan 2015 09:39:10 -0500
Message-ID: <yq1vbkh2v75.fsf@sermon.lab.mkp.net>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
	<54AA90B1.1030201@suse.de> <yq17fwz8nwb.fsf@sermon.lab.mkp.net>
	<54ACEF13.7000508@suse.de> <yq1vbki40ua.fsf@sermon.lab.mkp.net>
	<54AE2436.2000004@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54AE2436.2000004@suse.de> (Hannes Reinecke's message of "Thu, 08
	Jan 2015 07:31:18 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> But the array might prioritize 'normal' I/O requests, and treat
Hannes> XCOPY with a lower priority. So given enough load XCOPY might
Hannes> actually be slower than a normal copy ...

Yes, but may have lower impact on concurrent I/O.

-- 
Martin K. Petersen	Oracle Linux Engineering
