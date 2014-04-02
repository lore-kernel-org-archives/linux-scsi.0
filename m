From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 2/4] tcm_qla2xxx: T10-Dif set harware capability
Date: Wed, 2 Apr 2014 13:26:23 +0300
Message-ID: <533BE5CF.1040800@mellanox.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>	 <1396047927-14189-3-git-send-email-quinn.tran@qlogic.com>	 <5336100B.1010604@mellanox.com>	 <504EB66DAC8D234EB8E8560985C2D7AD46CE91BC@avmb2.qlogic.org>	 <1396314671.22665.76.camel@haakon3.risingtidesystems.com>	 <533A731E.4000709@dev.mellanox.co.il> <1396374013.18589.9.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396374013.18589.9.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Quinn Tran <quinn.tran@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On 4/1/2014 8:40 PM, Nicholas A. Bellinger wrote:
> <SNIP>
>> So no way to get it centralized?
> Yes, still working on how that might look..
>
>>   I still don't understand the iscsi/iser constraint.
> Every other fabric aside from iscsi/iser could simply provide a
> TFO->get_fabric_prot(se_tpg) to query for supported PI.
>
> The reason why iscsi/iser is unique is because we can have different
> network portals (eg: iser protected + traditional iscsi unprotected) on
> the same se_tpg endpoint.

I see. That seems solvable to me... perhaps the easiest thing is to just 
go ahead and support T10-PI
in iscsi-tcp (SW)...

Sagi.
