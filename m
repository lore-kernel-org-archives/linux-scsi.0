From: devnetfs <devnetfs@yahoo.com>
Subject: Re: dev nodes assignement ?
Date: Wed, 29 Jan 2003 21:28:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030130052847.73138.qmail@web20417.mail.yahoo.com>
References: <OFA0A98C43.F47155A2-ON87256CBD.00627856-88256CBD.0062D452@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OFA0A98C43.F47155A2-ON87256CBD.00627856-88256CBD.0062D452@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Thanks Bryan and Steve for clarifying my (long standing) doubt :)

Regards,
A.

--- Bryan Henderson <hbryan@us.ibm.com> wrote:
> >Is /dev/sdX scsi dev node assignment based *only* on the pci-slot
> >the HBA's are in? or also upon the order in which the LLDD isloaded?
> 
> First of all, let's acknowledge that the /dev/sdX device special file
> assignments are done manually by the user and are permanent. 
> /dev/sdX is assigned to a major and minor number.
> 
> So the actual question is about minor number assignments.
> >... OR
> >Does each LLDD do a pci-scan and assign [minor numbers] for HBA's
> >that it can handle -- in which case the order of LLDD getting 
> > loaded is alsoimportant in deciding the [minor number].
> Yes.


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
