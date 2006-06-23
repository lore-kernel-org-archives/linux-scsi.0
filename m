From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [RFC] [PATCH 1/2] introduce crashboot kernel command line parameter
Date: Fri, 23 Jun 2006 18:39:26 -0400
Message-ID: <20060623223926.GD18384@in.ibm.com>
References: <20060623210121.GA18384@in.ibm.com> <E1FttEj-0002JH-00@calista.eckenfels.net>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:2520 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752148AbWFWWjt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 18:39:49 -0400
Content-Disposition: inline
In-Reply-To: <E1FttEj-0002JH-00@calista.eckenfels.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Eckenfels <be-news06@lina.inka.de>
Cc: linux-kernel@vger.kernel.org, Fastboot mailing list <fastboot@lists.osdl.org>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Morton Andrew Morton <akpm@osdl.org>, mike.miller@hp.com

On Fri, Jun 23, 2006 at 11:30:45PM +0200, Bernd Eckenfels wrote:
> Vivek Goyal <vgoyal@in.ibm.com> wrote:
> > +static int __init set_crash_boot(char *str)
> > +{
> > +       crash_boot = 1;
> > +       return 1;
> > +}
> 
> what about a printk? Maybe a combined one which shows some other stuff (init
> level, init shell, apic settings) etc from command line.
> 

In your response, all the people copied on the mail got removed. I am adding
them back.

May be a printk. Not very sure. User can always see in the console messages
list of command line options passed to the kernel.

apic settings are displayed if you pass apic=debug.

Not very sure what do you mean by displaying init level, and init shell
and how that stuff is related to this parameter. 

Thanks
Vivek
