From: "Bob Copeland" <email@bobcopeland.com>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Tue, 14 Mar 2006 10:12:33 -0500
Message-ID: <b6c5339f0603140712u1ff66dedv96f317fda0d949bb@mail.gmail.com>
References: <NONAMEBgJJ72jYxDwLd000000d3@nonameb.ptu.promise.com>
	 <1142327906.3027.24.camel@laptopd505.fenrus.org>
	 <44168C86.8060107@garzik.org>
	 <1142329204.3027.26.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.204]:8180 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932226AbWCNPMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 10:12:36 -0500
Received: by nproxy.gmail.com with SMTP id x30so1084453nfb
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 07:12:33 -0800 (PST)
In-Reply-To: <1142329204.3027.26.camel@laptopd505.fenrus.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Ed Lin <ed.lin@promise.com>, Andrew Morton <akpm@osdl.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "promise_linux@promise.com" <promise_linux@promise.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 3/14/06, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 2006-03-14 at 04:27 -0500, Jeff Garzik wrote:
> > I thought that was unnecessary if the struct members are ordered such
> > that compiler would not add padding?
>
> the rules for when padding gets added are different for each platform
> though; worst case of adding it is that it serves as documentation that
> the layout matters :)

I thought the worst case of adding it is that GCC produces awful code
when accessing structure members for __attribute__((packed)) items[1].
 Maybe -Wpadded would be better?

[1] http://marc.theaimsgroup.com/?l=linux-kernel&m=108829229128091
