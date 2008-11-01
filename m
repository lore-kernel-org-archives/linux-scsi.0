From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH v5] cmdfilter: clean up sysfs interface
Date: Sat, 1 Nov 2008 18:56:20 +0100
Message-ID: <6cf6b73e0811011056w7f829f4fq485f6299122ed643@mail.gmail.com>
References: <20080809033935.GI8618@parisc-linux.org>
	 <6cf6b73e0808090309y94a071dh3079d4e89cc1154f@mail.gmail.com>
	 <20080809135520.GJ8618@parisc-linux.org>
	 <20080810163206X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:21143 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYKAR4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Nov 2008 13:56:22 -0400
Received: by qw-out-2122.google.com with SMTP id 3so790515qwe.37
        for <linux-scsi@vger.kernel.org>; Sat, 01 Nov 2008 10:56:21 -0700 (PDT)
In-Reply-To: <20080810163206X.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, pjones@redhat.com, dougg@torque.net, dan.j.williams@intel.com, James.Bottomley@hansenpartnership.com

The sysfs bits got disabled in 2.6.27 in commit
2dc75d3c3b49c64fd26b4832a7efb75546cb3fc5 .
What are the remaining bugs that needs to get fixed to reenable it for
2.6.28 (or if its too late .29) ?
