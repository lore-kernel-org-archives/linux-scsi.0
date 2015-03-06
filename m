From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] drivers: scsi: Remove null check on sdkp
Date: Fri, 06 Mar 2015 07:12:01 -0500
Message-ID: <yq11tl2e35a.fsf@sermon.lab.mkp.net>
References: <20150306023649.GA6316@kt-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150306023649.GA6316@kt-Inspiron-3542> (Tapasweni Pathak's
	message of "Fri, 6 Mar 2015 08:06:49 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Tapasweni Pathak <tapaswenipathak@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tapasweni" == Tapasweni Pathak <tapaswenipathak@gmail.com> writes:

Tapasweni> Remove null check on sdkp as it won't be null at this line.

Thanks for the heads up. It's actually a merge snafu. The check is
supposed to be if (!sdkp->ATO). I already have a patch in my queue to
fix this.

-- 
Martin K. Petersen	Oracle Linux Engineering
