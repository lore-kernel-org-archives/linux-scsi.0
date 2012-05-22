From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC V3 1/2] SCSI: UFS: Create separate UFS core and pci modules
Date: Tue, 22 May 2012 08:34:12 +0100
Message-ID: <1337672052.16400.17.camel@dabdike.int.hansenpartnership.com>
References: <1337581868-3042-1-git-send-email-girish.shivananjappa@linaro.org>
	 <1337581868-3042-2-git-send-email-girish.shivananjappa@linaro.org>
	 <CANfBPZ_G-jaai_qWmHu_43gGbE43Wp0Lr49O-2pQ3ozC=QHfwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47684 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab2EVHeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 03:34:17 -0400
In-Reply-To: <CANfBPZ_G-jaai_qWmHu_43gGbE43Wp0Lr49O-2pQ3ozC=QHfwQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: Girish K S <girish.shivananjappa@linaro.org>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On Tue, 2012-05-22 at 10:59 +0530, S, Venkatraman wrote:
[...]

trimming your reply to give only the relevant part would be greatly
appreciated so we don't have to go through hundreds of lines to find the
useful bits.

> > +static int __init ufshcd_probe(void)
> > +{
> > +       pr_info(UFSHCD
> > +               ": Generic UFS host controller driver\n");
> > +       pr_info(UFSHCD ": Copyright(c) Samsung India Software Operations\n");

> Is it really necessary to assert the copyright on probe ? I haven't
> seen this practice anywhere..

It has been done before, but it's now frowned upon because if everyone
did it, the kernel would be more verbose than a guilty politician before
the ethics committee, so please just remove it.

James


