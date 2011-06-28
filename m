From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 01/15] target: Remove ifdeffed code in t_g_process_write
Date: Tue, 28 Jun 2011 13:50:15 -0700
Message-ID: <4E0A3E87.6050401@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com> <1309289377-8029-2-git-send-email-agrover@redhat.com> <20110628201045.GA9676@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1F1UuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:50:19 -0400
In-Reply-To: <20110628201045.GA9676@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/28/2011 01:10 PM, Christoph Hellwig wrote:
>>  void transport_generic_process_write(struct se_cmd *cmd)
>>  {
>> -#if 0
> 
> ...
> 
>> -#endif
>>  	transport_execute_tasks(cmd);
>>  }
>>  EXPORT_SYMBOL(transport_generic_process_write);
> 
> How about just killing transport_generic_process_write and calling
> transport_execute_tasks directly?

Thanks for reviewing the set. I'm going to wait a day or two to see if
more comments come in, then I'll repost. I'm inclined to agree with all
your comments, except I'll probably save the change mentioned above for
a follow-on patchset, unless it's fixed in the meantime.

Thanks again -- Regards -- Andy
