From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Tue, 26 May 2015 13:02:57 +0200
Message-ID: <556452E1.9020308@suse.cz>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>	<54AC0A17.8020405@redhat.com>	<20150128001837.GE17677@kroah.com>	<CAHTgTXU1GV8JszqJojk9ML7f1yEtERHY0VjrnjX+OMh4Z_=t0g@mail.gmail.com>	<552BC234.4020000@redhat.com>	<20150426092719.GA1460@kroah.com>	<553E28DC.1040100@redhat.com>	<20150427125529.GA18817@kroah.com>	<553E354B.90208@redhat.com>	<20150502175621.GA15525@kroah.com> <CAHTgTXX9tm-tdUPzWXd9SJB_MUanMrNe1x9hD9DzU9R5cmuNnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35120 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbbEZMzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2015 08:55:24 -0400
In-Reply-To: <CAHTgTXX9tm-tdUPzWXd9SJB_MUanMrNe1x9hD9DzU9R5cmuNnQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinson Lee <vlee@twopensource.com>, Greg KH <greg@kroah.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org, Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org

On 05/22/2015, 09:19 PM, Vinson Lee wrote:
> Please use the following list of kernels and patches for backporting.
> 
> 3.18, 3.19
> 3b74729878 hpsa: turn off interrupts when kdump starts
> 
> <= 3.17
> 132aa220b4 hpsa: refine the pci enable/disable handling
> 859c75aba2 hpsa: add missing pci_set_master in kdump path
> 3b74729878 hpsa: turn off interrupts when kdump starts

Applied to 3.12. Thanks.

-- 
js
suse labs
