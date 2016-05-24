From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [uas/scsi] untagged commands?
Date: Tue, 24 May 2016 11:25:10 +0200
Message-ID: <903e0bae-2a7e-104d-ab46-8cb0dfa9b5a3@redhat.com>
References: <CAGnHSE=RB1_777Mnj8enxDPmga0p7QgZkyFwg9je5FQmzO=qDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcEXJZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2016 05:25:16 -0400
In-Reply-To: <CAGnHSE=RB1_777Mnj8enxDPmga0p7QgZkyFwg9je5FQmzO=qDA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Hi,

On 24-05-16 10:18, Tom Yan wrote:
> In this commit:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/usb/storage/uas.c?id=198de51dbc3454d95b015ca0a055b673f85f01bb
>
> There is the following comment:
>> 1 tag is reserved for untagged commands
>
> So my question is, what exactly are "untagged commands"?

https://en.wikipedia.org/wiki/Tagged_Command_Queuing

Regards,

Hans
