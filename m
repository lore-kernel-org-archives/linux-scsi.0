From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi: megaraid_sas: fix panic on loading firmware crashdump
Date: Tue, 23 Jul 2019 22:15:40 -0400
Message-ID: <yq1wog8qisz.fsf@oracle.com>
References: <20190722161524.23192-1-junxiao.bi@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190722161524.23192-1-junxiao.bi@oracle.com> (Junxiao Bi's
        message of "Mon, 22 Jul 2019 09:15:24 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org


Junxiao,

> While loading fw crashdump in function fw_crash_buffer_show(), left
> bytes in one dma chunk was not checked, if copying size over it,
> overflow access will cause kernel panic.

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
