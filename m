From: Jeff Garzik <jgarzik@pobox.com>
Subject: RFC: moving drivers to a new drivers/ata directory
Date: Fri, 15 Oct 2004 00:51:35 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <416F5757.8000306@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org


Eventually I would like to move libata, and a few non-libata driver like 
3ware, to drivers/ata.  It would appear in the makefile (and link order) 
_after_ drivers/ide and drivers/scsi.

Comments/objections?

	Jeff



