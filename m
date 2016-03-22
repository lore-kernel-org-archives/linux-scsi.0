From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: fix missing { }, nullify kbuff_arr[i] only when necessary
Date: Mon, 21 Mar 2016 20:31:05 -0400
Message-ID: <yq1egb35p6e.fsf@sermon.lab.mkp.net>
References: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Sun, 20 Mar 2016 17:03:32 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, James Bottomley <jbottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> From: Colin Ian King <colin.king@canonical.com> Fix missing { }
Colin> on if statement, this change will nullify kbuff_arr[i] only where
Colin> necessary as the code intended.

Colin> detected using static analysis with smatch

Kashyap/Sumit: Please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
