From: Christoph Hellwig <hch@infradead.org>
Subject: Re: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 13:17:24 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212131724.A6354@infradead.org>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBA26@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70652A801D9E0C469C28A0F8BCF49CF9012EBA26@itmi1mx2.corp.emc.com>; from Ballabio_Dario@emc.com on Wed, Feb 12, 2003 at 07:47:01AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ballabio_Dario@emc.com
Cc: manfred@colorfullife.com, warp@mercury.d2dc.net, linux-scsi@vger.kernel.org

On Wed, Feb 12, 2003 at 07:47:01AM -0500, Ballabio_Dario@emc.com wrote:
> The enclosed patch applies to 2.5.60 and fixes the irq issue when calling
> scsi_register for both eata and u14-34f drivers.

Any chance you could explain us

(1) what does this lock protect
(2) why does it need to disable interrupts

