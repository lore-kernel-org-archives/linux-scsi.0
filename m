From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 10/18] scsi_dh_hp_sw: switch to
	scsi_execute_req_flags()
Date: Wed, 25 Jan 2017 22:20:29 -0500
Message-ID: <yq1sho68q2q.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485365126-23210-11-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Wed, 25 Jan 2017 18:25:18 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> From: Hannes Reinecke <hare@suse.de> Switch to
Christoph> scsi_execute_req_flags() instead of using the block interface
Christoph> directly.  This will set REQ_QUIET and REQ_PREEMPT, but this
Christoph> is okay as we're evaluating the errors anyway and should be
Christoph> able to send the command even if the device is quiesced.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
