From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/18] block: add a op_is_flush helper
Date: Thu, 26 Jan 2017 22:38:48 +0000
Message-ID: <1485470308.2540.15.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485365126-23210-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:36576
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752148AbdAZWjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 17:39:08 -0500
In-Reply-To: <1485365126-23210-2-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <A112144B8E710F43BFE4E120ED83973B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> This centralizes the checks for bios that needs to be go into the flush
> state machine.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
