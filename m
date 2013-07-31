From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCHv2] pm80xx: fix Adaptec 71605H hang
Date: Wed, 31 Jul 2013 17:19:40 +0200
Message-ID: <51F92B0C.70804@gmail.com>
References: <51F2A741.1020702@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49189 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3GaPTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jul 2013 11:19:53 -0400
Received: by mail-bk0-f51.google.com with SMTP id ji2so294287bkc.38
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jul 2013 08:19:52 -0700 (PDT)
In-Reply-To: <51F2A741.1020702@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, AnandKumar.Santhanam@pmcs.com, lindar_liu@usish.com, Sangeetha.Gnanasekaran@pmcs.com

On 07/26/2013 06:43 PM, Hans Verkuil wrote:
> The IO command size is 128 bytes for these new controllers as opposed to 64
> for the old 8001 controller.
> 
> The Adaptec out-of-tree driver did this correctly. After comparing the two
> this turned out to be the crucial difference.
> 
> So don't hardcode the IO command size, instead use pm8001_ha->iomb_size as
> that is the correct value for both old and new controllers.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org      # for v3.10 and up
snip

Thanks Hans.
Looks good now.

Acked-by: Jack Wang <xjtuwjp@gmail.com>

James,

Could you consider to include this fix into your fixes tree, without
this fix new Adaptec controller support is broken, sorry for that.


Jack
