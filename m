From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Sat, 06 Feb 2016 21:19:27 -0800
Message-ID: <1454822367.10001.38.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <56B6C5D8.6070403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60286 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbcBGFTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2016 00:19:31 -0500
In-Reply-To: <56B6C5D8.6070403@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>

On Sat, 2016-02-06 at 20:19 -0800, Bart Van Assche wrote:
> On 02/06/16 19:17, Nicholas A. Bellinger wrote:
> > Here is -v4 series to address the set of of LUN_RESET
> > active I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
> > recently by Quinn & Co.  This can occur during active
> > I/O remote port TMR LUN_RESET with multi-port LIO
> > configurations.
> 
> Hi Nic,
> 
> If I understood the purpose of this patch series correctly then this 
> patch series is a brave attempt to fix what is also fixed by my patch 
> called "target: Make ABORT and LUN RESET handling synchronous". Wouldn't 
> it be better to focus on that patch instead of trying to fix the current 
> approach in which TMR handling happens from the another context than the 
> command processing context ?
> 

This statement is a gross oversimplification of the issues involved.

If you'll recall, this was already highlighted in the context of your
patch here:

http://www.spinics.net/lists/target-devel/msg11057.html

There are a number of comments on why the bug-fix was incorrect and
broken, the basics of what needed to be done and in what order it should
happen.

But instead of replying to the comments, this was your response:

http://www.spinics.net/lists/target-devel/msg11542.html

If you are authentically interested in understanding the issues
involved, you'll probably need to go back and comment on those topics
individually, instead of ignoring them.

