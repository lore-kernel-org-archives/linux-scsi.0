From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Tue, 12 Oct 2004 13:23:10 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <416C12FE.8000406@pobox.com>
References: <4165A85D.7080704@rtr.ca> <4165AB1B.8000204@pobox.com> <4165ACF8.8060208@rtr.ca> <20041007221537.A17712@infradead.org> <1097241583.2412.15.camel@mulgrave> <4166AF2F.6070904@rtr.ca> <1097249266.1678.40.camel@mulgrave> <4166B48E.3020006@rtr.ca> <1097250465.2412.49.camel@mulgrave> <416C0D55.1020603@rtr.ca> <20041012170333.GA9274@havoc.gtf.org> <416C10D9.9090306@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267313AbUJLRY2@vger.kernel.org>
In-Reply-To: <416C10D9.9090306@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph says that your driver doesn't do Domain Validation, which is 
the only place in the SCSI layer that uses schedule_work().  So you are 
fine.

Of course... the source code is there, you could have figured this out 
for yourself :)

	Jeff
