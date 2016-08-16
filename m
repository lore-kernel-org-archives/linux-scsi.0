From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] sd: check BLK_DEF_MAX_SECTORS against max_dev_sectors
Date: Tue, 16 Aug 2016 00:10:15 -0400
Message-ID: <yq1d1l9l5g8.fsf@sermon.lab.mkp.net>
References: <60518e90d462d4cbb1c528914eac64e2fe124717.1471011949.git.tom.ty89@gmail.com>
	<974f3a0aa9e82caf067353fd7d7119c07d7e98c1.1471011949.git.tom.ty89@gmail.com>
	<yq11t1tmzxb.fsf@sermon.lab.mkp.net>
	<CAGnHSE=yBrBCbyKMNKBpZHRX7YKR-TV-s5YybvTKW18_gcrAbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGnHSE=yBrBCbyKMNKBpZHRX7YKR-TV-s5YybvTKW18_gcrAbw@mail.gmail.com>
	(Tom Yan's message of "Sun, 14 Aug 2016 17:00:52 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

>> It would be pretty unusual for a device that is smart enough to
>> report a transfer length limit to be constrained to 1 MB and change.

Tom> Well, it is done pretty much for libata's SATL.

But why?

>> rw_max = min(BLK_DEF_MAX_SECTORS, q->limits.max_dev_sectors);

Tom> That won't really work. min_t() would, though the line is gonna be
Tom> a bit long; not sure if I can/should simply cast the type (unsigned
Tom> int) to BLK_DEF_MAX_SECTORS. And which braces are you referring to?

I'd rather have a split line than double lines with braces.

-- 
Martin K. Petersen	Oracle Linux Engineering
