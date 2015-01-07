From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/8] megaraid_sas : Disable interrupt_mask before enabling hardware interrupts
Date: Tue, 06 Jan 2015 19:31:13 -0500
Message-ID: <yq17fwz77ou.fsf@sermon.lab.mkp.net>
References: <201501051440.t05EeF85030030@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201501051440.t05EeF85030030@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:06:13 +0530")
Sender: stable-owner@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> Update driver "mask_interrupts" before enable/disable hardware
Sumit> interrupt in order to avoid missing interrupts because of
Sumit> "mask_interrupts" still set to 1 and hardware interrupts are
Sumit> enabled.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
