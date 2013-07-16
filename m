From: James Bottomley <jbottomley@parallels.com>
Subject: Re: ATTO esas2r -  Scsi_Host_template max_lun setting
Date: Tue, 16 Jul 2013 14:10:52 +0000
Message-ID: <1373983851.2148.61.camel@dabdike>
References: <51E5533F.1030409@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:34912 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3GPOKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jul 2013 10:10:54 -0400
In-Reply-To: <51E5533F.1030409@attotech.com>
Content-Language: en-US
Content-ID: <273A3EBFC3088D498B2A33AD0A717AEE@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

[please keep linux-scsi in the cc otherwise I'll lose the email]
On Tue, 2013-07-16 at 10:05 -0400, Bradley Grove wrote:
> James,
> 
> When we sent the first version of our driver code for comments, you 
> suggested that we set max_lun in the host template and use that to 
> enforce the lun limit.  However, the Scsi_Host_Template struct doesn't 
> doesn't contain mux_lun.  Let me know if I misunderstood what you were 
> asking for.

You set it in the detection routine just after you've obtained struct
scsi_host.  shost->max_lun.

James

> I think we addressed your remaining issues as well as some issues that 
> we found.  That said, it's tough to be sure that we haven't 
> reimplemented primitives that already exist in the kernel tree.
> 


