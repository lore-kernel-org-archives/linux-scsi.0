From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 07 Nov 2003 09:13:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068221599.2286.30.camel@patrh9>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
	 <1067541899.1141.4.camel@ronald.kuetemeier.com>
	 <20031030134850.A9076@beaverton.ibm.com>
	 <1067551081.1138.7.camel@ronald.kuetemeier.com>
	 <1067558384.14409.50.camel@patrh9>
	 <20031031101645.A14729@beaverton.ibm.com>  <3FAAD532.2060300@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:25263 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264448AbTKGQNs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 11:13:48 -0500
In-Reply-To: <3FAAD532.2060300@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: patmans@us.ibm.com, ronald@kuetemeier.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

Ouch, sorry.  Already now I tried splitting off this digression by
changing the Subject line, but I only knew to cc Patrick M, not the
others here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106816572904919

List: linux-scsi
Subject: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 2003-11-07 0:38:36

I will now forward a copy of that to Doug G - that post includes a
rewrite in what I regard as readable .c of the core of plscsi - and I
will then proceed there to answer the other points I see Doug G now
kindly raises.

> ...

A complete build procedure for the 2002-9-22 plscsi we have appears at:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106755844319144

List: linux-scsi
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 2003-10-30 23:59:45

So far offline these past couple of weeks the count is Two people
confused by discovering with their Linux they DO NOT have to substitute
g++ for gcc, and One person confused by discovering that with their
Linux they DO have to substitute gcc for g++.

I believe I do understand the root evil at fault, I'll explain that too.

Pat LaVarre


