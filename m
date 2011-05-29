From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/42 RESEND+NEW] Target updates for May 27
Date: Sat, 28 May 2011 19:23:43 -0700
Message-ID: <4DE1AE2F.70705@redhat.com>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com> <1306534540.23461.203.camel@haakon2.linux-iscsi.org> <20110527223538.GA26592@infradead.org> <1306539563.23461.229.camel@haakon2.linux-iscsi.org> <20110528074333.GA22382@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab1E2CXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2011 22:23:55 -0400
In-Reply-To: <20110528074333.GA22382@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 05/28/2011 12:43 AM, Christoph Hellwig wrote:
> On Fri, May 27, 2011 at 04:39:23PM -0700, Nicholas A. Bellinger wrote:
>> I will send these out as they are committed into lio-core-2.6.git for
> 
> Nick, the whole point is to get things reviewed before they are
> commited.

I guess this is my fault for not CCing linux-scsi. I'm working on tcm
cleanups and have been sending them to linux-iscsi-target-dev, because
there are a lot of them. Aren't you guys on that list too?

In any case, here's my git tree for review hch, I've been developing
against nab's lio-41, under the perhaps mistaken assumption that it all
would go in and then patched up to snuff:

git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab

My work is completely unrelated to the user/kernel auth question, but
was done under the assumption that nab's iscsi fabric was going to go in.

Regards -- Andy
