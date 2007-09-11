From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH ver3 1/5] scsi_error: code cleanup before refactoring
 of scsi_send_eh_cmnd()
Date: Tue, 11 Sep 2007 20:38:42 +0300
Message-ID: <46E6D2A2.5000300@panasas.com>
References: <Pine.LNX.4.44L0.0709111138460.3852-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12087 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757183AbXIKRj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 13:39:26 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709111138460.3852-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Tue, Sep 11 2007 at 18:41 +0300, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 11 Sep 2007, Boaz Harrosh wrote:
> 
>>   - regrouped variables for easier reviewing of next patch
>>   - Support of cmnd==NULL in call to scsi_send_eh_cmnd()
>>   - In the copy_sense case set transfer size to the minimum
>>     size of sense_buffer and passed @sense_bytes. cmnd[4] is
>>     set accordingly.
>>   - REQUEST_SENSE is set into cmnd[0] so if @sense_bytes is
>>     not Zero passed cmnd can/should be NULL.
>>   - Also save/restore resid of faild command.
> 
> The "if (sense_bytes)" block doesn't set scmd->cmd_len.  Yes, I know 
> that value gets changed by the usb-storage driver, but nevertheless it 
> should be set here to 6.
> 
> Apart from that, this looks fine to me.
> 
> Alan Stern
> 
Thanks a million. The 22:45 effect again.
Will patch ver4 of this patch as reply to
first one.

Boaz

