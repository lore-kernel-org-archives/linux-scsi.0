From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Tue, 23 Dec 2008 16:47:31 +0200
Message-ID: <4950FA03.9080106@panasas.com>
References: <20081223135938.30266108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:32032 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYLWOrj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2008 09:47:39 -0500
Received: by ey-out-2122.google.com with SMTP id 22so273877eye.37
        for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2008 06:47:36 -0800 (PST)
In-Reply-To: <20081223135938.30266108042@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12207
> 
> 
> 
> 
> 
> ------- Comment #6 from stern@rowland.harvard.edu  2008-12-23 05:59 -------
> You can change the max_sectors setting through sysfs.  However the last time I
> looked, the block layer limited max_sectors to 512 KB or something on that
> order, so you can't get too much improvement.
> 
> Why is a limit of 120 KB unreasonably small?  All it means is that you have to
> use more system calls to transfer the same amount of data.  Is anything wrong
> with that?
> 
> 

This is not true BIOs can be chained and also SGs can be chained.
You should be able to configure a very large transfer

Boaz
