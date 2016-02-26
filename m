From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] osd: remove deadcode
Date: Thu, 25 Feb 2016 21:12:29 -0500
Message-ID: <yq1k2lsgqya.fsf@sermon.lab.mkp.net>
References: <1456312888-22074-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456312888-22074-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Wed, 24 Feb 2016 16:51:28 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> The variable is_ver1 is always true and so OSD_CAP_LEN can never
Sudip> be used.  Reported by Coverity.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
