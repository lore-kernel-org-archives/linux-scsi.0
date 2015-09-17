From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RESEND] scsi: Fix sense information setting in fixed sized
 format
Date: Thu, 17 Sep 2015 19:47:10 +0300
Message-ID: <55FAEE8E.5080106@dev.mellanox.co.il>
References: <1441298973-27735-1-git-send-email-sagig@mellanox.com>
 <1441306948.23183.328.camel@localhost.localdomain>
 <55FAB53C.3080102@dev.mellanox.co.il>
 <1442499863.4073.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37628 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbbIQQrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 12:47:05 -0400
Received: by wicfx3 with SMTP id fx3so35272750wic.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 09:47:02 -0700 (PDT)
In-Reply-To: <1442499863.4073.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: emilne@redhat.com, linux-scsi@vger.kernel.org


>> James, can you pick this up please?
>
> It went quietly via the target tree.  I did keep an eye on it because
> the target disruption in scsi_sommon.c was why I couldn't send the rest
> of your sense descriptor patches via scsi.
>
> commit 12306b425d0dbab7b60f54e02d67cf3dfae494d1

I didn't notice that. Sorry for the hassle.

Thanks James!
