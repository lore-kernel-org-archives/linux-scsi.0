From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [PATCH resend 0/6] Fix cdrom autoclose
Date: Sat, 27 Jan 2018 23:53:06 +0100
Message-ID: <20180127235306.1742edb9@naga.suse.cz>
References: <cover.1513263482.git.msuchanek@suse.de>
        <cover.1516985620.git.msuchanek@suse.de>
        <1516997096.3034.10.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751785AbeA0W7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Jan 2018 17:59:43 -0500
In-Reply-To: <1516997096.3034.10.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 26 Jan 2018 12:04:56 -0800
James Bottomley <jejb@linux.vnet.ibm.com> wrote:

> On Fri, 2018-01-26 at 17:58 +0100, Michal Suchanek wrote:
> > First time I did not get any feedback for the patches.  
> 
> This is likely because no-one who might inspect the code saw the
> patches ... what list are they going to?  I'm on the block, scsi and
> ide mailing lists and I only saw a doc patch the last time.

This is what the MAINTAINERS file says:

UNIFORM CDROM DRIVER
M:      Jens Axboe <axboe@kernel.dk>
W:      http://www.kernel.dk
S:      Maintained
F:      Documentation/cdrom/
F:      drivers/cdrom/cdrom.c
F:      include/linux/cdrom.h
F:      include/uapi/linux/cdrom.h

Maybe adding some mainling lists there would be useful?

Thanks

Michal
