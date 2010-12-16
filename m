From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Thu, 16 Dec 2010 23:10:01 +0800
Message-ID: <AANLkTim9JykddjavkPU-CPMr2vXHS89G+YmqNi9ZmS39@mail.gmail.com>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
	<4CBBDC19.1090806@cs.wisc.edu>
	<1288040021.5487.826.camel@mulgrave.site>
	<4CC75F42.9030603@cs.wisc.edu>
	<1288134569.19649.5.camel@mulgrave.site>
	<4CC86CF5.1080204@cs.wisc.edu>
	<4D07DA3C.2080209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:42744 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0LPPKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 10:10:02 -0500
Received: by eyg5 with SMTP id 5so1937132eyg.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 07:10:01 -0800 (PST)
In-Reply-To: <4D07DA3C.2080209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Wed, Dec 15, 2010 at 4:57 AM, Mike Christie <michaelc@cs.wisc.edu> wrote:
>
> Hey James,
>
> Your patch with the _init fixed the problem for me. Were you going to merge
---> the patch or did you want me to test Hilf's version?
+++> the patch or did you want me to test Hillf's version?

haha, another typo cleaned up.

Signed-off-by: Hillf Danton
