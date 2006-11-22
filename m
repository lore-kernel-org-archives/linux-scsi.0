From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/5] e1000 : Make Intel e1000 driver legacy I/O port
	free
Date: Wed, 22 Nov 2006 09:56:49 +0100
Message-ID: <1164185809.31358.714.camel@laptopd505.fenrus.org>
References: <4564050C.70607@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10980 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161980AbWKVI4w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 03:56:52 -0500
In-Reply-To: <4564050C.70607@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <greg@kroah.com>, Grant Grundler <grundler@parisc-linux.org>, Andrew Morton <akpm@osdl.org>, e1000-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

On Wed, 2006-11-22 at 17:06 +0900, Hidetoshi Seto wrote:
>  static struct pci_device_id e1000_pci_tbl[] = {
> +	INTEL_E1000_ETHERNET_DEVICE(0x1004, 0),
> +	INTEL_E1000_ETHERNET_DEVICE(0x1008, E1000_USE_IOPORT),

Hi,

this has the unfortunate effect that it's now a lot harder to add PCI
ID's to this driver at runtime via sysfs ;(

Greetings,
   Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

