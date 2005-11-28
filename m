From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Mon, 28 Nov 2005 17:26:55 -0500
Message-ID: <438B842F.4030103@redhat.com>
References: <20051121022158.82709.qmail@web88012.mail.re2.yahoo.com> <1133214118.3325.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:29930 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932243AbVK1W1L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 17:27:11 -0500
In-Reply-To: <1133214118.3325.59.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Graham Knap <graham.knap@rogers.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2005-11-20 at 21:21 -0500, Graham Knap wrote:
>> Sure enough, the kernel now boots. I'll attach the "dmesg" output here.
>>
>> Do you guys have a "final" patch in mind?
>>
>> Let me know if there are other tests you'd like me to run. Now that I
>> know how to do this, I should be able to turn around test results
>> fairly quickly.
> 
> OK, try the attached.  If it works out, I'll soak it in -mm for a while
> and then try to put it in as a bug fix for 2.6.15.

[ snip ]

Nice patch, looks like the correct thing to do to me.

