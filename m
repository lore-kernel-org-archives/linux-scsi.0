From: Jaco van der Schyff <jvds@netgroup.co.za>
Subject: Re: aic79xx dumping card state
Date: Fri, 10 Nov 2006 17:01:26 +0200
Message-ID: <20061110150126.GA8222@npjaco>
References: <20061110004508.GF2667@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netgroup.co.za ([196.25.213.80]:15591 "EHLO
	mail.netgroup.co.za") by vger.kernel.org with ESMTP
	id S1946699AbWKJPBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 10:01:25 -0500
Content-Disposition: inline
In-Reply-To: <20061110004508.GF2667@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stone <mstone@mathom.us>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 09, 2006 at 07:45:09PM -0500, Michael Stone wrote:
> >>>>>>>>>>>>>>>>>>Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi2: Dumping Card State at program address 0x3b Mode 0x22
> Card was paused
> INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
> SCSISIGI[0x24]:(P_DATAOUT_DT|BSYI) SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x40]:(ENSELO) SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4]:(SELECTOUT_QFROZEN) QFREEZE_COUNT[0x0] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff] SSTAT0[0x10]:(SELINGO) SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED) LQOSTAT0[0x0] LQOSTAT1[0x0] 
> LQOSTAT2[0x40] 
> SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0xff00
> qinstart = 90 qinfifonext = 90
> QINFIFO:
> WAITING_TID_QUEUES:
>       0 ( 0x3 )
> Pending list:
>  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] Total 1

I had very similar problems on the aic79xx cards.  What you could first
check if QAS is enabled/disabled on both devices, and step the card down
to 160MB/s.  I haven't successfully ran any aic79xx Ultra320 card at
Ultra320...

Clock it down and it should be fine...


- Jaco van der Schyff
