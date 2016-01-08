From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] ipr: fix out-of-bounds null overwrite
Date: Thu, 07 Jan 2016 21:52:18 -0500
Message-ID: <yq1poxchjfh.fsf@sermon.lab.mkp.net>
References: <1452102241-4732-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452102241-4732-1-git-send-email-wuninsu@gmail.com> (Insu Yun's
	message of "Wed, 6 Jan 2016 12:44:01 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>
Cc: brking@us.ibm.com, JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu, Shane Seymour <shane.seymour@hpe.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Insu" == Insu Yun <wuninsu@gmail.com> writes:

Insu> Return value of snprintf is not bound by size value, 2nd argument.
Insu> (https://www.kernel.org/doc/htmldocs/kernel-api/API-snprintf.html).
Insu> Return value is number of printed chars, can be larger than 2nd
Insu> argument.  Therefore, it can write null byte out of bounds
Insu> ofbuffer.  Since snprintf puts null, it does not need to put
Insu> additional null byte.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
