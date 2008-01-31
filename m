From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 12:13:12 -0500
Message-ID: <47A201A8.4060906@scalableinformatics.com>
References: <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>	 <20080130195635T.tomof@acm.org>	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>	 <47A1EE54.6000005@vlnb.net> <47A1F67C.4020300@scalableinformatics.com> <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scalableinformatics.com ([66.93.0.201]:39695 "EHLO
	mail.scalableinformatics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956AbYAaRNV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 12:13:21 -0500
In-Reply-To: <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, FUJITA Tomonori <tomof@acm.org>, torvalds@linux-foundation.org

Bart Van Assche wrote:

> I have ran some tests with Bonnie++, but found out that on a fast
> network like IB the filesystem used for the test has a really big
> impact on the test results.

This is true of the file systems when physically directly connected to 
the unit as well.  Some file systems are designed with high performance 
in mind, some are not.

> If anyone has a suggestion for a better test than dd to compare the
> performance of SCSI storage protocols, please let it know.

Hmmm... if you care about the protocol side, I can't help.  Our users 
are more concerned with the file system side, so this is where we focus 
our tuning attention.

> 
> Bart Van Assche.

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423
fax  : +1 866 888 3112
cell : +1 734 612 4615
