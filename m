From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] mvsas: defer non-NCQ cmds when NCQ cmds are active
Date: Tue, 21 Sep 2010 15:41:19 -0400
Message-ID: <AANLkTim1=xsTzO6P+QpByX_=wWKUsbNLWY3VsPvXObv8@mail.gmail.com>
References: <20100921191701.GA16726@dhcp-10-15-1-70.hsv.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53422 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0IUTlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 15:41:20 -0400
Received: by bwz11 with SMTP id 11so5375726bwz.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 12:41:19 -0700 (PDT)
In-Reply-To: <20100921191701.GA16726@dhcp-10-15-1-70.hsv.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, k.skarlatos@gmail.com

On Tue, Sep 21, 2010 at 3:17 PM, David Milburn <dmilburn@redhat.com> wrote:
> Non-NCQ commands should run exclusively, ata_qc_issue warns when mixing
> non-NCQ and NCQ commands.
>
> Signed-off-by: David Milburn <dmilburn@redhat.com>
> Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>
