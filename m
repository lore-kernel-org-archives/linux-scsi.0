From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Fri, 8 Nov 2002 04:53:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108045305.A22307@infradead.org>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com> <20021107164152.GD1292@beaverton.ibm.com> <20021108012047.A17391@infradead.org> <20021108022158.GD1292@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021108022158.GD1292@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Nov 07, 2002 at 06:21:58PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 06:21:58PM -0800, Mike Anderson wrote:
> Is the disagreement the function name, bus name, or the concept of
> registering these drivers with sysfs?

Well, they're not really busses, and I hate misleading analogies :)

No, my real issues is that the scsi_devices should be attached to
a bus hanging of the HBA, as that's what they physically do, not of
some pseudo-bus for the higherlevel devices.

> Do you see a problem with "scsi_upper_driver_register" being added now?

I'd prefer if we'd let it stay as-is for now.

