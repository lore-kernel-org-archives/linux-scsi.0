From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] T10-PI RDMA offload
Date: Fri, 17 Jan 2014 00:47:04 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46CCEEDC@avmb2.qlogic.org>
References: <52D7F6DC.10502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52D7F6DC.10502@dev.mellanox.co.il>
Content-Language: en-US
Content-ID: <BDAD4C8EDDC2184EB0D07298F500D953@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org



On 1/16/14 7:12 AM, "Sagi Grimberg" <sagig@dev.mellanox.co.il> wrote:

>Hey SCSI (and LSF) folks,
>
>I'd like to propose the following topic for upcoming LSF-MM:
>
>T10-PI standard is becoming more and more appealing for storage and
>cloud solutions.
>Since error-detection coding comes with its cost of CPU computation
>overhead,
>state-of-the-art ASICs offer the ability to offload T10-PI operations
>(DIF/DIX), examples
>are SAS & FC controllers. Recently, the support for T10-PI offload over
>RDMA transactions
>was introduced in the Mellanox Connect-IB HCA.
>
>The first building block, RDMA verbs API supporting T10-PI offload was
>submitted over
>Linux-rdma (see http://marc.info/?l=linux-rdma&m=138719320307936&w=2).
>Moreover,
>we have seen first seeds of T10-PI support in Linux SCSI target entering
>v3.14 (see
>http://lwn.net/Articles/579708/) and RDMA offload implementation in iSER
>transport
>(see http://www.spinics.net/lists/linux-scsi/msg71128.html). There is
>still some ground to
>fill to get protection information support to a full solution over all
>backend devices.
>
>We would like to use LSF-MM platform to to push forward T10-PI support
>end-to-end which
>requires Linux SCSI Target core level support along with transport level
>support in iSER and SRP
>(and also FCoE in the future) and over to the Initiator side transports.
>
>Discussion topics:
>- Introduce T10-PI offload RDMA verbs and how are used in storage
>applications.
>- Discuss effects of DIX1.1 (currently a draft) in Target implementation
>(core level -> transport level -> HW level).
>- Discuss T10-PI Type 4 (16-byte DIF) status and possible implications
>on Target & Initiator implementation down to HW level.
>- Discuss Current Limitations that T10-PI RDMA offload poses on iSCSI
>protocol (ImmediateData, UnsolDataOut) and if/how
>   they can be solved.
>- What-ever else comes to mind...

+1

Would like to hear this discussion and see how this implementation can
expand to Fibre Channel HW offload(Target mode storage).

Regards,
Quinn Tran




>
>Thanks,
>Sagi.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
