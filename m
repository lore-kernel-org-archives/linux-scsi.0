From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Tue, 2 Aug 2016 09:49:08 +0200
Message-ID: <20160802074908.paqpsy4ucku22oj5@c203.arch.suse.de>
References: <1468311876-4132-1-git-send-email-oneukum@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468311876-4132-1-git-send-email-oneukum-IBi9RG/b67k@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, gregKH-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2016 at 10:24:36AM +0200, Oliver Neukum wrote:
> Some SATA to USB bridges fail to cooperate with some
> drives resulting in no cache being present being reported
> to the host. That causes the host to skip sending
> a command to synchronize caches. That causes data loss
> when the drive is powered down.
> 
> Signed-off-by: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>

Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
