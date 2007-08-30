From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: FC - NPIV in 2.6.23-rc2
Date: Thu, 30 Aug 2007 10:25:23 -0700
Message-ID: <46D6FD83.4010708@qlogic.com>
References: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>	 <46D6EFE7.40802@qlogic.com> <7579f7fb0708300947r4bae76a8j3715316741f3563f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:23783 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbXH3RYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 13:24:08 -0400
In-Reply-To: <7579f7fb0708300947r4bae76a8j3715316741f3563f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <lydianconcepts@gmail.com>
Cc: Abhishek Kane <abhishek.kane@gmail.com>, linux-kernel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Matthew Jacob wrote:
>>> some sought of documentation for this, please let me know.
>> NPIV is a feature to provide multiple path available on one physical port and it has implemented based on the multiport ID (MID) capability on the switch.
>> So, you have to have the switch with MID capable on the configuration to support NPIV, besides the controller.
>>
> 
> No, if the switch doesn't suport NP-IV, the 24XX f/w will come up in
> Public Loop mode (FL).
That is correct. 
As it should, the F/W with NPIV capability also works on the configuration with non-NPIV switches.

Thank you,
Seokmann
