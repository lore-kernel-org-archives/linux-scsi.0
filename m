From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 03/15] target: Update SPC/SBC emulation for sess_prot_type
Date: Tue, 07 Apr 2015 19:28:39 -0400
Message-ID: <yq1oamzh61k.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-4-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Mon, 30 Mar 2015 03:28:12 +0000")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch updates standard INQUIRY, INQUIRY EVPD=0x86,
nab> READ_CAPACITY_16 and control mode pages to use
nab> se_sess->sess_prot_type when determing which type of T10-PI related
nab> feature bits can be exposed.

nab> This is required for fabric sessions supporting T10-PI metadata to
nab> backend devices that don't have protection enabled.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
