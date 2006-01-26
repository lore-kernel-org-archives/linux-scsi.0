From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Thu, 26 Jan 2006 11:39:54 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601261138500.23310@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <20060124202306.GA8422@us.ibm.com> <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
 <Pine.LNX.4.63.0601252306270.5794@kai.makisara.local>
 <Pine.LNX.4.64.0601261033010.23310@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28892 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964792AbWAZQkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2006 11:40:21 -0500
In-Reply-To: <Pine.LNX.4.64.0601261033010.23310@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Thu, 26 Jan 2006, Chip Coldwell wrote:
>
> then again with direct I/O
>
> RHEL4# time dd if=/dev/nst0 of=/dev/null bs=32k
> 31250+0 records in
> 31250+0 records out
>
> real    2m30.687s
> user    0m0.063s
> sys     0m0.677s
>
> So in this case, performance is no worse or better with direct I/O
> than without.

I tried it again with direct I/O and an even larger block size, but
the time is the same:

RHEL4# time dd if=/dev/nst0 of=/dev/null bs=64k
15625+0 records in
15625+0 records out

real    2m30.153s
user    0m0.025s
sys     0m0.452s

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

