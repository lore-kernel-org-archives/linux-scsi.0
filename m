From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: aacraid broken in git
Date: Sat, 19 Apr 2008 13:56:47 -0700
Message-ID: <86802c440804191356t1519535cje0636414ec9678db@mail.gmail.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
	 <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.242]:34147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756129AbYDSU4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 16:56:48 -0400
Received: by rv-out-0506.google.com with SMTP id k29so670778rvb.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Apr 2008 13:56:48 -0700 (PDT)
In-Reply-To: <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Apr 19, 2008 at 5:33 AM, Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:
> Why is ACPI disabling the interrupt? Maybe do bisects on the ACPI subsystem
> as well.
probe fail, acpi disable irq routing for it.

YH
