From: Richard Smith <rsmith@bitworks.com>
Subject: 2.6.x scsi software raid IO tuning
Date: Wed, 29 Oct 2003 16:00:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FA03862.5080203@bitworks.com>
Reply-To: rsmith@bitworks.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from b44.xdsl.pgtc.com ([198.70.248.44]:46841 "HELO bitworks.com")
	by vger.kernel.org with SMTP id S261699AbTJ2WAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 17:00:20 -0500
Received: from bitworks.com [192.168.1.22] by bitworks.com [127.0.0.1] with SMTP (MDaemon.v2.7.SP4.R) for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2003 15:58:59 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I receintly came across several SCSI racks with drives.  So I've been
playing with various software RAID setups with between 8 - 15 drives. I
have a sym8xx SE chain and a AIC7xxx HVD chain.  Using Bonnie++ to
measure IO throughput of my RAID 5 setup.

I also decided to try the latest 2.6 test kernels.  I built the 2.6 with
the same setup as my 2.4.22 kernel.  Preemption was disabled and I
believe that I have all debugging output turned off.

I found that in every test case I ran Bonnie++ reported the 2.6 kernel
IO as 3 to 5 MB/s slower than the 2.4 kernel.  File creation/deletion 
was also slower.

Is there some tuning knobs that I need to tweak or some option that
might be enabled causing this?  I thought the 2.6 was supposed to have
much better IO throughput when setup in non-preempt.  So I expected to
at least get the same numbers not less.

My apologies if this is a md issue rather than a scsi issue but out of 
my info searches so far this list seemed like the best place to ask for 
info.

-- 
Richard A. Smith
rsmith@bitworks.com


