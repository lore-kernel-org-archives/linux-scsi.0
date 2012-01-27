From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] iscsi: fix setting of pid from netlink skb
Date: Fri, 27 Jan 2012 01:37:42 -0600
Message-ID: <4F225446.1000709@cs.wisc.edu>
References: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu> <1327633991-2615-2-git-send-email-michaelc@cs.wisc.edu> <CAO+b5-o8GoYaTx=c9E+8vDJdkDR53YceUCQTu+VSpO9ZUeL6iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47404 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2A0Hhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2012 02:37:50 -0500
In-Reply-To: <CAO+b5-o8GoYaTx=c9E+8vDJdkDR53YceUCQTu+VSpO9ZUeL6iA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org

On 01/27/2012 01:04 AM, Bart Van Assche wrote:
> On Fri, Jan 27, 2012 at 4:13 AM, <michaelc@cs.wisc.edu> wrote:
>> NETLINK_CREDS's pid now returns 0, so I guess we are supposed to
>> be using NETLINK_CB. This changed while the patch to export the
>> pid was getting merged upstream, so it was not noticed until both
>> the network and iscsi changes were in the same tree.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> If my analysis is correct this patch has not only to be applied on the
> master branch but also on kernel 3.2. Shouldn't "Cc:
> stable@vger.kernel.org #3.2" be added here ? See also
> http://www.spinics.net/lists/netdev/msg185565.html.
> 

The iscsi code that uses the pid just got merged in the 3.3 feature
window, so no need.

Also for stable, I think we normally just tell James it should go in
stable and then he does some magic. In the past, when he knows it should
go there, when the patch gets merged and sent upstream the stable people
were notified automagically.
