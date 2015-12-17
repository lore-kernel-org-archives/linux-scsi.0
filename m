From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: Patch size problem
Date: Fri, 18 Dec 2015 09:26:27 +1100
Message-ID: <CAGRGNgVSjzvdnsX1MJqyMzpmSyVm6U_Mt-GiCknj0_8DejXBCg@mail.gmail.com>
References: <5672DD19.9040704@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35610 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbbLQW0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2015 17:26:48 -0500
Received: by mail-io0-f194.google.com with SMTP id o67so6360572iof.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 14:26:48 -0800 (PST)
In-Reply-To: <5672DD19.9040704@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Joao,

On Fri, Dec 18, 2015 at 3:04 AM, Joao Pinto <Joao.Pinto@synopsys.com> wrote:
> Hi,
> I have a patch ready to send which contains a new UFS driver, but the problem is
> that the patch size is ~200K and my company' email security blocks it.
> Is it possible to send the driver in a tarball?

The usual practise in this case is to split it into patches per file
(I assume it's broken down into a few separate files to implement
different bits of functionality) sending the bits that link it into
the build system (Kconfig and Makefiles) last.

Alternatively, if you have a non-work account, you could send it
through that with appropriate From headers at the top of the email.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
