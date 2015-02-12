From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 12 Feb 2015 07:04:42 -0600
Message-ID: <201502121304.t1CD4g29020518@wind.enjellic.com>
References: <bart.vanassche@sandisk.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:35999 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbbBLNFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2015 08:05:19 -0500
In-Reply-To: Bart Van Assche <bart.vanassche@sandisk.com>
       "Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers" (Feb  9,  2:16pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, greg@enjellic.com, Christoph Hellwig <hch@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Feb 9,  2:16pm, Bart Van Assche wrote:
} Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target driv

> On 02/03/15 11:06, Dr. Greg Wettstein wrote:
> > It takes a six line patch to the in-kernel Qlogic target driver for
> > SCST to leverage and contribute positively to the state of the
> > in-kernel driver.  A six line patch, which if we were engaging in
> > grounded engineering discussions, implements an interface which we
> > haven't found anyone who suggests is unfounded.

> Hi Greg,

Hi Bart, I hope your week is going well.

> Thanks for your feedback. Although I certainly value your work,
> please note that what I proposed goes further than what you have
> done. If I understood your e-mails correctly what you have done is
> to unify the API between the QLogic initiator and target drivers for
> SCST and LIO. My proposal comprises not only a unification of the
> initiator drivers but also of the target drivers.

Just to clarify issues for discussion our work on the SQATGT driver
centered exclusively on the target component of the Qlogic driver.

Our work focused on providing an SCST equivalant to the tcm_qla2xxx.c
driver which the in-kernel implementation of the Qlogic target driver
uses to interface with the TCM target core.  The {scst,tcm}_qla2xxx
drivers register a function dispatch structure with the Qlogic
hardware target driver, qla_target.c.  These drivers take the actions
requested by the hardware driver and translate them into the necessary
target core processing functions.

As I have indicated the scst_qla2xxx driver could be distributed
separately from the kernel since it only relies on symbols which are
exported from the Qlogic driver.  I'm not familiar with IB and such
but it seems to be a reasonable architecture for both camps of
interest to collaborate on.

> Last week I finally found the time to start working on an sample
> implementation of such a unified driver. I hope that I will be able to
> make that code available for review somewhere next week.

Let us know when that becomes available since we would certainly like
to be assisting and supporting whatever the community agrees to as a
solution.

> Bart.

Have a good week.

}-- End of excerpt from Bart Van Assche

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"... Doc (interviews) is closest in look&feel to a Windows word-processor.
 It's even slow.  Very slow.  Hard to set up fonts and printing in the
 version I have...."
                                -- David Johnson
