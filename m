From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: SCSI target subsystem
Date: Sat, 3 May 2008 11:41:41 +0200
Message-ID: <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
	 <481B5AB8.5030108@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:2848 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbYECJlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 05:41:42 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1251838fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 03 May 2008 02:41:41 -0700 (PDT)
In-Reply-To: <481B5AB8.5030108@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

On Fri, May 2, 2008 at 8:17 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> I wrote all above to support my at first glance shocking conclusion that
> SCSI target subsystem is completely new subsystem of the kernel and it
> should live on its own with its own maintainer! This is the same as with the
> current interaction between SCSI and block subsystems in the kernel: SCSI
> uses block's functionality, but that doesn't mean that block and SCSI are
> the same subsystem.

Hello Tomo,

Due to the IET and STGT projects you have a lot of experience with
implementing SCSI target frameworks. What is your opinion about how a
kernel space SCSI target framework should fit in the Linux kernel ?

Bart.
