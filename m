From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [RFC V1 0/4] Add support for pci/non-pci probing for UFS
Date: Wed, 16 May 2012 19:29:35 +0530
Message-ID: <CAGxe1ZEh10JLSEp4BJ+HVmMAfgbqGBXoiiKa5-dLETGrnfO0JA@mail.gmail.com>
References: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
	<20120516121631.GA25085@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52369 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444Ab2EPN7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 09:59:36 -0400
Received: by weyu7 with SMTP id u7so459553wey.19
        for <linux-scsi@vger.kernel.org>; Wed, 16 May 2012 06:59:35 -0700 (PDT)
In-Reply-To: <20120516121631.GA25085@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

On 16 May 2012 17:46, Christoph Hellwig <hch@infradead.org> wrote:
> Please redo the patch series as:
>
> =A0patch 1: split pci into a separate module, including removing the =
old
> =A0 =A0 =A0 =A0 =A0code, adding the new code and all the kconfig wire=
 up
> =A0patch 2: add platform probing
>
> so that the tree always stays in a working state.
Sure will do that
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
