From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH 02/22] bfa: Do not call pci_enable_msix() once it failed
Date: Thu, 13 Feb 2014 18:39:10 +0100
Message-ID: <20140213173910.GA26610@dhcp-26-207.brq.redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
 <a2c28d9475021b99aa35bba9e84f4237d6b32cde.1391512266.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a2c28d9475021b99aa35bba9e84f4237d6b32cde.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 04, 2014 at 12:16:48PM +0100, Alexander Gordeev wrote:
> Function pci_enable_msix() should not be called again in
> case it threw a negative errno.

Anil, Vijaya,

Any feedback on bfa patches?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
