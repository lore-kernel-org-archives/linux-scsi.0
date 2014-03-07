From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 3/6] target: Change core_dev_del_lun to take a se_lun
 instead of unpacked_lun
Date: Fri, 07 Mar 2014 10:20:02 -0800
Message-ID: <531A0DD2.6020905@redhat.com>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com> <1394144131-31499-4-git-send-email-agrover@redhat.com> <20140307103534.GB14195@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140307103534.GB14195@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/07/2014 02:35 AM, Christoph Hellwig wrote:
> On Thu, Mar 06, 2014 at 02:15:28PM -0800, Andy Grover wrote:
>> +void core_dev_del_lun(
>>   	struct se_portal_group *tpg,
>> +	struct se_lun *lun)
>>   {
>> +	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivating %s Logical Unit from"
>>   		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
>> +		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
>>   		tpg->se_tpg_tfo->get_fabric_name());
>>
>> +	core_tpg_post_dellun(tpg, lun);
>
> Seems like core_tpg_post_dellun should be folded into core_dev_del_lun?

It gets more stuff added back to it in a later patch, and post_dellun 
gets renamed too.

Regards -- Andy
