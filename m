From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Help - looking for IO test tools
Date: Wed, 4 Aug 2004 12:29:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804122928.3152449b.rddunlap@osdl.org>
References: <519672568F040C41B6FAC21ADF51B18F1C4441@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:13512 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266781AbUHDTub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 15:50:31 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18F1C4441@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2004 13:58:36 -0500 Lee Xing wrote:

| Hi,
| 
| Sorry, this post may be a bit off topic.
| 
| Just wondering if there are any IO test tools like IOMeter, with which we can select different parameters (IO size, percentage of read/write, percentage of sequential/random, etc.) and see the IO rate (MB/sec) and num of IO/sec with the selected parameters.
| 
| IOMeter is okay but we have to use an extra Windows machine to run it.  If we can find a self-contained IO test tool for Linux, that would be very helpful.

IOmeter is available for Linux, too.  Does it still need an extra
Windows machine?  or maybe for analysis?
	http://sourceforge.net/projects/iometer

--
~Randy
