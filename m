From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery
 issue with saturn adapter.")
Date: Wed, 20 May 2015 13:55:01 +1000
Message-ID: <555C0595.9060507@ozlabs.ru>
References: <1430209582-23925-1-git-send-email-aik@ozlabs.ru>	<5548E2C1.3070209@emulex.com> <20150505234659.00003ab7@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150505234659.00003ab7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, james.smart@emulex.com
Cc: linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/06/2015 07:46 AM, Sebastian Herbszt wrote:
> James Smart wrote:
>>
>> Reviewed-By: James Smart <james.smart@emulex.com>
>>
>>
>> Alexey, Sebastian,
>>
>> Yes - this section needs to be reverted.  This patch is good.
>>
>> -- james s
>
> Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>


Unfortunately, just this revert is not enough, it fixed one of my machines 
but I have another machine with "Emulex Corporation Saturn-X: LightPulse 
Fibre Channel Host Adapter (rev 03)" which does not boot - the booting 
process stops at "[  OK  ] Reached target Basic System."

Any quick idea what else to revert between 4.0 and current upstream before 
I dig further? Thanks!



-- 
Alexey
