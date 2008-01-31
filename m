From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
Date: Thu, 31 Jan 2008 18:52:40 +0200
Message-ID: <47A1FCD8.6050906@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47A1ABF8.4050408@upb.de> <47A1C0A5.7090303@panasas.com> <Pine.LNX.4.64.0801311736110.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11141 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933417AbYAaQw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 11:52:56 -0500
In-Reply-To: <Pine.LNX.4.64.0801311736110.4864@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: =?ISO-8859-1?Q?Sven_K=F6hler?= <skoehler@upb.de>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

On Thu, Jan 31 2008 at 18:39 +0200, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> Hi,
> 
> On Jan 31 2008 14:35, Boaz Harrosh wrote:
>> Thanks, Perhaps someone else then. 
>> Anyone with gdth HW that can test patches?
> 
> Is bisecting down the existing chain and finding the bad commit 
> sufficient? (I also take new patches.)
Most certainly. If you are willing, please... I'm looking for someone
responsive.

first -  enable debug prints (see the original post)
         and send me the prints.
second - bisection could be grate yes.
third - accepting patches and testing could be grate, thanks.

> 
>> Your lspci said: "Intel Corporation RAID Controller" Matthew
>> is there a gdth card lying around in an Intel lab near you?
>>
>> James do we need to mark gdth BROKEN for 2.6.24 and higher?
> 
> I say revert it for the time being.

It could be reverted for 2.6.24.x  maintenance releases but for 2.6.25-xxx
it cannot as it will not compile, and the fix to that is what you see in code.

Boaz
