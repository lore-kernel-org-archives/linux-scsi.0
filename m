From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] [Trivial Patch] scsi_register-002
Date: 23 Jun 2003 15:17:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056377839.13528.46.camel@dhcp22.swansea.linux.org.uk>
References: <20030623070134.A15482C074@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:34512
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S266052AbTFWOFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 10:05:38 -0400
In-Reply-To: <20030623070134.A15482C074@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, aacraid@adaptec.com, linux-scsi@vger.kernel.org

On Llu, 2003-06-23 at 07:56, Rusty Trivial Russell wrote:
> (Included in 2.5)
> From:  Michael Still <mikal@stillhq.com>
> 
>   
>   This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...

Fix is subtly wrong because of aac_count, fixed up in my tree will push
to Marcelo with the rest of the aacraid updates soon

