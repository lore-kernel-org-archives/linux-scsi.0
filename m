From: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Tue, 05 Aug 2008 19:42:49 +0200
Message-ID: <48989119.8060708@free.fr>
References: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org> <489872F7.8050703@torque.net> <48987856.9030804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:44882 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133AbYHERlj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2008 13:41:39 -0400
In-Reply-To: <48987856.9030804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: dougg@torque.net, Alan Stern <stern@rowland.harvard.edu>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

Boaz Harrosh wrote:
> Douglas Gilbert wrote:
> 
> Do you know if he used the white-list or if his device returned
> SPC-3 compliance. The reason I ask is because all the devices I have
> here from usb sticks to external boxes and converters all work with
> 96 bytes sense but all report spc-2
>
He used the white-list. At the moment I don't know if some device report 
at spc-3, but it could be a easy way to white-list them.


Matthieu
