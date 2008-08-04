From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Mon, 04 Aug 2008 08:31:48 -0500
Message-ID: <1217856708.3318.5.camel@localhost.localdomain>
References: <1217786532.4179.24.camel@localhost.localdomain>
	 <20080804043053.GB10519@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20080804043053.GB10519@colo.lackof.org>
Sender: linux-pci-owner@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-08-03 at 22:30 -0600, Grant Grundler wrote:
> On Sun, Aug 03, 2008 at 01:02:12PM -0500, James Bottomley wrote:
> > We're getting a lot of storage drivers blamed for interrupt misrouting
> > issues.  This patch provides a standard way of reporting the problem
> > ... and, if possible, correcting it.
> 
> James,
> Can you add a paragraph to Documentation/pci.txt about the usage
> of the new API?

When there actually is a new API, sure.

James
