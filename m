From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] scsi: megaraid_sas - Add the dumy readl to force
 PCI flush
Date: Sun, 10 Aug 2008 12:40:11 -0700
Message-ID: <20080810124011.b5e76eb9.akpm@linux-foundation.org>
References: <FFD04EB4FBD32E4B929B6CFDEDA6AA0D632A9F@NAMAIL1.ad.lsil.com>
	<4B6A08C587958942AA3002690DD4F8C31B08093F@cosmail02.lsi.com>
	<20080804174128.a0877c27.akpm@linux-foundation.org>
	<4B6A08C587958942AA3002690DD4F8C31AADD4C1@cosmail02.lsi.com>
	<1218380616.3418.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754122AbYHJTlF@vger.kernel.org>
In-Reply-To: <1218380616.3418.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@linuxfoundation.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Austria, Winston" <Winston.Austria@lsi.com>, "poswald@novell.com" <poswald@novell.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 10 Aug 2008 10:03:36 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-08-05 at 06:27 -0600, Yang, Bo wrote:
> > Thanks Andrew.
> 
> So could we have the corrected patch, please ... at least the pci
> posting flush fix looks like a pure bug fix that's a rc candidate.
> 

I'll send them over now.
