From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 14:12:57 -0500
Message-ID: <yq1k3qkrl8m.fsf@sermon.lab.mkp.net>
References: <20130206195122.GA30652@sgi.com>
	<20130206202444.GA4771@blackbox.djwong.org>
	<20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com>
	<20130207094012.GA28047@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130207094012.GA28047@localhost> (Joel Becker's message of
	"Thu, 7 Feb 2013 01:40:14 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chuck Lever <chuck.lever@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Joel" == Joel Becker <jlbec@evilplan.org> writes:

Joel> I'm happy to chat about it.  Unfortunately, like Darrick says,
Joel> sys_dio() coding hasn't happened.  I do think we're better off
Joel> with some kind of explicit API than some magic state on the file.
Joel> I mean, even something like:

Joel> 	ssize_t write_with_pi(int fd, const void *buf, size_t count,
Joel> 			      const void *pi, size_t pi_count);

Joel> It's not as nice as a non-historical API (eg sys_dio), but it also
Joel> probably plays nicer with buffered I/O.

Pretty much everyone I have talked to that are interested in explicitly
attaching PI (as opposed to relying on the kernel doing it) are using
Linux aio.

I am not opposed to having more read()/write() like interface as
well. But I think it's important to cater to the I/O paradigm used by
the applications interested in this. It's a lot easier to tweak a few
IOCB fields than it is to rewrite how an application does I/O.

-- 
Martin K. Petersen	Oracle Linux Engineering
