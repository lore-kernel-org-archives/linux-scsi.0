From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 15:36:10 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <20060124202306.GA8422@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32468 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964920AbWAXUg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 15:36:29 -0500
In-Reply-To: <20060124202306.GA8422@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Patrick Mansfield wrote:

> On Tue, Jan 24, 2006 at 12:52:36PM -0500, Chip Coldwell wrote:
>
>> Put
>>
>> options st try_direct_io=0
>
>>
>> in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
>> significantly (factor of >5) degrates read performance.  I don't know
>> about writes.
>
> For tape???

Yes, for tape.  We verified this with a DAT72 DDS drive.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

