From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Fri, 8 Feb 2013 01:36:01 -0800
Message-ID: <20130208093558.GA2733@localhost>
References: <20130206195122.GA30652@sgi.com>
 <20130206202444.GA4771@blackbox.djwong.org>
 <20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com>
 <20130207094012.GA28047@localhost>
 <yq1k3qkrl8m.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53374 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab3BHJgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 04:36:10 -0500
Content-Disposition: inline
In-Reply-To: <yq1k3qkrl8m.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 07, 2013 at 02:12:57PM -0500, Martin K. Petersen wrote:
> >>>>> "Joel" == Joel Becker <jlbec@evilplan.org> writes:
> 
> Joel> I'm happy to chat about it.  Unfortunately, like Darrick says,
> Joel> sys_dio() coding hasn't happened.  I do think we're better off
> Joel> with some kind of explicit API than some magic state on the file.
> Joel> I mean, even something like:
> 
> Joel> 	ssize_t write_with_pi(int fd, const void *buf, size_t count,
> Joel> 			      const void *pi, size_t pi_count);
> 
> Joel> It's not as nice as a non-historical API (eg sys_dio), but it also
> Joel> probably plays nicer with buffered I/O.
> 
> Pretty much everyone I have talked to that are interested in explicitly
> attaching PI (as opposed to relying on the kernel doing it) are using
> Linux aio.
> 
> I am not opposed to having more read()/write() like interface as
> well. But I think it's important to cater to the I/O paradigm used by
> the applications interested in this. It's a lot easier to tweak a few
> IOCB fields than it is to rewrite how an application does I/O.

You know I'm not going to argue with this.  I was merely stating that
I'm flexible in how we start :-)

Joel

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

			http://www.jlbec.org/
			jlbec@evilplan.org
