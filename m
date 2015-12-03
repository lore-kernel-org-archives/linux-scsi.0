From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_process+0x900/0xe50
Date: Thu, 3 Dec 2015 17:20:27 +0300
Message-ID: <56604FAB.2080600@virtuozzo.com>
Reply-To: <1449097101.2203.67.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:39580 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbbLCOUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2015 09:20:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrea Gelmini <andrea.gelmini@gelma.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I have very similar problem with SAS2X28, please take a look on a bug 
report here https://bugzilla.kernel.org/show_bug.cgi?id=108771

Thanks, Pavel
