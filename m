From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Mon, 13 Feb 2006 21:40:50 +0100
Message-ID: <43F0EED2.4000203@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:422 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964883AbWBMUly (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 15:41:54 -0500
In-Reply-To: <43EDB35F.40709@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Al Viro <viro@ftp.linux.org.uk>, linux1394-devel@lists.sourceforge.net

I wrote:
[panic when attaching a INIC-2430F based 1394b SBP-2 disk]
> MODE_SENSE_10 seemed to be the trigger, as mentioned in 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112128914912105 .

The BLIST_MS_SKIP_PAGE_08 (skip_ms_page_8) flag avoids the panic.
I will continue to investigate...
-- 
Stefan Richter
-=====-=-==- --=- -==-=
http://arcgraph.de/sr/
