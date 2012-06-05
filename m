From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [PATCH V4 0/2] Add support for pci/non-pci probing for UFS
Date: Tue, 5 Jun 2012 15:11:30 +0530
Message-ID: <CANfBPZ_OV7iY4Wg9N8m50jYEh-oypbMEaS5U7WN6H9459CsJjQ@mail.gmail.com>
References: <1338810188-30248-1-git-send-email-girish.shivananjappa@linaro.org>
 <CAGxe1ZGOrVaQNT=Bm9cdAoXc4vYLAaXCqV=TKOv3Oe39VhxqHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46973 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757898Ab2FEJlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2012 05:41:52 -0400
Received: by vcbfo14 with SMTP id fo14so3007398vcb.7
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jun 2012 02:41:51 -0700 (PDT)
In-Reply-To: <CAGxe1ZGOrVaQNT=Bm9cdAoXc4vYLAaXCqV=TKOv3Oe39VhxqHg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinayak holikatti <vinholikatti@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On Mon, Jun 4, 2012 at 5:15 PM, Girish K S
<girish.shivananjappa@linaro.org> wrote:
> Hi maintainers,
> pls add
> Reviewed-by: Venkatraman S <svenkatr@ti.com>
> when you accept this patch
>
Girish,
Now that you have resent the patches, you could have added the
"Reviewed-by" tag yourself.
Anyway, there seems to be some problems with your mailer and the
patches have a lot of trailing ^M characters.
I also get this checkpatch warning:
WARNING: please write a paragraph that describes the config symbol fully
#29: FILE: drivers/scsi/ufs/Kconfig:45:
 config SCSI_UFSHCD

James,
  These patched depend on some cleanups that I posted to the same
files a few weeks ago and now they are in Andrew Morton's queue. I'm
not very familiar with the process but I assumed it will get into
3.5-rc1 as part of Andrew's pull request or equivalent.  Should I
resend them to you and ask it to be dropped from Andrew Morton's tree
?

Thanks,
Venkat.
