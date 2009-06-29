From: Drew <drew.kay@gmail.com>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 06:40:21 -0700
Message-ID: <c268e4660906290640k3364aeaey30d37b884a2ce1c6@mail.gmail.com>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <20090629133431.GM5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:48248 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZF2Nkm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 09:40:42 -0400
Received: by an-out-0708.google.com with SMTP id d40so4441582and.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 06:40:45 -0700 (PDT)
In-Reply-To: <20090629133431.GM5480@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, linux-scsi@vger.kernel.org

> You could also go for a configuration fix where you reconfigure the array
> with LUNs below 2TB and then use MD or DM to stitch them back together
> into a single device.

Would you not also have to partition the drive using GPT partitions?
LVM aside, I thought any partition over 2TB had to be GPT.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
