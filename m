From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: SCSI target subsystem
Date: Sun, 4 May 2008 17:53:32 +0200
Message-ID: <e2e108260805040853r2dbd0b3bu297408c0c77819c5@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
	 <481B5AB8.5030108@vlnb.net>
	 <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
	 <20080503095314.GX14976@parisc-linux.org>
	 <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:44250 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYEDPxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 11:53:34 -0400
Received: by fk-out-0910.google.com with SMTP id 18so334925fkq.5
        for <linux-scsi@vger.kernel.org>; Sun, 04 May 2008 08:53:32 -0700 (PDT)
In-Reply-To: <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

On Sat, May 3, 2008 at 12:39 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> To answer your question: as you noticed, I did not yet contribute any
> code to the SCST project. I'm an iSCSI/iSER/SRP user. I'd like to have
> a SCSI target framework available on Linux that is as fast as
> possible, as reliable as possible, as standards compliant as possible,
> well maintained and for which all kernel code is integrated in the
> mainstream Linux kernel. I'm probably sharing this desire with all
> STGT, IET, SCST and LIO users.

Hello Matthew,

To be complete I should have mentioned that there already exists an
FCoE target implementation for SCST. I'm still learning about FCoE.
What I read about it is that FCoE has more to offer with regard to
storage management than iSCSI/iSER/SRP ?

See also: http://www.open-fcoe.org/openfc/wiki/index.php/Quickstart

Bart.
