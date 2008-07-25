From: "rae l" <crquan@gmail.com>
Subject: Re: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with __func__
Date: Sat, 26 Jul 2008 01:08:38 +0800
Message-ID: <91b13c310807251008o361bc39drfb6aa227cd9fd2f9@mail.gmail.com>
References: <1216954114-31949-1-git-send-email-crquan@gmail.com>
	 <20080725164253.GA7355@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:6889 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYGYRIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2008 13:08:40 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1811597tic.23
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2008 10:08:38 -0700 (PDT)
In-Reply-To: <20080725164253.GA7355@tree.beaverton.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 12:42 AM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> On Fri, Jul 25, 2008 at 10:48:33AM +0800, Denis ChengRq wrote:
>> Signed-off-by: Denis ChengRq <crquan@gmail.com>
>
> No justification or changelog?
I think no more explanation needed, the subject is definite.

and no justification happened here, (there are justifications otherwhere)

>> -             __FUNCTION__)
>> +             __func__)
>
> include/linux/kernel.h:503:#define __FUNCTION__ (__func__)
This solution is not completely,

>
> I assume you're trying to kill this?
Eventually we will need a replace in the whole tree:

grep -RsInw __FUNCTION__ . |xargs sed -i -e 's/__FUNCTION__/__func__/g'
