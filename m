From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Wed, 19 Dec 2007 12:08:23 +0200
Message-ID: <4768ED97.9080905@panasas.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org>	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>	 <47666904.8060605@panasas.com> <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14727 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751863AbXLSKIg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 05:08:36 -0500
In-Reply-To: <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Dec 19 2007 at 10:48 +0200, "Filippos Papadopoulos" <psybases@gmail.com> wrote:
> On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have found one problem. Please try patch [2] below and report.
>> If it still fails try to enable debugging by setting with patch [1]
>> these values at top of drivers/scsi/initio.c. And send dmsgs.
>>
>> Boaz
>>
> 
> 
> I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
> system hangs after some seconds when the initio driver loads.
> I will try patch[1] next week to see what happens.
>
Please first pull from scsi-rc-fixes git-tree first. it has a couple
of other fixes for initio plus patch[2] included.
(maybe its already in -mm tree I'm not sure).
If still don't work try enable debug with patch[1] and send messages

> Would it be better to open a bug report at bugzilla?
>
I would prefer linux-scsi ml

<snip>

Boaz
