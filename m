From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 12:23:06 -0800
Message-ID: <20060124202306.GA8422@us.ibm.com>
References: <43D604AD.6050607@ilsb.tuwien.ac.at> <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:63699 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932440AbWAXUXk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 15:23:40 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0OKNeNF009620
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 15:23:40 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0OKLtiD024062
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 13:21:55 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k0OKNZQZ009882
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 13:23:35 -0700
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chip Coldwell <coldwell@frank.harvard.edu>
Cc: Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Tue, Jan 24, 2006 at 12:52:36PM -0500, Chip Coldwell wrote:

> Put
> 
> options st try_direct_io=0

> 
> in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
> significantly (factor of >5) degrates read performance.  I don't know
> about writes.

For tape???

-- Patrick Mansfield
