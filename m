From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] declare and export scsi_bus_type
Date: Thu, 12 Dec 2002 09:12:03 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212091203.A21539@infradead.org>
References: <Pine.LNX.4.44.0212111943110.13262-100000@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0212111943110.13262-100000@humbolt.us.dell.com>; from Matt_Domsch@Dell.com on Wed, Dec 11, 2002 at 07:46:22PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: linux-scsi@vger.kernel.org, mochel@osdl.org

On Wed, Dec 11, 2002 at 07:46:22PM -0600, Matt Domsch wrote:
> Below please find a patch, written by Pat Mochel, to declare and export
> scsi_bus_type.  My EDD code requires this to be exported in order to walk
> the list of SCSI devices to match what BIOS discovered.

I'm very unhappy with exporting random parts of the scsi midlayer.  In
what way do you need it?  How does your code work with modular scsi?

