From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 1/2] mptfusion, mpt2sas, mpt3sas: Don't remove dead IOC
 PCI device
Date: Wed, 6 Mar 2013 13:10:09 -0500
Message-ID: <20130306131009.0dcc618e@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1303041052420.1736@jlaw-desktop.mno.stratus.com>
	<B2FD678A64EAAD45B089B123FDFC3ED75E690FE449@inbmail01.lsi.com>
	<CAErSpo5BFPE3CxycQpER9A4c-gpdRuMKDbnuvr7BXL-hSdi2aQ@mail.gmail.com>
	<B2FD678A64EAAD45B089B123FDFC3ED75E690FE5DB@inbmail01.lsi.com>
	<CAErSpo7ghmLKqrt4eMw+JKXKR=f8r1XnGZL8uGLGSFFd2yRSyQ@mail.gmail.com>
	<B2FD678A64EAAD45B089B123FDFC3ED75E690FE5E1@inbmail01.lsi.com>
	<B2FD678A64EAAD45B089B123FDFC3ED75E690FE79A@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:38422 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3CFSNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Mar 2013 13:13:54 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED75E690FE79A@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-scsi@vger.kernel.org, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, Support <support@lsi.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-pci@vger.kernel.org

On Wed, 6 Mar 2013 12:01:37 -0500
"Desai, Kashyap" <Kashyap.Desai@lsi.com> wrote:

> Please reject this Patch. I have made required changes which will
> remove PCI system's call from mptsas/mpt2sas/mpt3sas. I will be
> sending that patch to upstream. Currently waiting to do more testing
> on new patch.
> 
> Thanks for constructive feedback.
> 
> 
> ` Kashyap

Kashyap,

I'll be glad to test your patch against mptsas/mpt2sas LSI hardware here
at Stratus with respect to surprise PCI hotplug.  Thanks for looking
into this.

Regards,

-- Joe
