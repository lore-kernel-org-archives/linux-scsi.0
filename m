From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: uas - kernel panic on drive connection
Date: Sat, 12 Jul 2014 12:16:36 +0200
Message-ID: <53C10B04.5090607@redhat.com>
References: <20140704104028.2014aaf4@earthlink.net>	<53BCEA03.30304@redhat.com>	<20140709193139.32049945@earthlink.net>	<53BFB01C.6020900@redhat.com> <20140711204034.745d85a4@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaGLKQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 06:16:40 -0400
In-Reply-To: <20140711204034.745d85a4@earthlink.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan <jonathan.625266@earthlink.net>, linux-scsi@vger.kernel.org

Hi,

On 07/12/2014 02:40 AM, Jonathan wrote:
> Hans,
>
> Sure enough, the enclosure worked flawlessly with uas on a machine with an Intel xhci controller (2012 MacBook Air running Linux with kernel 3.15.3). I  look forward to learning your results with the Etron controller.

Ok, that is good to hear. The best way forward then is probably
to disable bulk streams (and thus uas) on etron controllers for now.

Once I've my Etron controller I can try to fix this, and re-enable
streams on them if I succeed.

Can please file a bug at:

https://bugzilla.kernel.org/enter_bug.cgi?product=Drivers

Component USB and put jwrdegoede@fedoraproject.org in the CC?

Please include the output of these 2 commands in the bug report:

lsusb -v
lspci -nn

Also please include a remark that you are able to work around
this by using the quirk to use usb-storage unstead of uas.

Thanks,

Hans
