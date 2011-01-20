From: FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH] [SCSI] megaraid_sas: Sanity check user supplied length
 before passing it to dma_alloc_coherent()
Date: Thu, 20 Jan 2011 11:39:35 +0900
Message-ID: <AANLkTimchgCY45dp1KtbHUfdKc-4AkPS49v=SHv2KXm4@mail.gmail.com>
References: <1289498526-22589-1-git-send-email-bjorn@mork.no>
	<1291387026-23262-1-git-send-email-bjorn@mork.no>
	<8739op51hr.fsf@nemi.mork.no>
	<4B6A08C587958942AA3002690DD4F8C30106FA7846@cosmail02.lsi.com>
	<87tyh52yi3.fsf@nemi.mork.no>
	<8CEE3947B21C6946A5CFDFA589C276CB010725C417@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63723 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1ATCjg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2011 21:39:36 -0500
Received: by qwa26 with SMTP id 26so107253qwa.19
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2011 18:39:35 -0800 (PST)
In-Reply-To: <8CEE3947B21C6946A5CFDFA589C276CB010725C417@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Benz, Michael" <Michael.Benz@lsi.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>, "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>

2011/1/20 Benz, Michael <Michael.Benz@lsi.com>:

> Please rebase your patch on 2.6.38-rc1 and resubmit. We will review it and ACK or NACK the changes, your proposed changes make sense and seem reasonable but we need to apply and test patches before we can commit the changes.

I think that he already did:

http://marc.info/?l=linux-scsi&m=129542804608130&w=2
