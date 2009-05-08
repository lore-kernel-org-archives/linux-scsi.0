From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Fri, 08 May 2009 18:13:12 +0900
Message-ID: <4A03F7A8.9090204@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>	 <49FA0349.3090706@garzik.org>	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>	 <49FEA127.1000905@kernel.org>	 <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>	 <49FFB275.7000507@kernel.org> <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbZEHJNL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 05:13:11 -0400
In-Reply-To: <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com, dm-devel@redhat.com

Dan Williams wrote:
> On Mon, May 4, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
>> Pushing this in the kernel without updating dm-raid is kind of
>> pointless.  Who should I be poking to get the userland part moving?
> 
> Dmraid is not the only potential user.  Mdadm will also care about
> this as I have seen a report that points to a user having what looks
> like an HPA issue with an Intel(R) Matrix array.  So, there are two
> immediate users for this interface.  Heinz is the right person to poke
> for dmraid updates.  I'll handle the mdadm update.

Alright, then.  With Jeff's reluctant ack and scheduled mdadm update,
I guess this one can go upstream.  I'll refresh the patchset and
repost.  Umm... BTW do I have Heinz's mail address right?

Thanks.

-- 
tejun
