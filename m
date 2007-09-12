From: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 09/24] libata-scsi: convert to use the data buffer accessors
Date: Wed, 12 Sep 2007 09:36:16 +0300
Message-ID: <ec7f7ee70709112336w3aeda276wb7064f6a34420f88@mail.gmail.com>
References: <46E6F92D.2090409@panasas.com> <46E72B8D.1080508@panasas.com>
	 <46E72E4F.9020508@garzik.org>
	 <20070912014046.GB14439@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:63669 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXILGgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2007 02:36:18 -0400
Received: by wa-out-1112.google.com with SMTP id v27so131823wah
        for <linux-scsi@vger.kernel.org>; Tue, 11 Sep 2007 23:36:17 -0700 (PDT)
In-Reply-To: <20070912014046.GB14439@one-eyed-alien.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kro

On 9/12/07, Matthew Dharm <mdharm-scsi@one-eyed-alien.net> wrote:
> On Tue, Sep 11, 2007 at 08:09:51PM -0400, Jeff Garzik wrote:
> > I would much rather see the !use_sg cleanup in a separate patch series...
>
> Are we really sure this can all go?  No requests, not even ones from SG_IO
> will ever use the non-sg paths?
>
> Matt
>

The last place that did !use_sg was fixed Yesterday. It was the
REQUEST_SENSE in usb's transport.c
The before the last one was removed by Christoph in 2.6.18

Boaz
