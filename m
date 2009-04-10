From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
Date: Thu, 09 Apr 2009 20:47:34 -0400
Message-ID: <49DE9726.40007@garzik.org>
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org> <49DE9513.7050607@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49DE9513.7050607@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> As for the freestanding ata_transport idea which transport
> would a mvsas host adapter belong to which has one phy
> connected to a SATA disk, another connected to a SAS disk and
> a third one connected to a SAS expander with lots of SATA
> disks the other side of that?

Only the direct attach example would use ata_transport.

	Jeff



