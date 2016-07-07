From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] libata-scsi: better style in ata_msense_caching()
Date: Thu, 7 Jul 2016 16:00:39 +0300
Message-ID: <5265a11d-f7a2-d21f-8e7e-d1118fc7da86@cogentembedded.com>
References: <577db3cf.0a6a620a.c3774.1508@mx.google.com>
 <b7d33126-814b-60c2-8699-0e63bbf42834@cogentembedded.com>
 <CAGnHSE=kH9f_2D3Sjc9qptBa344w_qebdncSrfMq_vW6stVq2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36555 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbcGGNAo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2016 09:00:44 -0400
Received: by mail-lf0-f46.google.com with SMTP id q132so10800570lfe.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jul 2016 06:00:44 -0700 (PDT)
In-Reply-To: <CAGnHSE=kH9f_2D3Sjc9qptBa344w_qebdncSrfMq_vW6stVq2A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/07/2016 03:44 PM, Tom Yan wrote:

> Sorry I am a bit new in this. Does that mean I should also use {} for
> the if clause even it has only one line of statement, because I
> (needed to) use that for the else clause? So it should be like:

>
> if ... {
>     ...
> } else {
>     ...
>     ...
> }

    Exactly, see Documentation/CodingStyle, chapter 3.

MBR, Sergei

