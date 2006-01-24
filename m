From: Chip Coldwell <coldwell@frank.harvard.edu>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 12:52:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:27609 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1161012AbWAXRww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 12:52:52 -0500
In-Reply-To: <43D604AD.6050607@ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Gerhard Schneider wrote:

>
> It's getting me mad..
>
> It seems that with 2.6 (compared to 2.4) there has something been
> changed in the kernel that I'm not aware of so I'm not able to
> write/read tapes efficiently anymore..

Put

options st try_direct_io=0

in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
significantly (factor of >5) degrates read performance.  I don't know
about writes.

Chip

-- 
Charles M. "Chip" Coldwell
"Turn on, log in, tune out"

