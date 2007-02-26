From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Please help if u can.
Date: Mon, 26 Feb 2007 14:13:35 -0800 (PST)
Message-ID: <780394.89621.qm@web31813.mail.mud.yahoo.com>
References: <45DBE495.6050706@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:28667 "HELO
	web31813.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161284AbXBZWNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Feb 2007 17:13:43 -0500
In-Reply-To: <45DBE495.6050706@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, John Scarpa <john@tlchosting.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

--- "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Laziness, in my case.  I suppose it would be useful to document the fact
> that I've made changes to libsas/aic94xx.  Though the "what has been
> done" part ... I was hoping the commit messages would suffice.

Doing a rev list on drivers/scsi/aic94xx shows only 25 commits.

But if you diff what was committed (2908d778ab3e244900c310974e1fc1c69066e450)
with my code as posted to lkml and lsml -- huge differences.

That is, what was commited (2908d778ab3e244900c310974e1fc1c69066e450)
is already changed code.  So the commits and justifications
of those changes and differences are nowhere to be found.

Note that the driver as posted by me to lkml and lsml back in Sept
2005 was fully functional.  From functionality point of new, no
changes were necessary.

> > The existing copyright notices should remain but what
> > about the massive changes to that driver in 2006?
> > Where is the indication of whom John should contact?
> >
> > Perhaps something like:
> >  "For maintenance of this driver contact
> >   linux-scsi@vger.kernel.org"
> 
> Alexis can answer this part.
> 
> > FYI John, Luben maintains his own version of the
> > aic94xx and that version holds the sequencer firmware
> > in a binary blob within the driver. Due to kernel policy,
> > that blob was moved to separate file by someone else. The
> > error that you are reporting suggests that the firmware
> > file for the aic94xx cannot be found. On my system
> > the file that you may be missing looks like this:
> > # ls -l /lib/firmware/aic94xx-seq.fw
> > -rw-rw-r-- 1 root root 22622 Aug 29 17:36 /lib/firmware/aic94xx-seq.fw
> 
> http://kernel.org/pub/linux/kernel/people/jejb/aic94xx-seq.fw
> 
> --D
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

