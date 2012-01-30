From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add
Date: Mon, 30 Jan 2012 11:50:33 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6048BC1A59A@inbmail02.lsi.com>
References: <20120125015725.GA2938@tuon>
 <A6888A6805518E4EA4AF7072A28264A6048BC1A2FE@inbmail02.lsi.com>
 <20120125080728.GA1957@tuon> <20120128050209.GD31749@tuon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:32794 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab2A3GUo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2012 01:20:44 -0500
In-Reply-To: <20120128050209.GD31749@tuon>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kevin Shanahan <kmshanah@disenchant.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

Ok. Posted this patch to stable kernel today.

Regards,
Nagalakshmi


-----Original Message-----
From: Kevin Shanahan [mailto:kmshanah@disenchant.net] 
Sent: Saturday, January 28, 2012 10:32 AM
To: Nandigama, Nagalakshmi
Cc: linux-scsi@vger.kernel.org; stable@vger.kernel.org
Subject: Re: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add

On Wed, Jan 25, 2012 at 06:37:28PM +1030, Kevin Shanahan wrote:
> On Wed, Jan 25, 2012 at 10:52:34AM +0530, Nandigama, Nagalakshmi wrote:
> > Request to apply the attached patch and test.
> >  scsi-misc-2[1].6.git-2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45.patch
> 
> Great, that fixes the issue!

Any chance this patch can go into 3.2.3?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45

Makes my Intel/LSI SAS controller usable, working great on top of
3.2.1 for several days now.

Thanks,
Kevin.
