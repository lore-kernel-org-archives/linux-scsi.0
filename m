From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Thu, 7 Aug 2008 20:47:45 +0200
Message-ID: <6cf6b73e0808071147o76817aabhc363feb41b0a176c@mail.gmail.com>
References: <20080731071851.GA30534@parisc-linux.org>
	 <20080731162449X.fujita.tomonori@lab.ntt.co.jp>
	 <20080731130422.GC30534@parisc-linux.org>
	 <20080801001839L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:61814 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbYHGSrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2008 14:47:47 -0400
Received: by mu-out-0910.google.com with SMTP id w8so902847mue.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2008 11:47:45 -0700 (PDT)
In-Reply-To: <20080801001839L.tomof@acm.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

Can we push this patches to Linus?
They fix the regression and do not seem to introduce a new one
(couldn't find any while testing it).
