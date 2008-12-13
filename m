From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Sat, 13 Dec 2008 10:41:53 +0100
Message-ID: <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756570AbYLMJmN@vger.kernel.org>
In-Reply-To: <54939.1229149205@turing-police.cc.vt.edu>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: nab@kernel.org, linux-iscsi-target-dev@googlegroups.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 13, 2008 at 7:20 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 12 Dec 2008 01:40:09 PST, "Nicholas A. Bellinger" said:
>
>> Too bad, because you are missing out on the most advanced ConfigFS
>> enabled storage engine on the planet.
>
> OK. I *have* to ask.. ;)
>
> What's the *second* most advanced configfs-enabled storage engine?

Please don't let Nicholas Bellinger mislead you. The most important
aspect of a storage engine is stability. Last January I ran
performance tests on IET, STGT, SCST and LIO. I quickly found out not
only that SCST had the highest throughput and the lowest latency, but
also that the performance tests on LIO triggered several kernel
crashes. I have reported these crashes to the linux-iscsi-target-dev
mailing list, but even as of today, it's not yet clear whether all of
these crashes have been fixed. During the last ten years I have filed
bug reports for many open source projects, and the LIO project is the
only project where the (kernel) crashes I reported were not addressed
immediately.

See also:
* February 1, 2008, LIO kernel panic during configuration,
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/74c8b37f24b84e59/d94c07626bd20521?lnk=gst&q=kernel+panic#d94c07626bd20521.
* February 8, 2008, kernel crash triggered by LIO,
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/30835aede1028188/5708e16a23367fb4?lnk=gst&q=kernel+crash#5708e16a23367fb4.
* February 13, 2008, LIO target kernel code triggers memory
corruption, http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/ddc1bf7666372972/2150a09f9ed3d1cd?lnk=gst&q=ipoib#2150a09f9ed3d1cd.
* February 18, 2008, LIO target makes entire system hang,
http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/6a76f9efd9409fc5/55bd8840b6a5f757?lnk=gst&q=lio+target+hangs#55bd8840b6a5f757.

Bart.
