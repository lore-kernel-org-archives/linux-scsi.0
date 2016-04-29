From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: UFS patchset
Date: Fri, 29 Apr 2016 13:29:58 +0100
Message-ID: <572353C6.5070308@synopsys.com>
References: <57233664.3090101@synopsys.com>
 <yq1h9ekbo9j.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:48167 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbcD2MaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 08:30:07 -0400
In-Reply-To: <yq1h9ekbo9j.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/29/2016 1:19 PM, Martin K. Petersen wrote:
>>>>>> "Joao" == Joao Pinto <Joao.Pinto@synopsys.com> writes:
> 
> Joao,
> 
> Joao> Could you please give me feedback about the UFS patch-set?  The
> Joao> patches have been acked by various developers, so maybe could it
> Joao> be possible to put it into the 4.7 queue?
> 
> It is on my list.

Ok, great!

> 
> I think we are OK from a SCSI perspective but I believe there were still
> a couple of concerns in the ARM/device tree department. So I would like
> some confirmation from those developers that the code is now acceptable.
> 

The concerns were from Rob Herring about mixing PHY and controller in the
compatibility string, but that was justified. Check the extract:

">>
>>>
>>> Combining the phy and controller compatible strings is a bit strange.
>>> Generally, they would be separate nodes using the common phy binding.
>>>
>>
>> Correct, but in this case is just the compatibility string is just to
>> tell the dw ufs host that it has a 40-bit or a 20-bit test chip
>> connected. The Test chip is initialized by a unipro command sequence and
there is no more ops related to it.
>
> Okay. In that case, I think it should be a separate property unless
> the controller h/w is synthesized for one or the other.

Yes, the hardware must be synthesized for a certain PHY type, 20 or 40-bit.

>
> Rob
>

Joao"

Thanks,
Joao

