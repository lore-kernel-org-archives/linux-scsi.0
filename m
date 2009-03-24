From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: eh_abort_handler and calling scsi_done
Date: Tue, 24 Mar 2009 15:34:24 +0100
Message-ID: <20090324143424.GA19469@schmichrtp.de.ibm.com>
References: <20090324114137.GA8616@schmichrtp.de.ibm.com> <49C8E055.2060108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:60979 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZCXOea (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 10:34:30 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n2OEYSEK031344
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 14:34:28 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2OEYP513461218
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 14:34:27 GMT
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2OEYPtR002350
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 14:34:25 GMT
Content-Disposition: inline
In-Reply-To: <49C8E055.2060108@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 24, 2009 at 08:29:57AM -0500, Brian King wrote:
> Your assessment sounds correct to me. The other caveat to note is that
> if for some reason in your eh_abort_handler you don't think the command
> is still outstanding, you should return SUCCESS for this as well.

True, thanks for the hint.

The idea is that the zfcp driver does not have to break the link
between the FSF and SCSI commands and the abort_lock in the driver can
be removed. I guess, now i have some information to figure out if i
can remove this step and still satisfy the API requirements.

--
Christof Schmitt
