From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx: failing on high load
Date: Mon, 14 Jan 2008 11:45:13 -0800
Message-ID: <20080114194513.GC7118@tree.beaverton.ibm.com>
References: <20080114144916.GD23867@alaris.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60681 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYANTp3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 14:45:29 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0EJlGup018270
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 14:47:16 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0EJjPXc067204
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 14:45:26 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0EJjOg9029016
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 14:45:25 -0500
Content-Disposition: inline
In-Reply-To: <20080114144916.GD23867@alaris.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Sembera <jsembera@suse.cz>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, vojtech@suse.cz, Peter Bogdanovic <pbog@us.ibm.com>

On Mon, Jan 14, 2008 at 03:49:16PM +0100, Jan Sembera wrote:
> Hi,
> 
> 	we have array of 16 SAS disks connected to Adaptec controllers
> ...
> this elsewhere and I was recommended to send it to linux-scsi.

Hmm... I think Peter Bogdanovic was hitting this error recently (cc'd).
There are a lot of PRIMITIVE_RECVD messages in the log, which make me
wonder if the expander is being flaky or something?  The commands that
start timing out under heavy load followed by the repeated broadcasts
might be indicative of that, since the sequencer firmware and the kernel
driver are up to date.  Unfortunately, I don't have any LSI expanders...

--D
