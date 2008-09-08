From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Mon, 08 Sep 2008 10:27:00 +0300
Message-ID: <48C4D3C4.80806@panasas.com>
References: <489656EC.5000602@torque.net> <Pine.LNX.4.44L0.0808041147580.3818-100000@iolanthe.rowland.org> <20080804174524.GL4322@one-eyed-alien.net> <48983F5D.6060903@panasas.com> <48C42D02.7080809@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20026 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbYIHH2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2008 03:28:04 -0400
In-Reply-To: <48C42D02.7080809@free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthieu castet <castet.matthieu@free.fr>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

matthieu castet wrote:
> Hi,
> 
> Boaz Harrosh wrote:
>> There was a correct and simple patch proposed that fixes this problem
>> the right way:
>> http://marc.info/?l=linux-usb&m=121762869915609&w=2
>>
>> Doug could you please test this patch to see if it fixes your device?
>>
>> scsi-core already gives drivers complete control on what sense_size to
>> fetch. It is a parameter to the scsi_eh_prep_cmnd() call. So no need
>> for slave_configure(), default value, and all that loop.
>>
>> Matthieu castet <castet.matthieu@free.fr> wrote ...
>>> we have got report from 2 users that scsi sat (to do ata passthrough)  was not fully \
>>> working with some usb bridge (maxtor and western digital). Everything works except \
>>> the sense result was incomplete [1].
>>>
>>>
>>> After some investigation, they need a sense size different of 18 (at least 22). [2]
>>>
>>> Because some devices can crash if the sense size is different of 18, in order to not \
>>> break these devices a flag that is set either by unusual entries, either for spc3 or \
>>> latter devices is used.
>>>
>>>
>>> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
>> Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
>>
> What the status of that.
> 
> Should I try to resubmit that patch on linux-usb ?
> 

I see the To: is me. But I'm not a USB guy at all.

Like you said, I too think the best is to freshen up the 
patch for latest USB tree and send it to the USB mailing
list.

Cheers
Boaz
