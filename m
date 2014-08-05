From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH] bnx2fc: Set no_async_abort to 1 in SCSI host template.
Date: Tue, 5 Aug 2014 13:38:09 -0700
Message-ID: <CAHdzE-8o94d4d-tJ2j3iUbR7oCO9QYioAqbtRLbGKonR5UK9ZQ@mail.gmail.com>
References: <1407267953-26618-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33858 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHEUiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2014 16:38:10 -0400
Received: by mail-qa0-f46.google.com with SMTP id v10so1522274qac.19
        for <linux-scsi@vger.kernel.org>; Tue, 05 Aug 2014 13:38:09 -0700 (PDT)
In-Reply-To: <1407267953-26618-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com

On Tue, Aug 5, 2014 at 12:45 PM, Chad Dupuis <chad.dupuis@qlogic.com> wrote:
> Set this to 1 for now as we've observed crashes when this is set to the default
> value of 0.

What sorts of crashes have you seen with no_async_abort=0 (default)?
At which kernel versions?

Thanks,
-- vs;
