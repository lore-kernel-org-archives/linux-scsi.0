From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Fri, 18 May 2007 19:09:04 +0400
Message-ID: <464DC190.7030608@vlnb.net>
References: <88044fc70705171348l64913b26r742718986632f3ca@mail.gmail.com>	<464D5074.3080601@vlnb.net> <88044fc70705180721x7d8ac7efvd4f8d716470d93be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([85.249.135.242]:51244 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137AbXERPIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2007 11:08:45 -0400
In-Reply-To: <88044fc70705180721x7d8ac7efvd4f8d716470d93be@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sandip shete <sandipshete@gmail.com>
Cc: scst-devel@lists.sourceforge.net, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

sandip shete wrote:
> Hi,
> 
> I wish to develop support for QLA 24xx series. If you already have a 
> partial implementaion of the same, i would like to take it forward.
> And if there isn't, i would appreciate if you could give me some 
> pointers in that direction.

Most probably, the driver by link sent by Matthew Jacob will be a good 
starting point, where you can see examples how to work with the card, so 
you can add it to the qla2x00t driver. Also you will need a manual the 
firmware interface specification for 2400 series of the cards. It is 
under NDA, but you maybe lucky to get one from QLogic. Feel free to ask 
me any SCST or qla2x00t driver related questions.

> I have adequate experience of programming in the SCSI domain, however i 
> am not much conversant with the QLA driver code.
> 
> Thanks and Regards,
> Sandip S
