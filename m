From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Tue, 22 Aug 2017 22:18:06 -0400
Message-ID: <yq1lgmbauxt.fsf@oracle.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Mon, 21 Aug 2017 19:02:10 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Suganath,

>   mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices

I'm still confused about this patch.

 - I don't understand why you go through all these hoops to decide
   whether to use PRPs or IEEE scatterlists. If the firmware translation
   is slow, why even bother with the SG format in the first place? Set
   the max I/O size to match MDTS and you're done.

 - What's the benefit of using SG for regular I/O commands?

 - If the unmap translation in firmware is slow, why don't you translate
   WRITE SAME/w UNMAP set to DSM DEALLOCATE without requiring
   applications to do encapsulated passthrough?

Also make sure you attribute your patches correctly (From: root
<root@dhcp-135-24-192-103.dhcp.avagotech.net>). And you don't need that
long CC: list. Just send the patch series to linux-scsi@vger.kernel.org.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
