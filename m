From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 06/10] qla4xxx: Added support for ISP82XX
Date: Wed, 14 Jul 2010 11:35:26 +0530
Message-ID: <152EDA47-A496-486B-A5AE-C35E0B810FF0@qlogic.com>
References: <20100710092048.GA11514@sles11sp1b1.qlogic.org> <4C3B8A14.4030803@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:32746 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0GNGFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2010 02:05:32 -0400
In-Reply-To: <4C3B8A14.4030803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>


On Jul 13, 2010, at 3:03 AM, Mike Christie wrote:

> On 07/10/2010 04:20 AM, Vikas Chaudhary wrote:
>> @@ -622,18 +624,42 @@ static void qla4xxx_isr_decode_mailbox(struct  
>> scsi_qla_host * ha,
>>  		default:
>>  			DEBUG2(printk(KERN_WARNING
>>  				      "scsi%ld: AEN %04x UNKNOWN\n",
>> -				      ha->host_no, mbox_status));
>> +				      ha->host_no, mbox_sts[0]));
>>  			break;
>>  		}
>>  	} else {
>>  		DEBUG2(printk("scsi%ld: Unknown mailbox status %08X\n",
>>  			      ha->host_no, mbox_status));
>>
>> -		ha->mbox_status[0] = mbox_status;
>> +		ha->mbox_status[0] = mbox_sts[0];
>>  	}
>>  }
>
> Normally, if you resend your patchset you would just fix up these type
> of issues on the resend.
>
> Other than the compile warning from that code, patches look fine.  
> Thanks
> for fixing up the other stuff.
>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

James,

All other patches in this patch set are also blessed by Mike.C
in earlier posts. Please pull this patch set
(http://marc.info/?l=linux-scsi&m=127875362624209&w=2)
to scsi-misc-2.6 tree in next merge.

Thanks,
Vikas.
