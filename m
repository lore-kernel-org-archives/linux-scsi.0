From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Thu, 23 Oct 2008 14:55:59 -0700
Message-ID: <200810231455.59437.jbarnes@virtuousgeek.org>
References: <1217786532.4179.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday, August 3, 2008 11:02 am James Bottomley wrote:
> We're getting a lot of storage drivers blamed for interrupt misrouting
> issues.  This patch provides a standard way of reporting the problem
> ... and, if possible, correcting it.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Ok, per our discussion at the PCI BoF I applied this, so now you can apply the 
fusion and other bits to help debug issues.

Thanks,
Jesse
