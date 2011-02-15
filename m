From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sct erc does not work with megaraid
Date: Tue, 15 Feb 2011 13:33:20 -0500
Message-ID: <4D5AC6F0.9070000@interlog.com>
References: <4D5A5388.3010208@ngs.ru> <4D5A9FE9.9020409@interlog.com> <4D5AB51A.2010002@interlog.com> <4D5ABA7D.9030006@ngs.ru>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48125 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab1BOSda (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2011 13:33:30 -0500
In-Reply-To: <4D5ABA7D.9030006@ngs.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bokhan Artem <aptem@ngs.ru>
Cc: linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>

On 11-02-15 12:40 PM, Bokhan Artem wrote:
>
>> Just doing some tests comparing SAT compliance in libata
>> and a LSI SAS 9212-4i4e controller with the latest firmware.
>> I would expect a Megaraid controller with recent firmware to
>> behave in the same way as a the 9212 (mpt2sas driver).
>>
> LSISAS2008based cards are totally different product, so there no any need to
> compare it with megaraid...

In regard to the SAT layer in both products, I believe
you are wrong.

Anyway please try the same sg_sat_identify utility (from
the sg3_utils package) as shown in my previous post on
your Megaraid and send me the result.

Also please send me the output from the failing smartctl
command after adding '-r ioctl,3' to the invocation.

Doug Gilbert
