From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/1] scsi: Fix warning: zero-length gnu_printf format string
Date: Thu, 26 Aug 2010 08:00:07 +0200
Message-ID: <AANLkTimQbCX9epuxSQ1NvTk5ejnWpA9jaENfwSAEC_wZ@mail.gmail.com>
References: <20100825235529.GA7152@mail.gmail.com>
	<20100825235809.GA7160@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61683 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0HZGAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2010 02:00:08 -0400
Received: by bwz11 with SMTP id 11so870219bwz.19
        for <linux-scsi@vger.kernel.org>; Wed, 25 Aug 2010 23:00:07 -0700 (PDT)
In-Reply-To: <20100825235809.GA7160@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Sacren <sakiwit@gmail.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Aug 26, 2010 at 1:58 AM, Jean Sacren <sakiwit@gmail.com> wrote:
>
> warning: zero-length gnu_printf format string
>
> Fix the above warning by inserting a space into the literal string.
[ ... ]
> - =A0 =A0 =A0 scmd_printk(KERN_INFO, cmd, "");
> + =A0 =A0 =A0 scmd_printk(KERN_INFO, cmd, " ");

Hello Jean,

Have you considered to replace the empty string by "%s", "" or to
submit a patch that disables the compiler warning on empty format
strings ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
