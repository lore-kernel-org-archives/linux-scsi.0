From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [RFC V3 1/2] SCSI: UFS: Create separate UFS core and pci modules
Date: Tue, 22 May 2012 14:16:11 +0530
Message-ID: <CAGxe1ZFppacqiiQL03ZZfBVadw2QsAre87wfmpK3CTARE+uBaQ@mail.gmail.com>
References: <1337581868-3042-1-git-send-email-girish.shivananjappa@linaro.org>
	<1337581868-3042-2-git-send-email-girish.shivananjappa@linaro.org>
	<CANfBPZ_G-jaai_qWmHu_43gGbE43Wp0Lr49O-2pQ3ozC=QHfwQ@mail.gmail.com>
	<1337672052.16400.17.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36947 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2EVIqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 04:46:13 -0400
Received: by qcro28 with SMTP id o28so3792672qcr.19
        for <linux-scsi@vger.kernel.org>; Tue, 22 May 2012 01:46:12 -0700 (PDT)
In-Reply-To: <1337672052.16400.17.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "S, Venkatraman" <svenkatr@ti.com>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On 22 May 2012 13:04, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2012-05-22 at 10:59 +0530, S, Venkatraman wrote:
> [...]
>
> trimming your reply to give only the relevant part would be greatly
> appreciated so we don't have to go through hundreds of lines to find =
the
> useful bits.
>
>> > +static int __init ufshcd_probe(void)
>> > +{
>> > + =A0 =A0 =A0 pr_info(UFSHCD
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ": Generic UFS host controller drive=
r\n");
>> > + =A0 =A0 =A0 pr_info(UFSHCD ": Copyright(c) Samsung India Softwar=
e Operations\n");
>
>> Is it really necessary to assert the copyright on probe ? I haven't
>> seen this practice anywhere..
>
> It has been done before, but it's now frowned upon because if everyon=
e
> did it, the kernel would be more verbose than a guilty politician bef=
ore
> the ethics committee, so please just remove it.
OK will remove it.
>
> James
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
