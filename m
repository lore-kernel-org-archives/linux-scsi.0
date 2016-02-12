From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/7] ibmvscsi: Replace magic values in
 set_adpater_info() with defines
Date: Fri, 12 Feb 2016 08:51:09 -0800
Message-ID: <56BE0D7D.3050703@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455154348-3226-4-git-send-email-tyreld@linux.vnet.ibm.com>
 <1455295395.2396.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455295395.2396.22.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 02/12/2016 08:43 AM, James Bottomley wrote:
> On Wed, 2016-02-10 at 19:32 -0600, Tyrel Datwyler wrote:
>> Add defines for mad version and mad os_type, and replace the magic
>> numbers in set_adapter_info() accordingly.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
>> ---
> 
> Is there some reason you didn't carry the review tag over from this:
> 
> http://mid.gmane.org/20160204084459.GW27969@c203.arch.suse.de
> 
> ?
> 
> James

The patch is slightly changed from v1. A define for AIX os type was
added as mentioned in the cover letter v2 changes, and I moved the
defines to the mad_adapter_info_data structure around the fields they apply.

-Tyrel

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
