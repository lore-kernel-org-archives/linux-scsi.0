From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] [ATTEND] qla2xxx FC target mode
Date: Fri, 16 Mar 2012 16:40:53 -0700
Message-ID: <1331941253.10203.280.camel@haakon2.linux-iscsi.org>
References: <1327796869.18763.211.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327796869.18763.211.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <mail@hannes-reinecke.de>
List-Id: linux-scsi@vger.kernel.org

James & Co,

Ping..?  Any thoughts on this topic yet..?

Thanks,

--nab

On Sat, 2012-01-28 at 16:27 -0800, Nicholas A. Bellinger wrote:
> Hello,
> 
> Given the interest getting the Qlogic FC Target driver merged into
> mainline during the v3.4 -> v3.5 time frame, I would like to propose a
> LSF storage track discussion for some of the longer term items wrt
> qla2xxx target mode that are stretching across SCSI + target subsystems.
> 
> We would like to eventually support mixed SCSI initiator / target mode
> on a per HW port context basis.  Before that can happen in mainline some
> of the interaction between SCSI core and target core will need to be
> sorted out..
> 
> This includes:
> 
> - I -> T transition between active initiator mode LLD LUNs 
>   + active TCM ports in same LLD
> - T -> I transition + rescan of ports without having to restart SCSI LLD
> - mixed mode running on the same physical/virtual port
> - target core dependencies in SCSI core to make this work..?
> 
> More background is available in the RFC-v4 posting here:
> http://www.spinics.net/lists/target-devel/msg01424.html
> 
> Thanks!
> 
> --nab
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
