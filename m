From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/4] Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver binding documentation
Date: Thu, 12 Dec 2013 22:09:22 +0100
Message-ID: <201312122209.22742.arnd@arndb.de>
References: <1386833435-30498-1-git-send-email-lho@apm.com> <52A9C8C5.8030809@interlog.com> <1386867353.5985.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1386867353.5985.7.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dgilbert@interlog.com, Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 12 December 2013, James Bottomley wrote:
> > > I'm completely confused by this description. Can you rephrase this?
> > > It sounds like the only possible values are <1 3 7> for this property.
> > 
> > Most likely Gen1, Gen2 and Gen3 are SATA-speak corresponding to SAS's
> > G1, G2 and G3:
> > 
> > G1   Gen1     1.5 Gbps
> > G2   Gen2     3 Gbps
> > G3   Gen3     6 Gbps
> > G4   -        12 Gbps
> > G5   -        24 Gbps
>
> Electrically, SAS phys and SATA phys are identical.  We already have a
> SAS phy abstraction in libsas ... when looking at a separable phy
> implementation, shouldn't we be doing something that works for both
> instead of just SATA?

This PHY is also used for ethernet and for PCIe, even though the driver
handles only the SATA case so far. Can the SAS abstraction deal with this?

How do you describe a SAS PHY in DT?

	Arnd
