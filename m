From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi sysfs design, ch driver
Date: Sun, 16 Oct 2005 00:39:31 -0600
Message-ID: <20051016063931.GA27989@parisc-linux.org>
References: <4351EA1B.6020402@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36831 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751296AbVJPGjh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 02:39:37 -0400
Content-Disposition: inline
In-Reply-To: <4351EA1B.6020402@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Oct 16, 2005 at 03:50:19PM +1000, Douglas Gilbert wrote:
> So my question is why was "scsi_generic:sg0" form introduced,
> especially the ":sg0" part? It may help visually but it
> is a nuisance programmatically.

It was for the benefit of serial devices (and others) which may have
several classes.

# ls /sys/bus/pci/devices/0000\:00\:04.0
bus     device  local_cpus  subsystem_device  tty:ttyS1
class   driver  modalias    subsystem_vendor  tty:ttyS2
config  irq     resource    tty:ttyS0         vendor

Without the :ttyS*, we'd have three links all called 'tty'.
