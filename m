From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 03/20] target: Make all control CDBs scatter-gather
Date: Fri, 08 Jul 2011 17:02:34 -0700
Message-ID: <4E179A9A.4080508@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com> <1310078011-15504-4-git-send-email-agrover@redhat.com> <20110708195755.GA12288@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1GIADC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 20:03:02 -0400
In-Reply-To: <20110708195755.GA12288@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/08/2011 12:57 PM, Christoph Hellwig wrote:
>> +EXPORT_SYMBOL(transport_kmap_first_data_page);
> 
>> +EXPORT_SYMBOL(transport_kunmap_first_data_page);
> 
> Any reason these are exported?

target_core_pscsi.c is a module, and uses it.

> 
>> --- a/include/target/target_core_base.h
>> +++ b/include/target/target_core_base.h
>> @@ -109,7 +109,6 @@ enum se_cmd_flags_table {
>>  	SCF_EMULATED_TASK_SENSE		= 0x00000004,
>>  	SCF_SCSI_DATA_SG_IO_CDB		= 0x00000008,
>>  	SCF_SCSI_CONTROL_SG_IO_CDB	= 0x00000010,
>> -	SCF_SCSI_CONTROL_NONSG_IO_CDB	= 0x00000020,
>>  	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
>>  	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
>>  	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,
> 
> You should be able to kill SCF_PASSTHROUGH_CONTIG_TO_SG as well.

OK will do.

Regards -- Andy
