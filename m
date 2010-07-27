From: Ravi Anand <ravi.anand@qlogic.com>
Subject: RE: scsi-next fail to be compiled
Date: Tue, 27 Jul 2010 13:45:49 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871287C9628@AVEXMB1.qlogic.org>
References: <4C4F2BC0.6030905@kernel.org>,<1280257446.2833.268.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:40452 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0G0UtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2010 16:49:19 -0400
In-Reply-To: <1280257446.2833.268.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Yinghai Lu <yinghai@kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Andrew Vasquez <an>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



>On Tue, 2010-07-27 James Bottomley wrote:
>On Tue, 2010-07-27 at 11:56 -0700, Yinghai Lu wrote:
> LD      drivers/scsi/built-in.o
> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_idc_unlock':
> (.text+0x8814): multiple definition of `qla82xx_idc_unlock'
> drivers/scsi/qla2xxx/built-in.o:(.text+0x2ea14): first defined here
> drivers/scsi/qla2xxx/built-in.o:(.text+0x30c56): first defined here
> make[1]: *** [drivers/scsi/built-in.o] Error 1
> make: *** [drivers/scsi/] Error 2

>This is because exactly the same functions appear in the qla2xxx/ and
>qla4xxx/ directories

>Qlogic people, please get this sorted out now, otherwise I'll drop the
>qla4xxx update before sending to Linus

We will try to resolve this ASAP.  When are you planning to send it to Linus ?

>The best option would be to separate out the 82xx functions so that both
>2xxx and 4xxx can use them.  In the interim, you could add a
>discriminator prefix.

We will put in discriminator prefix and  repost the patches.

Thanks
Ravi
