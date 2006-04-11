From: "adam radford" <aradford@gmail.com>
Subject: Re: [PATCH 1/1] 3ware 9000 disable local irqs during kmap_atomic
Date: Tue, 11 Apr 2006 12:12:41 -0700
Message-ID: <b1bc6a000604111212i1fe8e057j1857fc9a512d3363@mail.gmail.com>
References: <b1bc6a000604111125s74a95319m39e23598ed4755a5@mail.gmail.com>
	 <443BFB37.8080400@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.187]:20008 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750824AbWDKTMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 15:12:44 -0400
Received: by nproxy.gmail.com with SMTP id g2so885923nfe
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2006 12:12:43 -0700 (PDT)
In-Reply-To: <443BFB37.8080400@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 4/11/06, Jeff Garzik <jeff@garzik.org> wrote:
> I saw the fix go into 2.6.17-rc1-git on git-commits-head list.  Please
> check out the latest linux-2.6.git and send a patch against what's in
> there...
>
>         Jeff
>

Jeff,

The patch in 2.6.17-rc1-git5 is for the 3w-xxxx driver, which is fine.
The patch I sent is the same fix for the 3w-9xxx driver.

-Adam
