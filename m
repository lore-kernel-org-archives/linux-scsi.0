From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [RESEND] [PATCH 1/1] ses: Retry UNIT ATTENTION for receive diagnostics
Date: Fri, 16 Sep 2016 18:25:47 -0300
Message-ID: <87poo3pmec.fsf@linux.vnet.ibm.com>
References: <20160916210607.054BF124047@b01ledav002.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160916210607.054BF124047@b01ledav002.gho.pok.ibm.com> (Brian
        King's message of "Fri, 16 Sep 2016 16:06:06 -0500")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> If the ses driver receives a UNIT ATTENTION when issuing
> a receive diagnostics while probing a SES device, it
> fails to attach with messages such as:
>
> scsi 1:0:7:0: Failed to get diagnostic page 0x8000002
> scsi 1:0:7:0: Failed to bind enclosure -19
>
> Fix this by eating unit attentions for these commands.


Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>



-- 
Gabriel Krisman Bertazi
