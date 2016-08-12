From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Fri, 12 Aug 2016 18:15:30 -0400
Message-ID: <yq1wpjlljlp.fsf@sermon.lab.mkp.net>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
	<yq1r39upy7p.fsf@sermon.lab.mkp.net>
	<CAGnHSE=E1Bj99EciXrDS31n4Q4VcRL0sDJ2t4ynx0bHgp5RNtw@mail.gmail.com>
	<yq1lh01n1ul.fsf@sermon.lab.mkp.net>
	<CAJVOszDDC39ge6d3h+uy1wtxMBv95_V1eWofumya_G5zg21OrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAJVOszDDC39ge6d3h+uy1wtxMBv95_V1eWofumya_G5zg21OrQ@mail.gmail.com>
	(Shaun Tancheff's message of "Fri, 12 Aug 2016 16:49:06 -0500")
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Yan <tom.ty89@gmail.com>, Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Shaun" == Shaun Tancheff <shaun.tancheff@seagate.com> writes:

Shaun,

Shaun> Ah, I think I am understanding now. When the sector size is 4K
Shaun> the minimum page sent with WRITE SAME will be 4K.

Correct. We'll always transfer one logical block of data as required by
the spec.

-- 
Martin K. Petersen	Oracle Linux Engineering
