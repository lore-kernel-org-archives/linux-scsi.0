From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Unknown problem with Adaptec Raid 2400A card
Date: 26 Jul 2003 01:00:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059177627.1206.19.camel@dhcp22.swansea.linux.org.uk>
References: <1059177564.7003.214.camel@hammer.dale.ro>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:46976
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S272391AbTGYXtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 19:49:10 -0400
In-Reply-To: <1059177564.7003.214.camel@hammer.dale.ro>
List-Id: linux-scsi@vger.kernel.org
To: "Alexandru N. Barloiu" <slak@light.kappa.ro>
Cc: linux-scsi@vger.kernel.org

On Sad, 2003-07-26 at 00:59, Alexandru N. Barloiu wrote:
> Here is the dump from kern.log about the disconect:
> Jul 25 02:09:23 orphan kernel: dpti0: SCSI Timeout-Device (0,0,0) hba
> status=0xa, dev status=0x0, cmd=0x28
> Jul 25 02:09:52 orphan last message repeated 3 times

The card stopped responding

> Jul 25 02:10:32 orphan kernel: dpti0: Trying to reset device
> Jul 25 02:10:32 orphan kernel: dpti0: Device reset not supported
> Jul 25 02:10:32 orphan kernel: dpti0: Bus reset: SCSI Bus 0: tid: 11
> Jul 25 02:10:32 orphan kernel: dpti0: Bus reset success.
> Jul 25 02:10:47 orphan kernel: scsi: device set offline - not ready or
> command retry failed after bus reset: host 0 channel 0 id 0 lun 0
> Jul 25 02:11:17 orphan last message repeated 3 times

And has no reset method so we gave up. You could try using the core i2o
code with it as that does support reset, but I'm not sure what to make
of the fact it is timing out since its a smart controller

