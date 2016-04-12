From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_scsi.c: Deinline fnic_queue_abort_io_req, save 1792 bytes
Date: Mon, 11 Apr 2016 22:16:43 -0400
Message-ID: <yq1shyrzi44.fsf@sermon.lab.mkp.net>
References: <1460141926-13069-1-git-send-email-dvlasenk@redhat.com>
	<1460141926-13069-2-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460141926-13069-2-git-send-email-dvlasenk@redhat.com> (Denys
	Vlasenko's message of "Fri, 8 Apr 2016 20:58:43 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Satish Kharat <satishkh@cisco.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Denys" == Denys Vlasenko <dvlasenk@redhat.com> writes:

Denys> This function compiles to 511 bytes of machine code.  Abort
Denys> commands are not time-critical at all.

Satish, please review.

https://patchwork.kernel.org/patch/8785281/

-- 
Martin K. Petersen	Oracle Linux Engineering
