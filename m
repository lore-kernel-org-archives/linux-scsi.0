From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Patch 4/6] lpfc 8.3.5: Add AER support
Date: Wed, 7 Oct 2009 11:46:15 -0400
Message-ID: <4ACCB7C7.8030807@emulex.com>
References: <1254511016.32739.23.camel@ogier> <87r5tfzqpq.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51442 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbZJGPqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2009 11:46:54 -0400
In-Reply-To: <87r5tfzqpq.fsf@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

We used the aer-inject user space tool on 2.6.31 to test it
http://www.kernel.org/pub/linux/utils/pci/aer-inject/

-- james s

Andi Kleen wrote:
> James Smart <James.Smart@Emulex.Com> writes:
>
>   
>> This patch adds AER support.
>>     
>
> I'm curious -- how did you test that? Did you use the new AER injector in 2.6.31?
>
> -Andi
>
>   
