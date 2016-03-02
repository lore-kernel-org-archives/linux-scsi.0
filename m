From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qlogicpti: Return correct error code
Date: Tue, 01 Mar 2016 20:08:13 -0500
Message-ID: <yq1twkpbsaq.fsf@sermon.lab.mkp.net>
References: <20160217133254.GA31334@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160217133254.GA31334@amitoj-Inspiron-3542> (Amitoj Kaur
	Chawla's message of "Wed, 17 Feb 2016 19:02:54 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr, Shane M Seymour <shane.seymour@hpe.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Amitoj" == Amitoj Kaur Chawla <amitoj1606@gmail.com> writes:

Amitoj> The return value of of_ioremap on failure should be -ENODEV and
Amitoj> not -1.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
