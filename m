From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Sym53C8xx Driver Hardening
Date: 26 Jul 2002 00:53:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1027641218.11857.0.camel@irongate.swansea.linux.org.uk>
References: <20020725005122.I4924-100000@localhost.my.domain>
	<10207251533.ZM1198000@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <10207251533.ZM1198000@classic.engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: =?ISO-8859-1?Q?G=E9rard?= Roudier <groudier@free.fr>, Rogier Wolff <R.E.Wolff@BitWizard.nl>, "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>, linux-scsi@vger.kernel.org

On Thu, 2002-07-25 at 23:33, Jeremy Higdon wrote:
> Also, with some sorts of errors, one might suspect that the device has
> DMA'd data into the wrong place in memory.

It depends on the environment. In telco stuff its often better to sound
the alarms and pray. Gerard is right that policy must be configurable
 
> If hardware can place a fence around DMA (such that DMA to unintended
> locations is impossible), then you might not want to panic in such
> situations, assuming that you can retry.

Doable on real computers with an iommu

