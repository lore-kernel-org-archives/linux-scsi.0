From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi 6/7 RESEND] scsi_debug: fix REPORT LUNS Well Known LU
Date: Thu, 30 Jul 2015 13:24:17 -0400
Message-ID: <yq1wpxhmuda.fsf@sermon.lab.mkp.net>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	<1438091666-18113-6-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-6-git-send-email-tomas.winkler@intel.com>
	(Tomas Winkler's message of "Tue, 28 Jul 2015 16:54:25 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tomas" == Tomas Winkler <tomas.winkler@intel.com> writes:

Tomas> The use case to report 'REPORT LUNS WLUN' described in scsi_debug
Tomas> documentation didn't work because: scsi_scan_host_selected()
Tomas> checks for: lun < shost->max_lun

Tomas> To fix this we set: max_lun = SCSI_W_LUN_REPORT_LUNS + 1;

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
