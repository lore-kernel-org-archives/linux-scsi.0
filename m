From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 1/3] libata, libsas: kill pm_result and related cleanup
Date: Mon, 10 Mar 2014 16:44:38 -0400
Message-ID: <20140310204438.GI25290@htj.dyndns.org>
References: <20140305201443.20088.85361.stgit@viggo.jf.intel.com>
 <20140305201730.20088.42218.stgit@viggo.jf.intel.com>
 <20140310202947.GG25290@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57619 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaCJUol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 16:44:41 -0400
Content-Disposition: inline
In-Reply-To: <20140310202947.GG25290@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@Parallels.com, Phillip Susi <psusi@ubuntu.com>, Todd Brandt <todd.e.brandt@intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Mon, Mar 10, 2014 at 04:29:47PM -0400, Tejun Heo wrote:
> Let's please use proper static functions.  The compiler can deal with
> inlining.  Also, maybe ata_port_resume() and ata_port_resume_async()
> are better names for the wrappers?

So, if the suggested names don't jive well with the rest of the
series, my only concern is that none of other ATA functions start with
the verb, so something like ata_port_queue_resume() would be fine too.

Thanks.

-- 
tejun
