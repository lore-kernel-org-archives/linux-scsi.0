From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: driver hacking tips (was Re: [PATCH] QStor SATA/RAID driver for
 2.6.9-rc3)
Date: Tue, 12 Oct 2004 15:40:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416C3336.1010609@pobox.com>
References: <4161A06D.8010601@rtr.ca>	<416547B6.5080505@rtr.ca>	<20041007150709.B12688@i			nfradead.org>	<4165624C.5060405@rtr.ca>	<416565DB.4050006@pobox.com>	<4165	A	4	5D.2090200@rtr.ca>	<4165A766.1040104@pobox.com>	<4165A85D.7080704@rtr.ca	>		<4	165AB1B.8000204@pobox.com>	<4165ACF8.8060208@rtr.ca>		<20041007221537.	A17	712@infradead.org>	<1097241583.2412.15.camel@mulgrave>		<4166AF2F.607090	4@rtr.ca> <1097249266.1678.40.camel@mulgrave>		<4166B48E.3020006@rtr.ca>	<1097250465.2412.49.camel@mulgrave> 	<416C0D55.1020603@rtr.ca>	<1097601478.2044.103.camel@mulgrave>  <416C12CC.1050301@rtr.ca> <1097602220.2044.119.camel@mulgrave> <416C157A.6030400@rtr.ca> <416C177B.6030504@pobox.com> <416C19B9.7000806@rtr.ca> <416C2189.4080302@pobox.com> <416C2DFE.2030006@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38572 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267638AbUJLTk6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 15:40:58 -0400
In-Reply-To: <416C2DFE.2030006@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mark Lord wrote:
> At driver module unload time, is there any way to guarantee
> that all pending "schedule_work()" events have been processed?


flush_workqueue() [private workqueue] and flush_scheduled_work()

	Jeff


