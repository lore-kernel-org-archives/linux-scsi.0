From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug  v 1.75 for lk 2.6.9-bk4
Date: Sat, 23 Oct 2004 15:27:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4179EBDA.1090205@torque.net>
References: <4179B89B.8030207@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:32182 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267702AbUJWF2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2004 01:28:39 -0400
In-Reply-To: <4179B89B.8030207@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nacc@us.ibm.com

Douglas Gilbert wrote:
> This gzipped patch is against lk 2.6.9-bk4 which is
> after the lk 2.6.9 release and includes James's "[BK
> PATCH] SCSI updates for 2.6.9" omnibus patch.
> 
> The changelog is with respect to version 1.74 found
> in James's post lk 2.6.9 patch. The scsi_debug.[hc] files
> can be found in the sdebug175.tgz tarball at
> http://www.torque.net/sg/sdebug26.html
> 
> Nishanth, perhaps you could test this version and report
> if it works and if the data transfers still seem slow.
> 
> Changelog:
>     - fix highmem data transfers
>          - fix kunmap_atomic() argument
>          - disable clustering
>     - allow every_nth < 0 for error continuously once
>       count is reached
>     - minor sense buffer handling cleanup

The patch applies and works against lk 2.6.10-rc1 as well.

Doug Gilbert
