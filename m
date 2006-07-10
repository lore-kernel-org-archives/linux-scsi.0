From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 10:08:15 -0700
Message-ID: <20060710170815.GD30179@us.ibm.com>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com> <44B27F74.9000806@torque.net> <1152549628.7275.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:6361 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1422710AbWGJRIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 13:08:13 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6AH8DZV012126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 13:08:13 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6AH7NRN312104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 11:07:23 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6AH8CQc015013
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 11:08:12 -0600
Content-Disposition: inline
In-Reply-To: <1152549628.7275.24.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Mon, 2006-07-10 at 12:25 -0400, Douglas Gilbert wrote:
> > aic94xx driver is loaded, it replaces the running version
> > of the sequencer code with its own copy. If the reader
> > sees numerous "tmf timeout" messages in their log then
> > there is a good chance old sequencer code is the cause.
> 
> And really, this driver needs to use the firmware loader, so this
> no-longer becomes an issue.

Well as I mentioned before it would be good if the distro support was more
widespread before we cutoff the old method. I received a lot of questions
recently from qla2xxx users who where use to doing kernel testing with not
the latest distro version. They ran into issues when trying
linux-2.6.18-rc1 (or git tree versions) along with trying to get the
firmware loading support to work on there distro. 

-andmike
--
Michael Anderson
andmike@us.ibm.com
