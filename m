From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: FC - NPIV in 2.6.23-rc2
Date: Thu, 30 Aug 2007 09:27:19 -0700
Message-ID: <46D6EFE7.40802@qlogic.com>
References: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:12247 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbXH3Q0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 12:26:05 -0400
In-Reply-To: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhishek Kane <abhishek.kane@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Abhishek Kane wrote:
> Hi,
> 
> With the NPIV support been merged into 2.6.23-rc2, i was interested in
> trying it out on my setup. But i understand from the code that this support
> (NPIV) is only for 24xx cards.
> I need to undertand what are the problems in making it available for 23xx
> cards.
It is not supported. There is no technical issues, though, it won't be supported.

> Also, when going through various docs i came across these 2 terms related to
> port virtualization, viz. NPIV & Multiport id. But i couldn't understand the
> inherent difference in these 2 technologies. So if you guys are aware of
> some sought of documentation for this, please let me know.
NPIV is a feature to provide multiple path available on one physical port and it has implemented based on the multiport ID (MID) capability on the switch.
So, you have to have the switch with MID capable on the configuration to support NPIV, besides the controller.

Thank you,
Seokmann
