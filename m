From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 13:05:46 +0100
Message-ID: <3790b5ad-c02f-6406-173b-f2a0563f642b@googlemail.com>
References: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
 <20170705073928.GA4076@linux-x5ow.site>
 <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
 <20170705084447.GD4076@linux-x5ow.site>
 <20170705084810.GE4076@linux-x5ow.site>
 <d92e31ed-db7f-aa4b-5dfd-3f6df4a49ea9@googlemail.com>
 <20170705115235.GF4076@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35094 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdGEMHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:07:50 -0400
Received: by mail-wm0-f51.google.com with SMTP id w126so220002459wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:07:49 -0700 (PDT)
In-Reply-To: <20170705115235.GF4076@linux-x5ow.site>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org



On 05/07/17 12:52, Johannes Thumshirn wrote:
> On Wed, Jul 05, 2017 at 10:06:49AM +0100, Chris Clayton wrote:
>> I'll do this  and send dmesg(?) output as soon as I've got scsi_logging_level installed.
> 
> Hi Chris,
> 
> does this reproducer work (i.e. output FAIL) for you?
> 
Hi Johannes.

Yes, I get:

[chris:~/rpm/build]$ su -c "./nerotest /dev/sg0"
Password:
write: Invalid argument
FAIL


Chris
