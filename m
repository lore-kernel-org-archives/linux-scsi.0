From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: mainline aic94xx firmware woes
Date: Mon, 25 Sep 2006 12:34:50 +0200
Message-ID: <9a8748490609250334r5d104adex3599c52b2358aba3@mail.gmail.com>
References: <20060925101124.GH6374@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:15754 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1751083AbWIYKev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 06:34:51 -0400
Received: by wx-out-0506.google.com with SMTP id s14so1784865wxc
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2006 03:34:50 -0700 (PDT)
In-Reply-To: <20060925101124.GH6374@rhun.haifa.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>

On 25/09/06, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> Hi,
>
> The recently merged aic94xx in mainline requires external firmware
> support. This, in turn, necessitates an initrd/initramfs environment
> that includes firmware support to load the firmware. Will a patch to
> optionally include the firmware inline in the kernel and thus not
> having to use an initramfs be acceptable?
>
It's not my call, but I'd say that if the firmware is not GPL and the
source for that firmware is not available then the answer will be NO
(which would also be my personal opinion btw).

> Also, aic94xx does not compile unless FW_LOADER is set in .config due
> to missing 'request_firmware'. What's the right thing to do here -
> aic94xx selecting it, depending on it, or FW_LOADER providing empty
> request_firmware() in case it's compiled out (the last one violates
> the principle of least surprise IMHO).
>
I'd say aic94xx depending on it with a note in the help text that it
requires it. But that's just my personal opinion.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
