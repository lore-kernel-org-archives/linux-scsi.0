From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Performance of SCST versus STGT
Date: Fri, 25 Jan 2008 08:24:50 +0100
Message-ID: <e2e108260801242324j6e52f80fw346ff2c3fdb0eaab@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	 <478F246C.4040400@vlnb.net>
	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	 <20080117174542.GC29650@osc.edu>
	 <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	 <4795D4A7.5000105@vlnb.net>
	 <e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
	 <20080124070616.GA31633@porcupine.cita.utoronto.ca>
	 <e2e108260801240816n93a234av4368f5e8b3e49bca@mail.gmail.com>
	 <4798ED07.90000@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:22540 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676AbYAYHYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2008 02:24:51 -0500
Received: by py-out-1112.google.com with SMTP id u52so882081pyb.10
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jan 2008 23:24:50 -0800 (PST)
In-Reply-To: <4798ED07.90000@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Robin Humble <robin.humble+stgt@anu.edu.au>, James.Bottomley@hansenpartnership.com, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel@lists.sourceforge.net

On Jan 24, 2008 8:54 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Ib_rdma_bw now reports 933 MB/s on the same system, correct? Those
> ~250MB/s difference is what you will gain with zero-copy IO implemented
> and what STGT with the current architecture has no chance to achieve.

Yes, that's correct:
* ib_rdma_bw, ib_write_bw and ib_read_bw report 933 MB/s between the
two test systems.
* ib_read_bw reports 905 MB/s.
* ib_rdma_lat reports 3.1 microseconds.
* ib_read_lat reports 7.5 microseconds.

Bart.
