From: Kiran Patil <kiran.patil@intel.com>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Wed, 15 Jun 2011 13:53:56 -0700
Message-ID: <4DF91BE4.5090105@intel.com>
References: <1308023045-5257-1-git-send-email-roland@kernel.org> <1308157596.20109.28.camel@haakon2.linux-iscsi.org> <BANLkTimM-=fGphT_okWuMYY1LgDk=XQzow@mail.gmail.com> <1308158714.20109.33.camel@haakon2.linux-iscsi.org> <4DF8F163.6010103@intel.com> <BANLkTimxM4OzQ6imbea0xqb3rmfBehfgEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13611 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1FOUx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2011 16:53:57 -0400
In-Reply-To: <BANLkTimxM4OzQ6imbea0xqb3rmfBehfgEA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/15/2011 12:41 PM, Roland Dreier wrote:
> On Wed, Jun 15, 2011 at 10:52 AM, Kiran Patil<kiran.patil@intel.com>  wrote:
>> Likewise, we need to do same change in function "transport_get_lun_for_tmr",
>> specifically for tmr_lock. Please correct me if I am missing anything.
> Yes, that's right... in fact that is what we were discussing now, isn't it?
> Or is there something different I'm missing?
>
> (BTW transport_get_lun_for_tmr is renamed to transport_lookup_tmr_lun
> in the latest tree)
>
>   - R.

Cool. Then we are referring to same function. Looks like I am using old 
tree which has function name "transport_get_lun_for_tmr"

Thanks,
-- Kiran P,


