From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Help - looking for IO test tools
Date: Wed, 04 Aug 2004 15:53:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091649195.3108.44.camel@localhost.localdomain>
References: <519672568F040C41B6FAC21ADF51B18F1C4441@mailnode1.commstor.crossroads.com>
	 <20040804122928.3152449b.rddunlap@osdl.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:39861 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S267394AbUHDTxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 15:53:31 -0400
In-Reply-To: <20040804122928.3152449b.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Lee Xing <lxing@Crossroads.com>, linux-scsi <linux-scsi@vger.kernel.org>

current iometer still need a windows machine as a console. but we have
plan to get rid of that console sometime later.

ming

On Wed, 2004-08-04 at 15:29, Randy.Dunlap wrote:
> On Wed, 4 Aug 2004 13:58:36 -0500 Lee Xing wrote:
> 
> | Hi,
> | 
> | Sorry, this post may be a bit off topic.
> | 
> | Just wondering if there are any IO test tools like IOMeter, with which we can select different parameters (IO size, percentage of read/write, percentage of sequential/random, etc.) and see the IO rate (MB/sec) and num of IO/sec with the selected parameters.
> | 
> | IOMeter is okay but we have to use an extra Windows machine to run it.  If we can find a self-contained IO test tool for Linux, that would be very helpful.
> 
> IOmeter is available for Linux, too.  Does it still need an extra
> Windows machine?  or maybe for analysis?
> 	http://sourceforge.net/projects/iometer
> 
> --
> ~Randy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
 --------------------------------------------------
| Ming Zhang, PhD. Student
| Dept. of Electrical & Computer Engineering
| College of Engineering
| University of Rhode Island
| Kingston RI. 02881
| e-mail: mingz at ele.uri.edu
| Tel. (401) 874-2293 
| Fax. (401) 782-6422
| http://www.ele.uri.edu/~mingz/
| http://crab.ele.uri.edu/gallery/albums.php
 --------------------------------------------------


