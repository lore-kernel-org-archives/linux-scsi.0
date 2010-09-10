From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 09 Sep 2010 23:33:34 -0400
Message-ID: <yq1iq2es25t.fsf@sermon.lab.mkp.net>
References: <198194.69355.qm@web32407.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <198194.69355.qm@web32407.mail.mud.yahoo.com> (Anil kumar's
	message of "Thu, 9 Sep 2010 12:34:55 -0700 (PDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Anil kumar <anils_r@yahoo.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Anil" == Anil kumar <anils_r@yahoo.com> writes:

Anil> But I had a quick question, isn't that drive has to support
Anil> "protection enable" also.

Just register DIX Type 0 in the host's protection mask.  That'll enable
protected transfer to the HBA only.


Anil> Also, does Controller FW need to do anything extra to send DIF
Anil> block down to drive. Ideally we will be sending 512 byte blocks
Anil> down to drive.

	http://oss.oracle.com/~mkp/docs/dix-draft.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
