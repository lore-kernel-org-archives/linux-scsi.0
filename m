From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 11:33:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4010096D.4030205@us.ibm.com>
References: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com> 	<4010034A.3040903@us.ibm.com> <1074792163.2149.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:63440 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266348AbUAVRdj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 12:33:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2004-01-22 at 12:07, Brian King wrote:
> 
>>Because the device is reported to the LLDD by the adapter as a
>>specific device type. The adapter creates a configuration table
>>describing all attached devices that the LLDD must retrieve. In this
>>configuration table there are several types of devices:
> 
> 
> If you can't ever get access to these devices and you only want sg
> access for SCSI command ioctls, you could just alter the device type to
> something like PROCESSOR (or even an unclassified type) which will solve
> the error messages from sd problem.

I agree that this is a solution as well (requires more code), but
then sysfs will show the device as a different device type, which
I would think might be confusing.

> The true solution to this issue looks to be more flexibility in the
> binding process.  We did discuss this previously, certainly in a SAN
> environment there are reasons for only actually binding (and allocating
> resources to) devices you're interested in.

Who generally has this knowledge in your example? The LLDD? Would a
LLDD host template function that gets called for each disk be more
palatable?


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

