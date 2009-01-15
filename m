From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 17:23:00 -0500
Message-ID: <496FB744.90501@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de> <496F8C91.9050208@cybernetics.com> <496FA001.1000501@s5r6.in-berlin.de> <496FAE09.2040207@cybernetics.com> <496FB168.6080407@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2010 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935658AbZAOWXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 17:23:02 -0500
In-Reply-To: <496FB168.6080407@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Tony Battersby wrote:
>   
>> OK, so your argument now seems to be that the code just might in
>> practice work correctly, but in theory it is not philosophically right,
>> semantically pure, or politically correct
>>     
>
> Nonsense.
>
> I wrote that there is a bug if you have a reference while the reference
> count is zero.
>   
Being pragmatic, I call that a _philosophical_ objection rather than a
bug because the code does actually work in practice as far as I can
tell.  But you can call it a bug if you like.  If you want me to give in
and call it a bug, then you will have to come up with an actual case
where the code fails to do the right thing - memory use after free,
double free, memory leak, oops, etc.

Tony

