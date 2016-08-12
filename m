From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Fri, 12 Aug 2016 17:17:22 -0400
Message-ID: <yq1d1ldn0v1.fsf@sermon.lab.mkp.net>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
	<10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
	<20160810041042.GH25053@mtj.duckdns.org>
	<CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
	<yq1twesq8lm.fsf@sermon.lab.mkp.net>
	<CAGnHSEn3pXR33Ju+mr0DYdE0G7kNhxNCbvocX1pZXvYfxx5+3A@mail.gmail.com>
	<yq1mvkipwx5.fsf@sermon.lab.mkp.net>
	<20160812101645.0a4a5e9f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160812101645.0a4a5e9f@lxorguk.ukuu.org.uk> (One Thousand
	Gnomes's message of "Fri, 12 Aug 2016 10:16:45 +0100")
Sender: linux-block-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Yan <tom.ty89@gmail.com>, Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Alan" == One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:

Alan,

Alan> For older SCSI and especially ATA drives (and it wouldn't surprise
Alan> me if it is true of modern ones) there are also huge latency
Alan> tradeoffs.

Absolutely.

Alan> Before you jump up and down about numbers what are the latency
Alan> numbers like on classic ATA drives with that sized block I/O. You
Alan> could easily up your RAID numbers while wrecking realtime and
Alan> desktop performance.

I was in no way advocating raising the default, quite the contrary.  We
have several customer workloads that got negatively impacted when the
limit was bumped.

My point was that arguing about what the default should be without any
data supporting the discussion is futile.

Alan> At the ATA level we can detect both the presence of command
Alan> queueing ability, and also whether the device is spinnning rust or
Alan> not, so it may be smarter defaults could be done based upon
Alan> whether the device is an SSD or not.

Sure.

However, modern SSDs actually trend towards smaller I/O sizes. NVMe is
128K by default, I think. So a higher default wouldn't make any
difference there.

-- 
Martin K. Petersen	Oracle Linux Engineering
