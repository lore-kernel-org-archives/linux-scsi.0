From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] libata new EH document
Date: Wed, 31 Aug 2005 20:30:27 -0700 (PDT)
Message-ID: <20050901033027.63466.qmail@web51605.mail.yahoo.com>
References: <4316569B.6080406@gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4316569B.6080406@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Albert Lee <albertcc@tw.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
>   IMHO, it's a good idea to maintain one qc to one ATA/ATAPI command 
> mapping as long as possible.  And, in the suggested framework, it's 

Yes, that makes sense.

> guaranteed that no other command can come inbetween CHECK_SENSE and 
> REQUEST_SENSE.

That's good.

>   Requesting sense from EH,

Done in an ATA eh handler.

> calling scsi_decide_disposition() on the 
> sense 

Done in SCSI Core.

> and following the verdict should achieve the same effect as
> emulating autosense.

Yes, precisely.

> Is there any compelling reason to break one qc to 
> one command mapping?

?

     Luben

