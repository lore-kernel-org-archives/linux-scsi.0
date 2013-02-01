From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: How to online remove an error scsi disk from the system?
Date: Fri, 01 Feb 2013 11:20:05 +0000
Message-ID: <510BA4E5.3030605@redhat.com>
References: <510B5CFC.2040801@tao.ma> <510B749E.8020501@acm.org> <510B904B.4050508@redhat.com> <510B9213.1040508@tao.ma> <510B93EE.8000304@redhat.com> <510BA370.1040309@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3BAMIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 07:08:19 -0500
In-Reply-To: <510BA370.1040309@tao.ma>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On 02/01/2013 11:13 AM, Tao Ma wrote:
>> You don't mention the versions of the kernel and driver you're using -
>> if the system is in production I would suggest contacting who ever
>> normally provides support for the kernel and distribution that you are
>> running.
> We use CentOS6.2 and the kernel version is 2.6.32-220.23.1.

This is ancient, even by CentOS or RHEL standards. There are thousands 
of patches in more recent kernels (either at kernel.org or in the 
updates in CentOS repositories).

Nobody on linux-kernel or the other lists you copied is going to want to 
investigate problems on such an old kernel - you'll need to either 
reproduce with something current or seek assistance from the CentOS 
community (who will probably tell you to update your kernel first anyway).

Regards,
Bryn.


