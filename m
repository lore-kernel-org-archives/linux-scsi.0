From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] fix idiocy in asd_init_lseq_mdp()
Date: Mon, 25 Sep 2006 10:16:34 -0700 (PDT)
Message-ID: <20060925171634.69667.qmail@web31809.mail.mud.yahoo.com>
References: <4517EBF7.4020508@torque.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:30051 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751312AbWIYRQf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 13:16:35 -0400
In-Reply-To: <4517EBF7.4020508@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Al Viro <viro@ftp.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--- Douglas Gilbert <dougg@torque.net> wrote:
> Al Viro wrote:
> > To whoever had written that code:
> > 
> > a) priority of >> is higher than that of &
> > b) priority of typecast is higher than that of any binary operator
> > c) learn the fscking C
[...]
> BTW Luben was pointing out that the call you patched
> and the following call can be combined into a less
> trouble prone asd_write_reg_dword() call.

More than that -- I looked at the history of that
file/line and the code as I had written it _never_ had
that broken cast and shift mess.

"Someone" changed that after I submitted the code to lkml/lsml.

    Luben

