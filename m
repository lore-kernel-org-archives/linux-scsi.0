From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Mon, 16 Mar 2009 04:36:15 -0700
Message-ID: <583F8053-957C-42DC-8A7E-851DC82DC5DA@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BC2CCF.2050105@emulex.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57338 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbZCPLgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2009 07:36:22 -0400
In-Reply-To: <49BC2CCF.2050105@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>


On Mar 14, 2009, at 3:16 PM, James Smart wrote:

> Thank you Seokmann. I'm glad the RFC worked well for you.  Your  
> patch is
> appreciated, it was the portion that needed to be reverted as the
> collapsed blk_end_request() patch wasn't taken.  To double check -  
> there
> are no patches required with the RFC now - right ?
Yes, for those ELS/CT service handling through rports, it works for me.

Thank you,
Seokmann
