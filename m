From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] snic: correctly check for array overrun on overly long version number
Date: Tue, 01 Mar 2016 20:09:44 -0500
Message-ID: <yq1povdbs87.fsf@sermon.lab.mkp.net>
References: <1456441105-19042-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456441105-19042-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Thu, 25 Feb 2016 22:58:25 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> The snic version number is expected to be 4 decimals in the form
Colin> like a netmask string with each number stored in an element in
Colin> array v.  However, there is an off-by-one check on the number of
Colin> elements in v allowing one to pass a 5 decimal version number
Colin> causing v[4] to be referenced, causing a buffer overrun.  Fix the
Colin> off-by-one error by comparing to i > 3 rather than 4.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
