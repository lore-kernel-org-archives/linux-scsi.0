From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC: moving drivers to a new drivers/ata directory
Date: Fri, 15 Oct 2004 19:32:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097865140.10133.184.camel@localhost.localdomain>
References: <416F5757.8000306@pobox.com> <416F8C39.6010804@torque.net>
	 <417006F0.5040706@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:8912 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S268378AbUJOTe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 15:34:58 -0400
In-Reply-To: <417006F0.5040706@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Gwe, 2004-10-15 at 18:20, Jeff Garzik wrote:
> Maybe we need a neutral one like 'drivers/storage'.

Where does that leave usb, firewire or i2o 8). At the end of the 
day the only "perfect" division is a single directory "drivers", and
that doesn't work.

Having drivers/ata seems a decent approximation.

