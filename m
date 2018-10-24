From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/11] Zoned block device support
	improvements
Date: Wed, 24 Oct 2018 11:37:53 -0400
Message-ID: <yq1zhv3e4oe.fsf@oracle.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<78778e22-9c5e-99d0-ef5c-85e04d03a4b7@kernel.dk>
	<yq1o9bkf5av.fsf@oracle.com> <20181024150344.GB13487@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181024150344.GB13487@redhat.com> (Mike Snitzer's message of
	"Wed, 24 Oct 2018 11:03:44 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Mike,

>> You keep mentioning this, but I don't recall ever seeing anything to
>> that effect. The rest of the kernel appears to be either arbitrary
>> ordering or favoring author SoB as the first tag.
>
> I've always felt the proper order is how Jens likes it too (all dm
> commits from me follow that order).

That's fine, I don't have any particular preference. And I don't have
any issue with you guys sticking to a certain ordering in your
respective subsystems. I occasionally shuffle tags when I commit things
in SCSI too.

I just think it should be properly documented if there is a preferred
way to order things...

-- 
Martin K. Petersen	Oracle Linux Engineering
