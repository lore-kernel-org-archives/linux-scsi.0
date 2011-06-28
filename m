From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/15] target: Remove ifdeffed code in t_g_process_write
Date: Tue, 28 Jun 2011 16:10:45 -0400
Message-ID: <20110628201045.GA9676@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-2-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55754
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab1F1UKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:10:46 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-2-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

>  void transport_generic_process_write(struct se_cmd *cmd)
>  {
> -#if 0

...

> -#endif
>  	transport_execute_tasks(cmd);
>  }
>  EXPORT_SYMBOL(transport_generic_process_write);

How about just killing transport_generic_process_write and calling
transport_execute_tasks directly?

